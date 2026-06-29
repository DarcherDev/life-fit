class RoutineExerciseSlot {
  const RoutineExerciseSlot({
    required this.slotId,
    required this.exerciseId,
  });

  final String slotId;
  final String exerciseId;

  Map<String, dynamic> toJson() {
    return {
      'slotId': slotId,
      'exerciseId': exerciseId,
    };
  }

  factory RoutineExerciseSlot.fromJson(Map<String, dynamic> json) {
    return RoutineExerciseSlot(
      slotId: json['slotId'] as String,
      exerciseId: json['exerciseId'] as String,
    );
  }
}
