import 'package:flutter/material.dart';
import '../config/iap_products.dart';
import '../services/credit_service.dart';
import '../services/iap_service.dart';
import '../utils/constants.dart';

class CreditStoreScreen extends StatefulWidget {
  const CreditStoreScreen({super.key});

  @override
  State<CreditStoreScreen> createState() => _CreditStoreScreenState();
}

class _CreditStoreScreenState extends State<CreditStoreScreen> {
  final CreditService _creditService = CreditService();
  final IapService _iapService = IapService();
  late String _selectedProductId;

  @override
  void initState() {
    super.initState();
    _selectedProductId = kIapProducts.first.iosProductId;
    _creditService.addListener(_onUpdate);
    _iapService.addListener(_onUpdate);
    if (isIapSupported && !_iapService.hasProducts) {
      _iapService.loadProducts();
    }
  }

  @override
  void dispose() {
    _creditService.removeListener(_onUpdate);
    _iapService.removeListener(_onUpdate);
    super.dispose();
  }

  void _onUpdate() {
    if (!mounted) return;
    setState(() {});

    final message = _iapService.lastMessage;
    final error = _iapService.lastError;
    if (message != null) {
      _iapService.clearMessages();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } else if (error != null) {
      _iapService.clearMessages();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  IapProductConfig? get _selectedProduct {
    for (final product in kIapProducts) {
      if (product.iosProductId == _selectedProductId) return product;
    }
    return kIapProducts.isNotEmpty ? kIapProducts.first : null;
  }

  Future<void> _onBuySelected() async {
    final product = _selectedProduct;
    if (product == null) return;
    await _iapService.buyProduct(product.iosProductId);
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selectedProduct;
    final isPurchasing = _iapService.purchasingProductId != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.textPrimary,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('积分充值', style: AppTextStyles.headline3),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildBalanceCard(),
                  const SizedBox(height: AppSpacing.lg),
                  _buildTipsCard(),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    '选择充值套餐',
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (_iapService.isLoadingProducts && !_iapService.hasProducts)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else ...[
                    ...kIapProducts.map(_buildProductCard),
                    if (isIapSupported &&
                        !_iapService.isLoadingProducts &&
                        !_iapService.hasProducts)
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.md),
                        child: OutlinedButton.icon(
                          onPressed: _iapService.loadProducts,
                          icon: const Icon(Icons.refresh),
                          label: const Text('重新加载商品'),
                        ),
                      ),
                  ],
                  if (!isIapSupported)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.lg),
                      child: Text(
                        '内购功能仅支持 iOS 设备',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  else if (!_iapService.isAvailable)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.lg),
                      child: Text(
                        '当前设备暂不支持内购，请使用真机并通过 App Store 测试',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (isIapSupported && selected != null)
            _buildBottomBar(selected, isPurchasing),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.monetization_on, color: Colors.white, size: 36),
          const SizedBox(height: AppSpacing.md),
          Text(
            '当前积分',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${_creditService.credits}',
            style: AppTextStyles.headline1.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [AppShadows.sm],
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: AppColors.primary, size: 20),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              '发布首页动态每次消耗 ${CreditService.postCost} 积分，新用户默认 ${CreditService.initialCredits} 积分',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(IapProductConfig config) {
    final isSelected = _selectedProductId == config.iosProductId;
    final isAvailable = _iapService.isProductAvailable(config.iosProductId);
    final isBestValue = config.priceYuan == 28;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedProductId = config.iosProductId;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.05)
              : AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [AppShadows.sm],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: isSelected ? AppColors.primary : AppColors.textTertiary,
                size: 22,
              ),
              const SizedBox(width: AppSpacing.md),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(Icons.stars, color: AppColors.primary),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(config.title, style: AppTextStyles.labelLarge),
                        if (isBestValue) ...[
                          const SizedBox(width: AppSpacing.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.circle),
                            ),
                            child: Text(
                              '超值',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      config.subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (!isAvailable && !_iapService.isLoadingProducts)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '商品加载中或暂不可用',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.warning,
                            fontSize: 11,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                _iapService.displayPrice(config),
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(IapProductConfig selected, bool isPurchasing) {
    final canBuy = _iapService.isAvailable &&
        _iapService.isProductAvailable(selected.iosProductId) &&
        !isPurchasing;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.lg + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '已选：${selected.title} · ${_iapService.displayPrice(selected)}',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: canBuy ? _onBuySelected : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor:
                    AppColors.primary.withValues(alpha: 0.4),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
              ),
              child: isPurchasing
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      '立即购买',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
