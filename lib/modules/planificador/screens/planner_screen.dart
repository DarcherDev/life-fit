import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:life_fit/core/widgets/app_scaffold.dart';
import 'package:life_fit/core/repositories/app_repositories.dart';
import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/shared/models/routine_card.dart';
import 'package:life_fit/shared/utils/date_utils.dart';
import 'package:life_fit/shared/utils/locale_format.dart';
import 'package:life_fit/shared/widgets/routine_assign_sheet.dart';
import 'package:life_fit/shared/widgets/routine_picker_list.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  final _repos = AppRepositories.instance;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<String, String> _assignmentsByDate = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _loadAssignments();
  }

  void _loadAssignments() {
    final assignments = _repos.assignments.getAssignments();
    setState(() {
      _assignmentsByDate = {
        for (final assignment in assignments)
          assignment.dateKey: assignment.routineId,
      };
    });
  }

  String? _routineIdForDay(DateTime day) {
    return _assignmentsByDate[DateKeys.fromDate(day)];
  }

  RoutineCard? _routineForDay(DateTime day) {
    final routineId = _routineIdForDay(day);
    if (routineId == null) {
      return null;
    }
    return _repos.routines.getRoutineById(routineId);
  }

  /// Guarda la asignación del día; [routineId] null quita la rutina.
  Future<void> _assignRoutine(DateTime day, String? routineId) async {
    final l10n = AppLocalizations.of(context);
    await _repos.assignments.saveAssignment(DateKeys.fromDate(day), routineId);
    _loadAssignments();

    if (!mounted) {
      return;
    }

    final message = routineId == null
        ? l10n.routineRemovedFromDay
        : l10n.routineAssignedSuccess;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _showAssignSheet(DateTime day) async {
    final selectedId = await RoutineAssignSheet.show(
      context,
      date: day,
      routines: _repos.routines.getRoutineCards(),
      currentRoutineId: _routineIdForDay(day),
      allowRemove: true,
    );

    if (selectedId == null || !mounted) {
      return;
    }

    await _assignRoutine(day, selectedId.isEmpty ? null : selectedId);
  }

  Widget _buildAssignedRoutineCard(
    AppLocalizations l10n,
    DateTime day,
    RoutineCard routine,
  ) {
    return Card(
      child: ListTile(
        title: Text(routine.title),
        subtitle: Text(
          routine.description.isEmpty
              ? l10n.plannerItemsCount(routine.exerciseSlots.length)
              : routine.description,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit_calendar),
          tooltip: l10n.changeRoutine,
          onPressed: () => _showAssignSheet(day),
        ),
      ),
    );
  }

  Widget _buildInlineRoutinePicker(AppLocalizations l10n, DateTime day) {
    final routines = _repos.routines.getRoutineCards();
    if (routines.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(l10n.createRoutinesFirst),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                l10n.pickRoutineForDay,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            RoutinePickerList(
              key: ValueKey<String>('inline-picker-${DateKeys.fromDate(day)}'),
              routines: routines,
              shrinkWrap: true,
              onSelected: (routineId) => _assignRoutine(day, routineId),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeCode = Localizations.localeOf(context).languageCode;
    final selectedRoutine =
        _selectedDay == null ? null : _routineForDay(_selectedDay!);

    return AppScaffold(
      title: l10n.plannerTitle,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2035, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            locale: localeCode,
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.monday,
            eventLoader: (day) {
              final routineId = _routineIdForDay(day);
              return routineId == null ? [] : [routineId];
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),
          const SizedBox(height: 24),
          if (_selectedDay != null) ...[
            Text(
              formatFullDate(context, _selectedDay!),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            if (selectedRoutine != null)
              _buildAssignedRoutineCard(l10n, _selectedDay!, selectedRoutine)
            else
              _buildInlineRoutinePicker(l10n, _selectedDay!),
          ],
        ],
      ),
    );
  }
}
