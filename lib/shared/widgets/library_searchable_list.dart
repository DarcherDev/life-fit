import 'package:flutter/material.dart';

import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/shared/utils/library_search.dart';

class LibrarySearchableList<T extends Object> extends StatefulWidget {
  const LibrarySearchableList({
    super.key,
    required this.items,
    required this.titleFor,
    required this.itemBuilder,
    required this.createButtonLabel,
    required this.onCreate,
    this.subtitleFor,
    this.extraFieldsFor,
    this.emptyLibraryWidget,
    this.searchHint,
  });

  final List<T> items;
  final String Function(T item) titleFor;
  final String? Function(T item)? subtitleFor;
  final Iterable<String> Function(T item)? extraFieldsFor;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final Widget? emptyLibraryWidget;
  final String createButtonLabel;
  final void Function(String query) onCreate;
  final String? searchHint;

  @override
  State<LibrarySearchableList<T>> createState() =>
      _LibrarySearchableListState<T>();
}

class _LibrarySearchableListState<T extends Object>
    extends State<LibrarySearchableList<T>> {
  String _query = '';

  List<T> get _filteredItems {
    return filterLibraryItems<T>(
      items: widget.items,
      query: _query,
      titleFor: widget.titleFor,
      subtitleFor: widget.subtitleFor,
      extraFieldsFor: widget.extraFieldsFor,
    );
  }

  void _updateQuery(String value) {
    if (_query == value) {
      return;
    }
    setState(() => _query = value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final filtered = _filteredItems;
    final trimmedQuery = _query.trim();
    final showCreateFromSearch =
        trimmedQuery.isNotEmpty && filtered.isEmpty && widget.items.isNotEmpty;

    if (widget.items.isEmpty && widget.emptyLibraryWidget != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: _buildSearchField(l10n),
          ),
          Expanded(child: widget.emptyLibraryWidget!),
          if (trimmedQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton.icon(
                onPressed: () => widget.onCreate(trimmedQuery),
                icon: const Icon(Icons.add),
                label: Text(widget.createButtonLabel),
              ),
            ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: _buildSearchField(l10n),
        ),
        Expanded(
          child: showCreateFromSearch
              ? _buildNoMatchesState(l10n, trimmedQuery)
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    return widget.itemBuilder(context, filtered[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSearchField(AppLocalizations l10n) {
    return Autocomplete<T>(
      optionsBuilder: (value) {
        final text = value.text.trim();
        if (text.isEmpty) {
          return <T>[];
        }
        return filterLibraryItems<T>(
          items: widget.items,
          query: text,
          titleFor: widget.titleFor,
          subtitleFor: widget.subtitleFor,
          extraFieldsFor: widget.extraFieldsFor,
        ).take(6);
      },
      displayStringForOption: widget.titleFor,
      onSelected: (item) {
        _updateQuery(widget.titleFor(item));
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        if (controller.text != _query) {
          controller.text = _query;
        }

        return TextField(
          controller: controller,
          focusNode: focusNode,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: widget.searchHint ?? l10n.searchLibraryHint,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      controller.clear();
                      _updateQuery('');
                    },
                  )
                : null,
            border: const OutlineInputBorder(),
            isDense: true,
          ),
          onChanged: _updateQuery,
          onSubmitted: (_) => onFieldSubmitted(),
        );
      },
    );
  }

  Widget _buildNoMatchesState(AppLocalizations l10n, String query) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.noMatchingLibraryItems,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => widget.onCreate(query),
              icon: const Icon(Icons.add),
              label: Text(widget.createButtonLabel),
            ),
          ],
        ),
      ),
    );
  }
}
