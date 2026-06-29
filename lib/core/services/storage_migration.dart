import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'package:life_fit/modules/calentamiento/models/warm_up.dart';
import 'package:life_fit/modules/calentamiento/models/warm_up_placement.dart';
import 'package:life_fit/modules/calentamiento/models/warm_up_template.dart';
import 'package:life_fit/modules/ejercicios/models/exercise_template.dart';
import 'package:life_fit/modules/estiramiento/models/stretching.dart';
import 'package:life_fit/modules/estiramiento/models/stretching_template.dart';
import 'package:life_fit/shared/models/checklist_item.dart';
import 'package:life_fit/shared/models/routine_card.dart';
import 'package:life_fit/shared/models/routine_exercise_slot.dart';
import 'package:life_fit/shared/models/routine_stretching_slot.dart';

const _migrationDoneKey = 'library_migration_v1_done';
const _routinesKey = 'routine_cards';
const _exerciseTemplatesKey = 'exercise_templates';
const _stretchingTemplatesKey = 'stretching_templates';
const _warmUpTemplatesKey = 'warm_up_templates';

class StorageMigration {
  StorageMigration._();

  static const _uuid = Uuid();

  static Future<void> runIfNeeded(SharedPreferences prefs) async {
    if (prefs.getBool(_migrationDoneKey) == true) {
      return;
    }

    final raw = prefs.getString(_routinesKey);
    if (raw == null || raw.isEmpty) {
      await prefs.setBool(_migrationDoneKey, true);
      return;
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    if (decoded.isEmpty) {
      await prefs.setBool(_migrationDoneKey, true);
      return;
    }

    final first = decoded.first as Map<String, dynamic>;
    if (first.containsKey('exerciseSlots')) {
      await prefs.setBool(_migrationDoneKey, true);
      return;
    }

    final exercises = _readExerciseTemplates(prefs);
    final stretchings = _readStretchingTemplates(prefs);
    final warmUps = _readWarmUpTemplates(prefs);

    final exerciseByKey = <String, ExerciseTemplate>{
      for (final item in exercises) _exerciseKey(item): item,
    };
    final stretchingByKey = <String, StretchingTemplate>{
      for (final item in stretchings) _stretchingKey(item): item,
    };
    final warmUpByKey = <String, WarmUpTemplate>{
      for (final item in warmUps) _warmUpKey(item): item,
    };

    final migratedRoutines = <RoutineCard>[];

    for (final entry in decoded) {
      final json = entry as Map<String, dynamic>;
      final legacy = _parseLegacyRoutine(json);

      String? warmUpId;
      if (legacy.warmUp != null) {
        final key = _warmUpKeyFromLegacy(legacy.warmUp!);
        warmUpId = warmUpByKey.putIfAbsent(
          key,
          () => WarmUpTemplate(
            id: _uuid.v4(),
            description: legacy.warmUp!.description,
            minutes: legacy.warmUp!.minutes,
          ),
        ).id;
      }

      final stretchingSlots = <RoutineStretchingSlot>[];
      for (final item in legacy.stretchingItems) {
        final key = _stretchingKeyFromLegacy(item);
        final template = stretchingByKey.putIfAbsent(
          key,
          () => StretchingTemplate(
            id: item.id.startsWith('__') ? _uuid.v4() : item.id,
            description: item.description,
            repetitions: item.repetitions,
          ),
        );
        stretchingSlots.add(
          RoutineStretchingSlot(
            slotId: item.id.startsWith('__') ? _uuid.v4() : item.id,
            stretchingId: template.id,
          ),
        );
      }

      final exerciseSlots = <RoutineExerciseSlot>[];
      for (final item in legacy.items) {
        final key = _exerciseKeyFromLegacy(item);
        final template = exerciseByKey.putIfAbsent(
          key,
          () => ExerciseTemplate.fromChecklistItem(
            id: _uuid.v4(),
            title: item.title,
            series: item.series,
            repetitions: item.repetitions,
            description: item.description,
          ),
        );
        exerciseSlots.add(
          RoutineExerciseSlot(slotId: item.id, exerciseId: template.id),
        );
      }

      migratedRoutines.add(
        RoutineCard(
          id: legacy.id,
          title: legacy.title,
          description: legacy.description,
          exerciseSlots: exerciseSlots,
          warmUpId: warmUpId,
          warmUpPlacement: legacy.warmUpPlacement,
          stretchingSlots: stretchingSlots,
        ),
      );
    }

    await prefs.setString(
      _exerciseTemplatesKey,
      jsonEncode(exerciseByKey.values.map((item) => item.toJson()).toList()),
    );
    await prefs.setString(
      _stretchingTemplatesKey,
      jsonEncode(stretchingByKey.values.map((item) => item.toJson()).toList()),
    );
    await prefs.setString(
      _warmUpTemplatesKey,
      jsonEncode(warmUpByKey.values.map((item) => item.toJson()).toList()),
    );
    await prefs.setString(
      _routinesKey,
      jsonEncode(migratedRoutines.map((card) => card.toJson()).toList()),
    );
    await prefs.setBool(_migrationDoneKey, true);
  }

  static List<ExerciseTemplate> _readExerciseTemplates(SharedPreferences prefs) {
    return _readList(prefs.getString(_exerciseTemplatesKey), ExerciseTemplate.fromJson);
  }

  static List<StretchingTemplate> _readStretchingTemplates(
      SharedPreferences prefs) {
    return _readList(
        prefs.getString(_stretchingTemplatesKey), StretchingTemplate.fromJson);
  }

  static List<WarmUpTemplate> _readWarmUpTemplates(SharedPreferences prefs) {
    return _readList(prefs.getString(_warmUpTemplatesKey), WarmUpTemplate.fromJson);
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

  static _LegacyRoutine _parseLegacyRoutine(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>? ?? [];
    final warmUpJson = json['warmUp'] as Map<String, dynamic>?;
    final stretchingItems = _parseLegacyStretching(json);

    return _LegacyRoutine(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      items: itemsJson
          .map((item) => ChecklistItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      warmUp: warmUpJson == null ? null : WarmUp.fromJson(warmUpJson),
      warmUpPlacement:
          WarmUpPlacement.fromJson(json['warmUpPlacement'] as String?),
      stretchingItems: stretchingItems,
    );
  }

  static List<StretchingItem> _parseLegacyStretching(Map<String, dynamic> json) {
    final listJson = json['stretchingItems'] as List<dynamic>?;
    if (listJson != null) {
      return listJson
          .map((item) =>
              StretchingItem.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    final legacyJson = json['stretching'] as Map<String, dynamic>?;
    if (legacyJson != null) {
      return [StretchingItem.fromLegacySingle(legacyJson)];
    }
    return const [];
  }

  static String _exerciseKey(ExerciseTemplate item) =>
      '${item.title}|${item.series}|${item.repetitions}|${item.description}';

  static String _exerciseKeyFromLegacy(ChecklistItem item) =>
      '${item.title}|${item.series}|${item.repetitions}|${item.description}';

  static String _stretchingKey(StretchingTemplate item) =>
      '${item.description}|${item.repetitions}';

  static String _stretchingKeyFromLegacy(StretchingItem item) =>
      '${item.description}|${item.repetitions}';

  static String _warmUpKey(WarmUpTemplate item) =>
      '${item.description}|${item.minutes}';

  static String _warmUpKeyFromLegacy(WarmUp item) =>
      '${item.description}|${item.minutes}';
}

class _LegacyRoutine {
  const _LegacyRoutine({
    required this.id,
    required this.title,
    required this.description,
    required this.items,
    this.warmUp,
    required this.warmUpPlacement,
    required this.stretchingItems,
  });

  final String id;
  final String title;
  final String description;
  final List<ChecklistItem> items;
  final WarmUp? warmUp;
  final WarmUpPlacement warmUpPlacement;
  final List<StretchingItem> stretchingItems;
}
