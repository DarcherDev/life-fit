import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum WeightUnit {
  kg,
  lb;

  static WeightUnit? fromStorage(String? value) {
    switch (value) {
      case 'kg':
        return WeightUnit.kg;
      case 'lb':
        return WeightUnit.lb;
      default:
        return null;
    }
  }

  String toStorage() => name;
}

class WeightUnitService extends ChangeNotifier {
  WeightUnitService._();

  static final WeightUnitService instance = WeightUnitService._();

  static const _weightUnitKey = 'app_weight_unit';

  WeightUnit _unit = WeightUnit.kg;

  WeightUnit get unit => _unit;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _unit = WeightUnit.fromStorage(prefs.getString(_weightUnitKey)) ??
        WeightUnit.kg;
  }

  Future<void> setUnit(WeightUnit unit) async {
    if (_unit == unit) {
      return;
    }
    _unit = unit;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_weightUnitKey, unit.toStorage());
  }
}
