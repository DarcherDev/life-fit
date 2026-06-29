class DayAssignment {
  const DayAssignment({
    required this.dateKey,
    required this.routineId,
  });

  final String dateKey;
  final String routineId;

  Map<String, dynamic> toJson() {
    return {
      'dateKey': dateKey,
      'routineId': routineId,
    };
  }

  factory DayAssignment.fromJson(Map<String, dynamic> json) {
    return DayAssignment(
      dateKey: json['dateKey'] as String,
      routineId: json['routineId'] as String,
    );
  }
}
