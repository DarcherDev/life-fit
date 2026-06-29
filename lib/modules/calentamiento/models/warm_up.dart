/// Calentamiento cardiovascular (caminadora, bici, elíptica, etc.).
class WarmUp {
  const WarmUp({
    required this.description,
    required this.minutes,
  });

  final String description;
  final int minutes;

  WarmUp copyWith({
    String? description,
    int? minutes,
  }) {
    return WarmUp(
      description: description ?? this.description,
      minutes: minutes ?? this.minutes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'minutes': minutes,
    };
  }

  factory WarmUp.fromJson(Map<String, dynamic> json) {
    return WarmUp(
      description: json['description'] as String? ?? '',
      minutes: json['minutes'] as int? ?? 0,
    );
  }
}

/// ID fijo para marcar el calentamiento como completado en el progreso del día.
const warmUpProgressItemId = '__warmup__';
