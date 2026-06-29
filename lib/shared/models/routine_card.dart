import 'package:life_fit/modules/calentamiento/models/warm_up.dart';
import 'package:life_fit/modules/calentamiento/models/warm_up_placement.dart';

import 'checklist_item.dart';

class RoutineCard {
  const RoutineCard({
    required this.id,
    required this.title,
    required this.description,
    required this.items,
    this.warmUp,
    this.warmUpPlacement = WarmUpPlacement.start,
  });

  final String id;
  final String title;
  final String description;
  final List<ChecklistItem> items;
  final WarmUp? warmUp;
  final WarmUpPlacement warmUpPlacement;

  bool get hasWarmUp => warmUp != null;

  RoutineCard copyWith({
    String? id,
    String? title,
    String? description,
    List<ChecklistItem>? items,
    WarmUp? warmUp,
    bool clearWarmUp = false,
    WarmUpPlacement? warmUpPlacement,
  }) {
    return RoutineCard(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      items: items ?? this.items,
      warmUp: clearWarmUp ? null : warmUp ?? this.warmUp,
      warmUpPlacement: warmUpPlacement ?? this.warmUpPlacement,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'items': items.map((item) => item.toJson()).toList(),
      if (warmUp != null) 'warmUp': warmUp!.toJson(),
      if (warmUp != null) 'warmUpPlacement': warmUpPlacement.toJson(),
    };
  }

  factory RoutineCard.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>? ?? [];
    final warmUpJson = json['warmUp'] as Map<String, dynamic>?;

    return RoutineCard(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      items: itemsJson
          .map((item) => ChecklistItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      warmUp: warmUpJson == null ? null : WarmUp.fromJson(warmUpJson),
      warmUpPlacement:
          WarmUpPlacement.fromJson(json['warmUpPlacement'] as String?),
    );
  }
}
