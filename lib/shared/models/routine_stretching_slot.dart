class RoutineStretchingSlot {
  const RoutineStretchingSlot({
    required this.slotId,
    required this.stretchingId,
  });

  final String slotId;
  final String stretchingId;

  Map<String, dynamic> toJson() {
    return {
      'slotId': slotId,
      'stretchingId': stretchingId,
    };
  }

  factory RoutineStretchingSlot.fromJson(Map<String, dynamic> json) {
    return RoutineStretchingSlot(
      slotId: json['slotId'] as String,
      stretchingId: json['stretchingId'] as String,
    );
  }
}
