import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/iap_products.dart';
import 'credit_service.dart';

/// 内购服务（仅 iOS）
class IapService extends ChangeNotifier {
  static final IapService _instance = IapService._internal();
  factory IapService() => _instance;
  IapService._internal();

  static const _processedPurchasesKey = 'processed_purchase_ids';

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  bool _isAvailable = false;
  bool _isLoadingProducts = false;
  String? _purchasingProductId;
  String? _lastMessage;
  String? _lastError;
  List<ProductDetails> _products = [];

  bool get isAvailable => _isAvailable;
  bool get isLoadingProducts => _isLoadingProducts;
  bool get hasProducts => _products.isNotEmpty;
  String? get purchasingProductId => _purchasingProductId;
  String? get lastMessage => _lastMessage;
  String? get lastError => _lastError;
  List<ProductDetails> get products => List.unmodifiable(_products);

  Future<void> initialize() async {
    if (!isIapSupported) {
      _isAvailable = false;
      notifyListeners();
      return;
    }

    _isAvailable = await _iap.isAvailable();
    if (!_isAvailable) {
      notifyListeners();
      return;
    }

    _subscription ??= _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: (Object error) {
        _lastError = '购买异常：$error';
        _purchasingProductId = null;
        notifyListeners();
      },
    );

    await loadProducts();
  }

  Future<void> loadProducts() async {
    if (!isIapSupported || !_isAvailable) return;

    _isLoadingProducts = true;
    _lastError = null;
    notifyListeners();

    final response = await _iap.queryProductDetails(kIapProductIds);
    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('未找到的商品 ID: ${response.notFoundIDs}');
    }
    if (response.error != null) {
      _lastError = response.error!.message;
    }
    _products = response.productDetails.toList()
      ..sort((a, b) {
        final configA = findIapProduct(a.id);
        final configB = findIapProduct(b.id);
        return (configA?.priceYuan ?? 0).compareTo(configB?.priceYuan ?? 0);
      });

    _isLoadingProducts = false;
    notifyListeners();
  }

  bool isProductAvailable(String productId) {
    return getProductDetails(productId) != null;
  }

  ProductDetails? getProductDetails(String productId) {
    for (final product in _products) {
      if (product.id == productId) return product;
    }
    return null;
  }

  String displayPrice(IapProductConfig config) {
    final product = getProductDetails(config.iosProductId);
    if (product != null) return product.price;
    return '¥${config.priceYuan}';
  }

  Future<void> buyProduct(String productId) async {
    if (!isIapSupported) {
      _lastError = '内购仅支持 iOS 设备';
      notifyListeners();
      return;
    }

    if (!_isAvailable) {
      _lastError = '当前设备不支持内购';
      notifyListeners();
      return;
    }

    if (_purchasingProductId != null) return;

    final product = getProductDetails(productId);
    if (product == null) {
      _lastError = '该商品暂不可用，请稍后重试';
      notifyListeners();
      return;
    }

    _purchasingProductId = productId;
    _lastError = null;
    _lastMessage = null;
    notifyListeners();

    try {
      final success = await _iap.buyConsumable(
        purchaseParam: PurchaseParam(productDetails: product),
        autoConsume: true,
      );

      if (!success) {
        _purchasingProductId = null;
        _lastError = '无法发起购买，请稍后重试';
        notifyListeners();
      }
    } catch (e) {
      _purchasingProductId = null;
      _lastError = '购买失败：$e';
      notifyListeners();
    }
  }

  void clearMessages() {
    _lastMessage = null;
    _lastError = null;
    notifyListeners();
  }

  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.pending:
          break;
        case PurchaseStatus.error:
          _purchasingProductId = null;
          _lastError = purchase.error?.message ?? '购买失败';
          notifyListeners();
          break;
        case PurchaseStatus.canceled:
          _purchasingProductId = null;
          notifyListeners();
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          final delivered = await _deliverProduct(purchase);
          if (delivered) {
            final config = findIapProduct(purchase.productID);
            _lastMessage = '购买成功，已获得 ${config?.credits ?? 0} 积分';
          } else {
            _lastError = '商品发放失败，请联系客服';
          }
          _purchasingProductId = null;
          notifyListeners();
          break;
      }

      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
  }

  Future<bool> _deliverProduct(PurchaseDetails purchase) async {
    if (purchase.status != PurchaseStatus.purchased &&
        purchase.status != PurchaseStatus.restored) {
      return false;
    }

    final config = findIapProduct(purchase.productID);
    if (config == null) return false;

    final purchaseId = _uniquePurchaseId(purchase);
    final prefs = await SharedPreferences.getInstance();
    final processed = prefs.getStringList(_processedPurchasesKey) ?? [];
    if (processed.contains(purchaseId)) return true;

    await CreditService().addCredits(config.credits);
    processed.add(purchaseId);
    await prefs.setStringList(_processedPurchasesKey, processed);
    return true;
  }

  String _uniquePurchaseId(PurchaseDetails purchase) {
    final id = purchase.purchaseID;
    if (id != null && id.isNotEmpty) return id;

    final localData = purchase.verificationData.localVerificationData;
    if (localData.isNotEmpty) {
      return '${purchase.productID}_$localData';
    }

    final txDate = purchase.transactionDate ?? '';
    return '${purchase.productID}_$txDate';
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
