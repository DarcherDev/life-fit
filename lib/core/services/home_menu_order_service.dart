import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:life_fit/core/home/home_menu_option.dart';

/// Persiste el orden de las tarjetas del menú principal.
class HomeMenuOrderService extends ChangeNotifier {
  HomeMenuOrderService._();

  static final HomeMenuOrderService instance = HomeMenuOrderService._();

  static const _orderKey = 'home_menu_order';

  List<HomeMenuOption> _order = List<HomeMenuOption>.from(
    HomeMenuOption.defaultOrder,
  );

  List<HomeMenuOption> get order => List<HomeMenuOption>.unmodifiable(_order);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_orderKey);
    if (stored == null || stored.isEmpty) {
      _order = List<HomeMenuOption>.from(HomeMenuOption.defaultOrder);
      return;
    }
    _order = _normalize(stored);
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    if (oldIndex < 0 || oldIndex >= _order.length) {
      return;
    }

    var targetIndex = newIndex;
    if (targetIndex > oldIndex) {
      targetIndex -= 1;
    }
    if (targetIndex < 0) {
      targetIndex = 0;
    }
    if (targetIndex > _order.length) {
      targetIndex = _order.length;
    }

    final item = _order.removeAt(oldIndex);
    _order.insert(targetIndex, item);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _orderKey,
      _order.map((option) => option.storageId).toList(),
    );
  }

  List<HomeMenuOption> _normalize(List<String> stored) {
    final parsed = <HomeMenuOption>[];
    for (final id in stored) {
      final option = HomeMenuOption.fromStorage(id);
      if (option != null && !parsed.contains(option)) {
        parsed.add(option);
      }
    }
    for (final option in HomeMenuOption.defaultOrder) {
      if (!parsed.contains(option)) {
        parsed.add(option);
      }
    }
    return parsed;
  }
}
