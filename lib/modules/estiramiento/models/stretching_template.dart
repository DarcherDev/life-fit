class StretchingTemplate {
  const StretchingTemplate({
    required this.id,
    required this.description,
    required this.repetitions,
  });

  final String id;
  final String description;
  final int repetitions;

  StretchingTemplate copyWith({
    String? id,
    String? description,
    int? repetitions,
  }) {
    return StretchingTemplate(
      id: id ?? this.id,
      description: description ?? this.description,
      repetitions: repetitions ?? this.repetitions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'repetitions': repetitions,
    };
  }

  factory StretchingTemplate.fromJson(Map<String, dynamic> json) {
    return StretchingTemplate(
      id: json['id'] as String,
      description: json['description'] as String? ?? '',
      repetitions: json['repetitions'] as int? ?? 0,
    );
  }
}
