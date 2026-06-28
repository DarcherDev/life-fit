import '../models/routine_card.dart';

List<RoutineCard> filterRoutineCards(
  List<RoutineCard> routines,
  String query,
) {
  final normalizedQuery = query.trim().toLowerCase();
  if (normalizedQuery.isEmpty) {
    return routines;
  }

  return routines
      .where(
        (routine) =>
            routine.title.toLowerCase().contains(normalizedQuery) ||
            routine.description.toLowerCase().contains(normalizedQuery),
      )
      .toList();
}
