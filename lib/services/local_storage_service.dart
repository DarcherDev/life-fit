import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/day_assignment.dart';
import '../models/day_progress.dart';
import '../models/routine_card.dart';

class LocalStorageService {
  LocalStorageService._(this._prefs);

  static const _routinesKey = 'routine_cards';
  static const _assignmentsKey = 'day_assignments';
  static const _progressKey = 'day_progress';

  final SharedPreferences _prefs;
  static LocalStorageService? _instance;

  static Future<LocalStorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
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
