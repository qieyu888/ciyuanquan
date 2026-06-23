import 'dart:io' show Platform;

/// 内购商品配置（仅 iOS 使用）
class IapProductConfig {
  final String iosProductId;
  final int priceYuan;
  final int credits;
  final String title;
  final String subtitle;

  const IapProductConfig({
    required this.iosProductId,
    required this.priceYuan,
    required this.credits,
    required this.title,
    required this.subtitle,
  });
}

const List<IapProductConfig> kIapProducts = [
  IapProductConfig(
    iosProductId: 'com.ciyuan6',
    priceYuan: 6,
    credits: 60,
    title: '60 积分',
    subtitle: '可发布 6 条动态',
  ),
  IapProductConfig(
    iosProductId: 'com.ciyuan18',
    priceYuan: 18,
    credits: 180,
    title: '180 积分',
    subtitle: '可发布 18 条动态',
  ),
  IapProductConfig(
    iosProductId: 'com.ciyuan28',
    priceYuan: 28,
    credits: 280,
    title: '280 积分',
    subtitle: '可发布 28 条动态',
  ),
];

/// 是否启用内购（仅 iOS）
bool get isIapSupported => Platform.isIOS;

Set<String> get kIapProductIds {
  if (!isIapSupported) return {};
  return kIapProducts.map((p) => p.iosProductId).toSet();
}

IapProductConfig? findIapProduct(String productId) {
  for (final product in kIapProducts) {
    if (product.iosProductId == productId) return product;
  }
  return null;
}
