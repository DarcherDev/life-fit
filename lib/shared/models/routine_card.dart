import 'package:life_fit/modules/calentamiento/models/warm_up_placement.dart';

import 'routine_exercise_slot.dart';
import 'routine_stretching_slot.dart';

class RoutineCard {
  const RoutineCard({
    required this.id,
    required this.title,
    required this.description,
    this.exerciseSlots = const [],
    this.warmUpId,
    this.warmUpPlacement = WarmUpPlacement.start,
    this.stretchingSlots = const [],
  });

  final String id;
  final String title;
  final String description;
  final List<RoutineExerciseSlot> exerciseSlots;
  final String? warmUpId;
  final WarmUpPlacement warmUpPlacement;
  final List<RoutineStretchingSlot> stretchingSlots;

  bool get hasWarmUp => warmUpId != null;
  bool get hasStretching => stretchingSlots.isNotEmpty;
  bool get hasExercises => exerciseSlots.isNotEmpty;

  bool referencesExercise(String exerciseId) {
    return exerciseSlots.any((slot) => slot.exerciseId == exerciseId);
  }

  bool referencesStretching(String stretchingId) {
    return stretchingSlots.any((slot) => slot.stretchingId == stretchingId);
  }

  bool referencesWarmUp(String warmUpId) {
    return this.warmUpId == warmUpId;
  }

  RoutineCard copyWith({
    String? id,
    String? title,
    String? description,
    List<RoutineExerciseSlot>? exerciseSlots,
    String? warmUpId,
    bool clearWarmUp = false,
    WarmUpPlacement? warmUpPlacement,
    List<RoutineStretchingSlot>? stretchingSlots,
  }) {
    return RoutineCard(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      exerciseSlots: exerciseSlots ?? this.exerciseSlots,
      warmUpId: clearWarmUp ? null : warmUpId ?? this.warmUpId,
      warmUpPlacement: warmUpPlacement ?? this.warmUpPlacement,
      stretchingSlots: stretchingSlots ?? this.stretchingSlots,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'exerciseSlots': exerciseSlots.map((slot) => slot.toJson()).toList(),
      if (warmUpId != null) 'warmUpId': warmUpId,
      if (warmUpId != null) 'warmUpPlacement': warmUpPlacement.toJson(),
      if (stretchingSlots.isNotEmpty)
        'stretchingSlots':
            stretchingSlots.map((slot) => slot.toJson()).toList(),
    };
  }

  factory RoutineCard.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('exerciseSlots') ||
        json.containsKey('warmUpId') ||
        json.containsKey('stretchingSlots')) {
      return _fromSlotJson(json);
    }
    throw const FormatException('Legacy routine format requires migration');
  }

  static RoutineCard _fromSlotJson(Map<String, dynamic> json) {
    final exerciseJson = json['exerciseSlots'] as List<dynamic>? ?? [];
    final stretchingJson = json['stretchingSlots'] as List<dynamic>? ?? [];

    return RoutineCard(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      exerciseSlots: exerciseJson
          .map((item) =>
              RoutineExerciseSlot.fromJson(item as Map<String, dynamic>))
          .toList(),
      warmUpId: json['warmUpId'] as String?,
      warmUpPlacement:
          WarmUpPlacement.fromJson(json['warmUpPlacement'] as String?),
      stretchingSlots: stretchingJson
          .map((item) =>
              RoutineStretchingSlot.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
