import 'package:flutter/material.dart';

import 'package:life_fit/core/navigation/app_navigation.dart';
import 'package:life_fit/core/repositories/app_repositories.dart';
import 'package:life_fit/modules/rutinas/screens/routine_form_screen.dart';
import 'package:life_fit/shared/widgets/routine_assign_sheet.dart';

import 'today_gym_entry.dart';

class TodayGymCoordinator {
  TodayGymCoordinator._();

  static Future<void> start(BuildContext context) async {
    final repos = AppRepositories.instance;
    final dateKey = AppNavigation.todayDateKey;
    final entry = resolveTodayGymEntry(
      repos.assignments,
      repos.routines,
      dateKey,
    );

    switch (entry) {
      case TodayGymEntry.ready:
        await AppNavigation.openDayRoutine(context, dateKey);
        break;
      case TodayGymEntry.pickRoutine:
        await _pickAssignAndOpen(context, dateKey, repos);
        break;
      case TodayGymEntry.createRoutine:
        await _createAssignAndOpen(context, dateKey);
        break;
    }
  }

  static Future<void> _pickAssignAndOpen(
    BuildContext context,
    String dateKey,
    AppRepositories repos,
  ) async {
    final navigator = Navigator.of(context);
    final selectedId = await RoutineAssignSheet.show(
      context,
      date: DateTime.now(),
      routines: repos.routines.getRoutineCards(),
      currentRoutineId: null,
    );

    if (selectedId == null || selectedId.isEmpty) {
      return;
    }

    await repos.assignments.saveAssignment(dateKey, selectedId);

    if (!context.mounted) {
      return;
    }
    await navigator.push<void>(AppNavigation.dayRoutineRoute(dateKey));
  }

  static Future<void> _createAssignAndOpen(
    BuildContext context,
    String dateKey,
  ) async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => RoutineFormScreen(autoAssignDateKey: dateKey),
      ),
    );

    if (created != true || !context.mounted) {
      return;
    }

    await AppNavigation.openDayRoutine(context, dateKey);
  }
}
