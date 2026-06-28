class ChecklistItem {
  const ChecklistItem({
    required this.id,
    required this.title,
    this.series,
    this.repetitions,
    this.description = '',
  });

  final String id;
  final String title;
  final int? series;
  final int? repetitions;
  final String description;

  String get formattedSubtitle {
    if (series != null && repetitions != null) {
      return '$series series x $repetitions repeticiones';
    }
    return description;
  }

  bool get hasSeriesAndReps => series != null && repetitions != null;

  ChecklistItem copyWith({
    String? id,
    String? title,
    int? series,
    int? repetitions,
    String? description,
  }) {
    return ChecklistItem(
      id: id ?? this.id,
      title: title ?? this.title,
      series: series ?? this.series,
      repetitions: repetitions ?? this.repetitions,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      if (series != null) 'series': series,
      if (repetitions != null) 'repetitions': repetitions,
      if (description.isNotEmpty) 'description': description,
    };
  }

  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    return ChecklistItem(
      id: json['id'] as String,
      title: json['title'] as String,
      series: json['series'] as int?,
      repetitions: json['repetitions'] as int?,
      description: json['description'] as String? ?? '',
    );
  }
}
