import 'checklist_item.dart';

class RoutineCard {
  const RoutineCard({
    required this.id,
    required this.title,
    required this.description,
    required this.items,
  });

  final String id;
  final String title;
  final String description;
  final List<ChecklistItem> items;

  RoutineCard copyWith({
    String? id,
    String? title,
    String? description,
    List<ChecklistItem>? items,
  }) {
    return RoutineCard(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  factory RoutineCard.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>? ?? [];
    return RoutineCard(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      items: itemsJson
          .map((item) => ChecklistItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
