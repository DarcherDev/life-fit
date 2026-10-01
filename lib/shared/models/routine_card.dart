import 'package:life_fit/modules/calentamiento/models/warm_up_placement.dart';

import 'routine_exercise_slot.dart';
import 'routine_stretching_slot.dart';

class RoutineCard {
  const RoutineCard({
    required this.id,
    required this.title,
    required this.description,
    this.exerciseSlots = const [],
    this.startWarmUpId,
    this.endWarmUpId,
    this.stretchingSlots = const [],
  });

  final String id;
  final String title;
  final String description;
  final List<RoutineExerciseSlot> exerciseSlots;
  final String? startWarmUpId;
  final String? endWarmUpId;
  final List<RoutineStretchingSlot> stretchingSlots;

  bool get hasWarmUp => startWarmUpId != null || endWarmUpId != null;
  bool get hasStretching => stretchingSlots.isNotEmpty;
  bool get hasExercises => exerciseSlots.isNotEmpty;

  String? warmUpIdFor(WarmUpPlacement placement) {
    return placement == WarmUpPlacement.start ? startWarmUpId : endWarmUpId;
  }

  /// Asigna o quita ([warmUpId] null) el calentamiento de [placement].
  RoutineCard withWarmUp(WarmUpPlacement placement, String? warmUpId) {
    if (placement == WarmUpPlacement.start) {
      return copyWith(
        startWarmUpId: warmUpId,
        clearStartWarmUp: warmUpId == null,
      );
    }
    return copyWith(
      endWarmUpId: warmUpId,
      clearEndWarmUp: warmUpId == null,
    );
  }

  bool referencesExercise(String exerciseId) {
    return exerciseSlots.any((slot) => slot.exerciseId == exerciseId);
  }

  bool referencesStretching(String stretchingId) {
    return stretchingSlots.any((slot) => slot.stretchingId == stretchingId);
  }

  bool referencesWarmUp(String warmUpId) {
    return startWarmUpId == warmUpId || endWarmUpId == warmUpId;
  }

  RoutineCard copyWith({
    String? id,
    String? title,
    String? description,
    List<RoutineExerciseSlot>? exerciseSlots,
    String? startWarmUpId,
    bool clearStartWarmUp = false,
    String? endWarmUpId,
    bool clearEndWarmUp = false,
    List<RoutineStretchingSlot>? stretchingSlots,
  }) {
    return RoutineCard(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      exerciseSlots: exerciseSlots ?? this.exerciseSlots,
      startWarmUpId:
          clearStartWarmUp ? null : startWarmUpId ?? this.startWarmUpId,
      endWarmUpId: clearEndWarmUp ? null : endWarmUpId ?? this.endWarmUpId,
      stretchingSlots: stretchingSlots ?? this.stretchingSlots,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'exerciseSlots': exerciseSlots.map((slot) => slot.toJson()).toList(),
      if (startWarmUpId != null) 'startWarmUpId': startWarmUpId,
      if (endWarmUpId != null) 'endWarmUpId': endWarmUpId,
      if (stretchingSlots.isNotEmpty)
        'stretchingSlots':
            stretchingSlots.map((slot) => slot.toJson()).toList(),
    };
  }

  factory RoutineCard.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('exerciseSlots') ||
        json.containsKey('startWarmUpId') ||
        json.containsKey('endWarmUpId') ||
        json.containsKey('warmUpId') ||
        json.containsKey('stretchingSlots')) {
      return _fromSlotJson(json);
    }
    throw const FormatException('Legacy routine format requires migration');
  }

  static RoutineCard _fromSlotJson(Map<String, dynamic> json) {
    final exerciseJson = json['exerciseSlots'] as List<dynamic>? ?? [];
    final stretchingJson = json['stretchingSlots'] as List<dynamic>? ?? [];

    var startWarmUpId = json['startWarmUpId'] as String?;
    var endWarmUpId = json['endWarmUpId'] as String?;
    final legacyWarmUpId = json['warmUpId'] as String?;
    if (legacyWarmUpId != null && startWarmUpId == null && endWarmUpId == null) {
      final placement =
          WarmUpPlacement.fromJson(json['warmUpPlacement'] as String?);
      if (placement == WarmUpPlacement.end) {
        endWarmUpId = legacyWarmUpId;
      } else {
        startWarmUpId = legacyWarmUpId;
      }
    }

    return RoutineCard(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      exerciseSlots: exerciseJson
          .map((item) =>
              RoutineExerciseSlot.fromJson(item as Map<String, dynamic>))
          .toList(),
      startWarmUpId: startWarmUpId,
      endWarmUpId: endWarmUpId,
      stretchingSlots: stretchingJson
          .map((item) =>
              RoutineStretchingSlot.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
