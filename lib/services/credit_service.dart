import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 积分管理
class CreditService extends ChangeNotifier {
  static final CreditService _instance = CreditService._internal();
  factory CreditService() => _instance;
  CreditService._internal();

  static const int initialCredits = 100;
  static const int postCost = 10;
  static const _creditsKey = 'user_credits';

  int _credits = initialCredits;
  bool _loaded = false;

  int get credits => _credits;
  bool get isLoaded => _loaded;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _credits = prefs.getInt(_creditsKey) ?? initialCredits;
    if (!prefs.containsKey(_creditsKey)) {
      await prefs.setInt(_creditsKey, initialCredits);
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> addCredits(int amount) async {
    if (amount <= 0) return;
    _credits += amount;
    await _save();
    notifyListeners();
  }

  Future<bool> spendCredits(int amount) async {
    if (amount <= 0 || _credits < amount) return false;
    _credits -= amount;
    await _save();
    notifyListeners();
    return true;
  }

  bool canSpend(int amount) => _credits >= amount;

  Future<void> reset() async {
    _credits = initialCredits;
    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_creditsKey, _credits);
  }
}
