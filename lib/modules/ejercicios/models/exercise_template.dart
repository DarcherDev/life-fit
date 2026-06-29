class ExerciseTemplate {
  const ExerciseTemplate({
    required this.id,
    required this.title,
    required this.series,
    required this.repetitions,
    this.description = '',
    this.weightKg,
  });

  final String id;
  final String title;
  final int series;
  final int repetitions;
  final String description;
  final double? weightKg;

  ExerciseTemplate copyWith({
    String? id,
    String? title,
    int? series,
    int? repetitions,
    String? description,
    double? weightKg,
    bool clearWeightKg = false,
  }) {
    return ExerciseTemplate(
      id: id ?? this.id,
      title: title ?? this.title,
      series: series ?? this.series,
      repetitions: repetitions ?? this.repetitions,
      description: description ?? this.description,
      weightKg: clearWeightKg ? null : (weightKg ?? this.weightKg),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'series': series,
      'repetitions': repetitions,
      if (description.isNotEmpty) 'description': description,
      if (weightKg != null) 'weightKg': weightKg,
    };
  }

  factory ExerciseTemplate.fromJson(Map<String, dynamic> json) {
    return ExerciseTemplate(
      id: json['id'] as String,
      title: json['title'] as String,
      series: json['series'] as int? ?? 0,
      repetitions: json['repetitions'] as int? ?? 0,
      description: json['description'] as String? ?? '',
      weightKg: (json['weightKg'] as num?)?.toDouble(),
    );
  }

  factory ExerciseTemplate.fromChecklistItem({
    required String id,
    required String title,
    int? series,
    int? repetitions,
    String description = '',
    double? weightKg,
  }) {
    return ExerciseTemplate(
      id: id,
      title: title,
      series: series ?? 0,
      repetitions: repetitions ?? 0,
      description: description,
      weightKg: weightKg,
    );
  }
}
