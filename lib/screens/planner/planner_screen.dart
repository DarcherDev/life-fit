import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/routine_card.dart';
import '../../services/local_storage_service.dart';
import '../../utils/date_utils.dart';
import '../../widgets/routine_assign_sheet.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  final _storage = LocalStorageService.instance;
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
    final assignments = _storage.getAssignments();
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
    return _storage.getRoutineById(routineId);
  }

  Future<void> _showAssignSheet(DateTime day) async {
    final routines = _storage.getRoutineCards();
    if (routines.isEmpty) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Primero crea rutinas en la sección Rutina.'),
        ),
      );
      return;
    }

    final dateKey = DateKeys.fromDate(day);
    final currentRoutineId = _routineIdForDay(day);

    final selectedId = await RoutineAssignSheet.show(
      context,
      date: day,
      currentRoutineId: currentRoutineId,
      allowRemove: true,
    );

    if (selectedId == null) {
      return;
    }

    final routineId = selectedId.isEmpty ? null : selectedId;
    await _storage.saveAssignment(dateKey, routineId);
    _loadAssignments();

    if (!mounted) {
      return;
    }

    final message = routineId == null
        ? 'Rutina quitada del día'
        : 'Rutina asignada correctamente';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedRoutine =
        _selectedDay == null ? null : _routineForDay(_selectedDay!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Planificador'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2035, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            locale: 'es',
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
              _showAssignSheet(selectedDay);
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
              DateFormat('EEEE d MMMM yyyy', 'es').format(_selectedDay!),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                title: Text(
                  selectedRoutine?.title ?? 'Sin rutina asignada',
                ),
                subtitle: Text(
                  selectedRoutine == null
                      ? 'Toca para asignar una rutina'
                      : selectedRoutine.description.isEmpty
                          ? '${selectedRoutine.items.length} items · Toca para cambiar'
                          : '${selectedRoutine.description} · Toca para cambiar',
                ),
                trailing: const Icon(Icons.edit_calendar),
                onTap: () => _showAssignSheet(_selectedDay!),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
