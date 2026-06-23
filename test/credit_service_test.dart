import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ciyuan/config/iap_products.dart';
import 'package:ciyuan/services/credit_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('CreditService', () {
    test('新用户默认 100 积分', () async {
      final service = CreditService();
      await service.load();
      expect(service.credits, CreditService.initialCredits);
      expect(service.canSpend(CreditService.postCost), isTrue);
    });

    test('发布动态消耗 10 积分', () async {
      final service = CreditService();
      await service.load();

      final spent = await service.spendCredits(CreditService.postCost);
      expect(spent, isTrue);
      expect(service.credits, 90);
    });

    test('积分不足时无法消耗', () async {
      final service = CreditService();
      await service.load();
      await service.spendCredits(95);

      expect(service.canSpend(CreditService.postCost), isFalse);
      final spent = await service.spendCredits(CreditService.postCost);
      expect(spent, isFalse);
      expect(service.credits, 5);
    });

    test('充值增加积分', () async {
      final service = CreditService();
      await service.load();
      await service.addCredits(60);
      expect(service.credits, 160);
    });

    test('注销重置为默认积分', () async {
      final service = CreditService();
      await service.load();
      await service.spendCredits(50);
      await service.reset();
      expect(service.credits, CreditService.initialCredits);
    });

    test('积分持久化', () async {
      final service = CreditService();
      await service.load();
      await service.spendCredits(30);

      final service2 = CreditService();
      await service2.load();
      expect(service2.credits, 70);
    });
  });

  group('IapProductConfig', () {
    test('三个内购商品配置正确', () {
      expect(kIapProducts.length, 3);
      expect(findIapProduct('com.ciyuan6')?.credits, 60);
      expect(findIapProduct('com.ciyuan18')?.credits, 180);
      expect(findIapProduct('com.ciyuan28')?.credits, 280);
    });

    test('积分与价格比例 1:10', () {
      for (final product in kIapProducts) {
        expect(product.credits, product.priceYuan * 10);
      }
    });
  });
}
