class DayProgress {
  const DayProgress({
    required this.dateKey,
    required this.completedItemIds,
  });

  final String dateKey;
  final Set<String> completedItemIds;

  DayProgress copyWith({
    String? dateKey,
    Set<String>? completedItemIds,
  }) {
    return DayProgress(
      dateKey: dateKey ?? this.dateKey,
      completedItemIds: completedItemIds ?? this.completedItemIds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dateKey': dateKey,
      'completedItemIds': completedItemIds.toList(),
    };
  }

  factory DayProgress.fromJson(Map<String, dynamic> json) {
    final ids = json['completedItemIds'] as List<dynamic>? ?? [];
    return DayProgress(
      dateKey: json['dateKey'] as String,
      completedItemIds: ids.map((id) => id as String).toSet(),
    );
  }
}
