import 'package:life_fit/modules/calentamiento/models/warm_up_placement.dart';

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

/// ID fijo del calentamiento inicial en el progreso del día.
///
/// Se conserva el valor histórico para no perder progreso ya guardado.
const warmUpProgressItemId = '__warmup__';

/// ID fijo del calentamiento final en el progreso del día.
const endWarmUpProgressItemId = '__warmup_end__';

String warmUpProgressItemIdFor(WarmUpPlacement placement) {
  return placement == WarmUpPlacement.start
      ? warmUpProgressItemId
      : endWarmUpProgressItemId;
}
