import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:life_fit/core/services/storage_migration.dart';
import 'package:life_fit/modules/calentamiento/models/warm_up_template.dart';
import 'package:life_fit/modules/ejercicios/models/exercise_template.dart';
import 'package:life_fit/modules/estiramiento/models/stretching_template.dart';
import 'package:life_fit/shared/models/day_assignment.dart';
import 'package:life_fit/shared/models/day_progress.dart';
import 'package:life_fit/shared/models/routine_card.dart';
import 'package:life_fit/shared/utils/routine_resolver.dart';

class LocalStorageService {
  LocalStorageService._(this._prefs);

  static const _routinesKey = 'routine_cards';
  static const _assignmentsKey = 'day_assignments';
  static const _progressKey = 'day_progress';
  static const _exerciseTemplatesKey = 'exercise_templates';
  static const _stretchingTemplatesKey = 'stretching_templates';
  static const _warmUpTemplatesKey = 'warm_up_templates';

  final SharedPreferences _prefs;
  static LocalStorageService? _instance;

  static Future<LocalStorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    await StorageMigration.runIfNeeded(prefs);
    _instance = LocalStorageService._(prefs);
    return _instance!;
  }

  static LocalStorageService get instance {
    final service = _instance;
    if (service == null) {
      throw StateError('LocalStorageService not initialized. Call init() first.');
    }
    return service;
  }

  RoutineLibraries getLibraries() {
    return RoutineLibraries.fromLists(
      exercises: getExerciseTemplates(),
      stretchings: getStretchingTemplates(),
      warmUps: getWarmUpTemplates(),
    );
  }

  List<ExerciseTemplate> getExerciseTemplates() {
    return _readList(_exerciseTemplatesKey, ExerciseTemplate.fromJson);
  }

  Future<void> upsertExerciseTemplate(ExerciseTemplate template) async {
    final items = getExerciseTemplates();
    final index = items.indexWhere((existing) => existing.id == template.id);
    if (index >= 0) {
      items[index] = template;
    } else {
      items.add(template);
    }
    await _saveExerciseTemplates(items);
  }

  Future<bool> deleteExerciseTemplate(String templateId) async {
    if (_isExerciseTemplateInUse(templateId)) {
      return false;
    }
    final items = getExerciseTemplates()
      ..removeWhere((item) => item.id == templateId);
    await _saveExerciseTemplates(items);
    return true;
  }

  ExerciseTemplate? getExerciseTemplateById(String templateId) {
    for (final item in getExerciseTemplates()) {
      if (item.id == templateId) {
        return item;
      }
    }
    return null;
  }

  List<StretchingTemplate> getStretchingTemplates() {
    return _readList(_stretchingTemplatesKey, StretchingTemplate.fromJson);
  }

  Future<void> upsertStretchingTemplate(StretchingTemplate template) async {
    final items = getStretchingTemplates();
    final index = items.indexWhere((existing) => existing.id == template.id);
    if (index >= 0) {
      items[index] = template;
    } else {
      items.add(template);
    }
    await _saveStretchingTemplates(items);
  }

  Future<bool> deleteStretchingTemplate(String templateId) async {
    if (_isStretchingTemplateInUse(templateId)) {
      return false;
    }
    final items = getStretchingTemplates()
      ..removeWhere((item) => item.id == templateId);
    await _saveStretchingTemplates(items);
    return true;
  }

  StretchingTemplate? getStretchingTemplateById(String templateId) {
    for (final item in getStretchingTemplates()) {
      if (item.id == templateId) {
        return item;
      }
    }
    return null;
  }

  List<WarmUpTemplate> getWarmUpTemplates() {
    return _readList(_warmUpTemplatesKey, WarmUpTemplate.fromJson);
  }

  Future<void> upsertWarmUpTemplate(WarmUpTemplate template) async {
    final items = getWarmUpTemplates();
    final index = items.indexWhere((existing) => existing.id == template.id);
    if (index >= 0) {
      items[index] = template;
    } else {
      items.add(template);
    }
    await _saveWarmUpTemplates(items);
  }

  Future<bool> deleteWarmUpTemplate(String templateId) async {
    if (_isWarmUpTemplateInUse(templateId)) {
      return false;
    }
    final items = getWarmUpTemplates()
      ..removeWhere((item) => item.id == templateId);
    await _saveWarmUpTemplates(items);
    return true;
  }

  WarmUpTemplate? getWarmUpTemplateById(String templateId) {
    for (final item in getWarmUpTemplates()) {
      if (item.id == templateId) {
        return item;
      }
    }
    return null;
  }

  bool _isExerciseTemplateInUse(String templateId) {
    return getRoutineCards().any((card) => card.referencesExercise(templateId));
  }

  bool _isStretchingTemplateInUse(String templateId) {
    return getRoutineCards()
        .any((card) => card.referencesStretching(templateId));
  }

  bool _isWarmUpTemplateInUse(String templateId) {
    return getRoutineCards().any((card) => card.referencesWarmUp(templateId));
  }

  List<RoutineCard> getRoutineCards() {
    final raw = _prefs.getString(_routinesKey);
    if (raw == null || raw.isEmpty) {
      return [];
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => RoutineCard.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveRoutineCards(List<RoutineCard> cards) async {
    final encoded = jsonEncode(cards.map((card) => card.toJson()).toList());
    await _prefs.setString(_routinesKey, encoded);
  }

  Future<void> upsertRoutineCard(RoutineCard card) async {
    final cards = getRoutineCards();
    final index = cards.indexWhere((existing) => existing.id == card.id);

    if (index >= 0) {
      cards[index] = card;
    } else {
      cards.add(card);
    }

    await saveRoutineCards(cards);
  }

  Future<void> deleteRoutineCard(String routineId) async {
    final cards = getRoutineCards()
      ..removeWhere((card) => card.id == routineId);
    await saveRoutineCards(cards);

    final assignments = getAssignments()
      ..removeWhere((assignment) => assignment.routineId == routineId);
    await saveAssignments(assignments);
  }

  RoutineCard? getRoutineById(String routineId) {
    for (final card in getRoutineCards()) {
      if (card.id == routineId) {
        return card;
      }
    }
    return null;
  }

  List<DayAssignment> getAssignments() {
    final raw = _prefs.getString(_assignmentsKey);
    if (raw == null || raw.isEmpty) {
      return [];
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => DayAssignment.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveAssignments(List<DayAssignment> assignments) async {
    final encoded =
        jsonEncode(assignments.map((assignment) => assignment.toJson()).toList());
    await _prefs.setString(_assignmentsKey, encoded);
  }

  DayAssignment? getAssignmentForDate(String dateKey) {
    for (final assignment in getAssignments()) {
      if (assignment.dateKey == dateKey) {
        return assignment;
      }
    }
    return null;
  }

  Future<void> saveAssignment(String dateKey, String? routineId) async {
    final assignments = getAssignments()
      ..removeWhere((assignment) => assignment.dateKey == dateKey);

    if (routineId != null) {
      assignments.add(DayAssignment(dateKey: dateKey, routineId: routineId));
    }

    await saveAssignments(assignments);
  }

  DayProgress getDayProgress(String dateKey) {
    final allProgress = _getAllProgress();
    return allProgress.firstWhere(
      (progress) => progress.dateKey == dateKey,
      orElse: () => DayProgress(dateKey: dateKey, completedItemIds: {}),
    );
  }

  Future<void> toggleItem(String dateKey, String itemId, bool completed) async {
    final allProgress = _getAllProgress();
    final index =
        allProgress.indexWhere((progress) => progress.dateKey == dateKey);

    DayProgress progress;
    if (index >= 0) {
      progress = allProgress[index];
    } else {
      progress = DayProgress(dateKey: dateKey, completedItemIds: {});
    }

    final updatedIds = Set<String>.from(progress.completedItemIds);
    if (completed) {
      updatedIds.add(itemId);
    } else {
      updatedIds.remove(itemId);
    }

    final updatedProgress =
        progress.copyWith(completedItemIds: updatedIds);

    if (index >= 0) {
      allProgress[index] = updatedProgress;
    } else {
      allProgress.add(updatedProgress);
    }

    await _saveAllProgress(allProgress);
  }

  List<T> _readList<T>(
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

  Future<void> _saveExerciseTemplates(List<ExerciseTemplate> items) async {
    await _prefs.setString(
      _exerciseTemplatesKey,
      jsonEncode(items.map((item) => item.toJson()).toList()),
    );
  }

  Future<void> _saveStretchingTemplates(List<StretchingTemplate> items) async {
    await _prefs.setString(
      _stretchingTemplatesKey,
      jsonEncode(items.map((item) => item.toJson()).toList()),
    );
  }

  Future<void> _saveWarmUpTemplates(List<WarmUpTemplate> items) async {
    await _prefs.setString(
      _warmUpTemplatesKey,
      jsonEncode(items.map((item) => item.toJson()).toList()),
    );
  }

  List<DayProgress> _getAllProgress() {
    final raw = _prefs.getString(_progressKey);
    if (raw == null || raw.isEmpty) {
      return [];
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => DayProgress.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveAllProgress(List<DayProgress> progressList) async {
    final encoded =
        jsonEncode(progressList.map((progress) => progress.toJson()).toList());
    await _prefs.setString(_progressKey, encoded);
  }
}
