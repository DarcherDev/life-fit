import 'package:flutter/material.dart';

import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/shared/models/routine_card.dart';
import 'package:life_fit/shared/utils/routine_search.dart';

/// Buscador + lista de rutinas para elegir una.
///
/// Con [shrinkWrap] la lista ocupa solo su alto y no hace scroll propio,
/// para poder vivir dentro de otro scroll. Sin él, necesita un alto acotado.
class RoutinePickerList extends StatefulWidget {
  const RoutinePickerList({
    super.key,
    required this.routines,
    required this.onSelected,
    this.currentRoutineId,
    this.shrinkWrap = false,
  });

  final List<RoutineCard> routines;
  final ValueChanged<String> onSelected;
  final String? currentRoutineId;
  final bool shrinkWrap;

  @override
  State<RoutinePickerList> createState() => _RoutinePickerListState();
}

class _RoutinePickerListState extends State<RoutinePickerList> {
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
    final list = _buildRoutineList(context);

    return Column(
      mainAxisSize: widget.shrinkWrap ? MainAxisSize.min : MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
        if (widget.shrinkWrap) list else Expanded(child: list),
      ],
    );
  }

  Widget _buildRoutineList(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_filteredRoutines.isEmpty) {
      final message = Padding(
        padding: const EdgeInsets.all(16),
        child: Text(l10n.noMatchingRoutines, textAlign: TextAlign.center),
      );
      return widget.shrinkWrap ? message : Center(child: message);
    }

    return ListView.builder(
      shrinkWrap: widget.shrinkWrap,
      physics:
          widget.shrinkWrap ? const NeverScrollableScrollPhysics() : null,
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
          onTap: () => widget.onSelected(routine.id),
        );
      },
    );
  }
}
