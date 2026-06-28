import 'package:flutter/material.dart';

import '../navigation/app_navigation.dart';
import '../screens/planner/day_routine_screen.dart';
import '../screens/routines/routine_form_screen.dart';
import '../services/local_storage_service.dart';
import '../widgets/routine_assign_sheet.dart';
import 'today_gym_entry.dart';

class TodayGymCoordinator {
  TodayGymCoordinator._();

  static Future<void> start(BuildContext context) async {
    final storage = LocalStorageService.instance;
    final dateKey = AppNavigation.todayDateKey;
    final entry = resolveTodayGymEntry(storage, dateKey);

    switch (entry) {
      case TodayGymEntry.ready:
        _openDayRoutine(context);
        break;
      case TodayGymEntry.pickRoutine:
        await _pickAssignAndOpen(context, dateKey);
        break;
      case TodayGymEntry.createRoutine:
        await _createAssignAndOpen(context, dateKey);
        break;
    }
  }

  static void _openDayRoutine(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DayRoutineScreen(dateKey: AppNavigation.todayDateKey),
      ),
    );
  }

  static Future<void> _pickAssignAndOpen(
    BuildContext context,
    String dateKey,
  ) async {
    final navigator = Navigator.of(context);
    final selectedId = await RoutineAssignSheet.show(
      context,
      date: DateTime.now(),
      currentRoutineId: null,
    );

    if (selectedId == null || selectedId.isEmpty) {
      return;
    }

    await LocalStorageService.instance.saveAssignment(dateKey, selectedId);

    navigator.push(
      MaterialPageRoute<void>(
        builder: (_) => DayRoutineScreen(dateKey: AppNavigation.todayDateKey),
      ),
    );
  }

  static Future<void> _createAssignAndOpen(
    BuildContext context,
    String dateKey,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RoutineFormScreen(autoAssignDateKey: dateKey),
      ),
    );
  }
}
