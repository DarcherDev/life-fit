bool libraryItemMatchesQuery({
  required String query,
  required String title,
  String? subtitle,
  Iterable<String> extraFields = const [],
}) {
  final normalizedQuery = query.trim().toLowerCase();
  if (normalizedQuery.isEmpty) {
    return true;
  }

  if (title.toLowerCase().contains(normalizedQuery)) {
    return true;
  }
  if (subtitle != null && subtitle.toLowerCase().contains(normalizedQuery)) {
    return true;
  }
  for (final field in extraFields) {
    if (field.toLowerCase().contains(normalizedQuery)) {
      return true;
    }
  }
  return false;
}

List<T> filterLibraryItems<T>({
  required List<T> items,
  required String query,
  required String Function(T item) titleFor,
  String? Function(T item)? subtitleFor,
  Iterable<String> Function(T item)? extraFieldsFor,
}) {
  final normalizedQuery = query.trim();
  if (normalizedQuery.isEmpty) {
    return items;
  }

  return items
      .where(
        (item) => libraryItemMatchesQuery(
          query: normalizedQuery,
          title: titleFor(item),
          subtitle: subtitleFor?.call(item),
          extraFields: extraFieldsFor?.call(item) ?? const [],
        ),
      )
      .toList();
}
