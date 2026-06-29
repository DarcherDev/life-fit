import 'package:flutter/material.dart';

import 'package:life_fit/l10n/app_localizations.dart';

class LibraryPickerSheet {
  LibraryPickerSheet._();

  static Future<List<String>?> show(
    BuildContext context, {
    required String title,
    required List<LibraryPickerItem> items,
    List<String> selectedIds = const [],
    bool multiSelect = true,
    String? emptyMessage,
  }) {
    return showModalBottomSheet<List<String>?>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final mediaQuery = MediaQuery.of(context);
        final sheetHeight = mediaQuery.size.height * 0.5;

        return Padding(
          padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
          child: SizedBox(
            height: sheetHeight,
            child: _LibraryPickerBody(
              title: title,
              items: items,
              initialSelectedIds: selectedIds,
              multiSelect: multiSelect,
              emptyMessage: emptyMessage,
            ),
          ),
        );
      },
    );
  }
}

class LibraryPickerItem {
  const LibraryPickerItem({
    required this.id,
    required this.title,
    this.subtitle,
  });

  final String id;
  final String title;
  final String? subtitle;
}

class _LibraryPickerBody extends StatefulWidget {
  const _LibraryPickerBody({
    required this.title,
    required this.items,
    required this.initialSelectedIds,
    required this.multiSelect,
    this.emptyMessage,
  });

  final String title;
  final List<LibraryPickerItem> items;
  final List<String> initialSelectedIds;
  final bool multiSelect;
  final String? emptyMessage;

  @override
  State<_LibraryPickerBody> createState() => _LibraryPickerBodyState();
}

class _LibraryPickerBodyState extends State<_LibraryPickerBody> {
  final _searchController = TextEditingController();
  late Set<String> _selectedIds;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _selectedIds = Set<String>.from(widget.initialSelectedIds);
    _searchController.addListener(() {
      setState(() => _query = _searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<LibraryPickerItem> get _filteredItems {
    final normalized = _query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return widget.items;
    }
    return widget.items.where((item) {
      return item.title.toLowerCase().contains(normalized) ||
          (item.subtitle?.toLowerCase().contains(normalized) ?? false);
    }).toList();
  }

  void _toggleItem(String id) {
    setState(() {
      if (widget.multiSelect) {
        if (_selectedIds.contains(id)) {
          _selectedIds.remove(id);
        } else {
          _selectedIds.add(id);
        }
      } else {
        _selectedIds = {id};
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final filtered = _filteredItems;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              widget.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchLibraryHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _searchController.clear,
                      )
                    : null,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      widget.emptyMessage ?? l10n.noMatchingLibraryItems,
                    ),
                  )
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      final isSelected = _selectedIds.contains(item.id);
                      return ListTile(
                        title: Text(item.title),
                        subtitle:
                            item.subtitle == null ? null : Text(item.subtitle!),
                        trailing: widget.multiSelect
                            ? Checkbox(
                                value: isSelected,
                                onChanged: (_) => _toggleItem(item.id),
                              )
                            : (isSelected
                                ? Icon(
                                    Icons.check_circle,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )
                                : null),
                        selected: isSelected,
                        onTap: () {
                          if (widget.multiSelect) {
                            _toggleItem(item.id);
                          } else {
                            Navigator.of(context).pop([item.id]);
                          }
                        },
                      );
                    },
                  ),
          ),
          if (widget.multiSelect)
            Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                onPressed: _selectedIds.isEmpty
                    ? null
                    : () => Navigator.of(context).pop(_selectedIds.toList()),
                child: Text(l10n.addSelected),
              ),
            ),
        ],
      ),
    );
  }
}
