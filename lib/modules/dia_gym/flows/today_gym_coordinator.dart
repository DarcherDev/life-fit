import 'package:flutter/material.dart';

import 'package:life_fit/core/navigation/app_navigation.dart';
import 'package:life_fit/core/services/local_storage_service.dart';
import 'package:life_fit/modules/ejercicios/screens/exercise_form_screen.dart';
import 'package:life_fit/shared/widgets/routine_assign_sheet.dart';

import 'today_gym_entry.dart';

class TodayGymCoordinator {
  TodayGymCoordinator._();

  static Future<void> start(BuildContext context) async {
    final storage = LocalStorageService.instance;
    final dateKey = AppNavigation.todayDateKey;
    final entry = resolveTodayGymEntry(storage, dateKey);

    switch (entry) {
      case TodayGymEntry.ready:
        AppNavigation.openDayRoutine(context, dateKey);
        break;
      case TodayGymEntry.pickRoutine:
        await _pickAssignAndOpen(context, dateKey);
        break;
      case TodayGymEntry.createRoutine:
        await _createAssignAndOpen(context, dateKey);
        break;
    }
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

    navigator.push(AppNavigation.dayRoutineRoute(dateKey));
  }

  static Future<void> _createAssignAndOpen(
    BuildContext context,
    String dateKey,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ExerciseFormScreen(autoAssignDateKey: dateKey),
      ),
    );
  }
}
