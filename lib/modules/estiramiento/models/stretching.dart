/// Un estiramiento dentro de la rutina (descripción + repeticiones).
class StretchingItem {
  const StretchingItem({
    required this.id,
    required this.description,
    required this.repetitions,
  });

  final String id;
  final String description;
  final int repetitions;

  StretchingItem copyWith({
    String? id,
    String? description,
    int? repetitions,
  }) {
    return StretchingItem(
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

  factory StretchingItem.fromJson(Map<String, dynamic> json) {
    return StretchingItem(
      id: json['id'] as String,
      description: json['description'] as String? ?? '',
      repetitions: json['repetitions'] as int? ?? 0,
    );
  }

  /// Formato antiguo: un solo objeto sin `id`.
  factory StretchingItem.fromLegacySingle(Map<String, dynamic> json) {
    return StretchingItem(
      id: '__legacy_stretching__',
      description: json['description'] as String? ?? '',
      repetitions: json['repetitions'] as int? ?? 0,
    );
  }
}
