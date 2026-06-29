class ExerciseTemplate {
  const ExerciseTemplate({
    required this.id,
    required this.title,
    required this.series,
    required this.repetitions,
    this.description = '',
  });

  final String id;
  final String title;
  final int series;
  final int repetitions;
  final String description;

  ExerciseTemplate copyWith({
    String? id,
    String? title,
    int? series,
    int? repetitions,
    String? description,
  }) {
    return ExerciseTemplate(
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
      'series': series,
      'repetitions': repetitions,
      if (description.isNotEmpty) 'description': description,
    };
  }

  factory ExerciseTemplate.fromJson(Map<String, dynamic> json) {
    return ExerciseTemplate(
      id: json['id'] as String,
      title: json['title'] as String,
      series: json['series'] as int? ?? 0,
      repetitions: json['repetitions'] as int? ?? 0,
      description: json['description'] as String? ?? '',
    );
  }

  factory ExerciseTemplate.fromChecklistItem({
    required String id,
    required String title,
    int? series,
    int? repetitions,
    String description = '',
  }) {
    return ExerciseTemplate(
      id: id,
      title: title,
      series: series ?? 0,
      repetitions: repetitions ?? 0,
      description: description,
    );
  }
}
