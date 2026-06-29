import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/routine_card.dart';
import '../services/local_storage_service.dart';
import '../utils/locale_format.dart';
import '../utils/routine_search.dart';

class RoutineAssignSheet {
  RoutineAssignSheet._();

  /// Returns selected [routineId], empty string if remove was chosen,
  /// or null if the user dismissed the sheet.
  static Future<String?> show(
    BuildContext context, {
    required DateTime date,
    String? currentRoutineId,
    bool allowRemove = false,
    String? title,
  }) {
    final l10n = AppLocalizations.of(context);
    final routines = LocalStorageService.instance.getRoutineCards();
    final formattedDate = formatShortDate(context, date);
    final sheetTitle = title ??
        (currentRoutineId == null
            ? l10n.assignRoutineForDate(formattedDate)
            : l10n.changeRoutineForDate(formattedDate));

    return showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final mediaQuery = MediaQuery.of(context);
        final sheetHeight = mediaQuery.size.height * 0.5;

        return Padding(
          padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
          child: SizedBox(
            height: sheetHeight,
            child: _RoutineAssignSheetBody(
              title: sheetTitle,
              routines: routines,
              currentRoutineId: currentRoutineId,
              allowRemove: allowRemove,
            ),
          ),
        );
      },
    );
  }
}

class _RoutineAssignSheetBody extends StatefulWidget {
  const _RoutineAssignSheetBody({
    required this.title,
    required this.routines,
    required this.currentRoutineId,
    required this.allowRemove,
  });

  final String title;
  final List<RoutineCard> routines;
  final String? currentRoutineId;
  final bool allowRemove;

  @override
  State<_RoutineAssignSheetBody> createState() =>
      _RoutineAssignSheetBodyState();
}

class _RoutineAssignSheetBodyState extends State<_RoutineAssignSheetBody> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _query = _searchController.text;
    });
  }

  List<RoutineCard> get _filteredRoutines =>
      filterRoutineCards(widget.routines, _query);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

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
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: l10n.searchRoutineHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _searchController.clear,
                      )
                    : null,
                border: const OutlineInputBorder(),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildRoutineList(context),
          ),
          if (widget.allowRemove && widget.currentRoutineId != null)
            ListTile(
              leading: const Icon(Icons.event_busy),
              title: Text(l10n.removeRoutineFromDay),
              onTap: () => Navigator.of(context).pop(''),
            ),
        ],
      ),
    );
  }

  Widget _buildRoutineList(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_filteredRoutines.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(l10n.noMatchingRoutines),
        ),
      );
    }

    return ListView.builder(
      itemCount: _filteredRoutines.length,
      itemBuilder: (context, index) {
        final routine = _filteredRoutines[index];
        final isSelected = routine.id == widget.currentRoutineId;

        return ListTile(
          title: Text(routine.title),
          subtitle: routine.description.isEmpty
              ? null
              : Text(routine.description),
          trailing: isSelected
              ? Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                )
              : null,
          selected: isSelected,
          onTap: () => Navigator.of(context).pop(routine.id),
        );
      },
    );
  }
}
