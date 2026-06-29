class WarmUpTemplate {
  const WarmUpTemplate({
    required this.id,
    required this.description,
    required this.minutes,
  });

  final String id;
  final String description;
  final int minutes;

  WarmUpTemplate copyWith({
    String? id,
    String? description,
    int? minutes,
  }) {
    return WarmUpTemplate(
      id: id ?? this.id,
      description: description ?? this.description,
      minutes: minutes ?? this.minutes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'minutes': minutes,
    };
  }

  factory WarmUpTemplate.fromJson(Map<String, dynamic> json) {
    return WarmUpTemplate(
      id: json['id'] as String,
      description: json['description'] as String? ?? '',
      minutes: json['minutes'] as int? ?? 0,
    );
  }
}
