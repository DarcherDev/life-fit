import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Lectura/escritura genérica de listas JSON en SharedPreferences.
class SharedPrefsJsonStore {
  const SharedPrefsJsonStore(this._prefs);

  final SharedPreferences _prefs;

  List<T> readList<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) {
      return [];
    }
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> writeList<T>(
    String key,
    List<T> items,
    Map<String, dynamic> Function(T) toJson,
  ) async {
    await _prefs.setString(
      key,
      jsonEncode(items.map(toJson).toList()),
    );
  }
}
