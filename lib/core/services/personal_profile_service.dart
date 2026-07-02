import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:life_fit/core/profile/models/personal_profile.dart';

class PersonalProfileService extends ChangeNotifier {
  PersonalProfileService._();

  static final PersonalProfileService instance = PersonalProfileService._();

  static const _profileKey = 'personal_profile';

  PersonalProfile _profile = PersonalProfile.empty;

  PersonalProfile get profile => _profile;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_profileKey);
    if (raw == null || raw.isEmpty) {
      return;
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        _profile = PersonalProfile.fromJson(decoded);
      }
    } catch (_) {
      _profile = PersonalProfile.empty;
    }
  }

  Future<void> saveProfile(PersonalProfile profile) async {
    _profile = profile;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, jsonEncode(profile.toJson()));
  }
}
