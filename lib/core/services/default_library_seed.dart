import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:life_fit/core/data/default_library_catalog.dart';
import 'package:life_fit/modules/calentamiento/models/warm_up_template.dart';
import 'package:life_fit/modules/ejercicios/models/exercise_template.dart';
import 'package:life_fit/modules/estiramiento/models/stretching_template.dart';

const defaultLibrarySeedDoneKey = 'default_library_seed_v1_done';

const _exerciseTemplatesKey = 'exercise_templates';
const _stretchingTemplatesKey = 'stretching_templates';
const _warmUpTemplatesKey = 'warm_up_templates';

/// Carga plantillas base en instalaciones nuevas (bibliotecas vacías).
class DefaultLibrarySeed {
  DefaultLibrarySeed._();

  static Future<void> runIfNeeded(SharedPreferences prefs) async {
    if (prefs.getBool(defaultLibrarySeedDoneKey) == true) {
      return;
    }

    final exercises = _readList(
      prefs.getString(_exerciseTemplatesKey),
      ExerciseTemplate.fromJson,
    );
    final stretchings = _readList(
      prefs.getString(_stretchingTemplatesKey),
      StretchingTemplate.fromJson,
    );
    final warmUps = _readList(
      prefs.getString(_warmUpTemplatesKey),
      WarmUpTemplate.fromJson,
    );

    final allEmpty =
        exercises.isEmpty && stretchings.isEmpty && warmUps.isEmpty;

    if (allEmpty) {
      await prefs.setString(
        _exerciseTemplatesKey,
        jsonEncode(
          DefaultLibraryCatalog.exerciseTemplates
              .map((item) => item.toJson())
              .toList(),
        ),
      );
      await prefs.setString(
        _stretchingTemplatesKey,
        jsonEncode(
          DefaultLibraryCatalog.stretchingTemplates
              .map((item) => item.toJson())
              .toList(),
        ),
      );
      await prefs.setString(
        _warmUpTemplatesKey,
        jsonEncode(
          DefaultLibraryCatalog.warmUpTemplates
              .map((item) => item.toJson())
              .toList(),
        ),
      );
    }

    await prefs.setBool(defaultLibrarySeedDoneKey, true);
  }

  static List<T> _readList<T>(
    String? raw,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (raw == null || raw.isEmpty) {
      return [];
    }
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
