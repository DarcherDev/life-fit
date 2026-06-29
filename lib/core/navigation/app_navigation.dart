import 'package:flutter/material.dart';

import 'package:life_fit/modules/dia_gym/flows/today_gym_coordinator.dart';
import 'package:life_fit/modules/dia_gym/screens/day_routine_screen.dart';
import 'package:life_fit/modules/calentamiento/screens/warm_up_library_screen.dart';
import 'package:life_fit/modules/ejercicios/screens/exercise_library_screen.dart';
import 'package:life_fit/modules/estiramiento/screens/stretching_library_screen.dart';
import 'package:life_fit/modules/planificador/screens/planner_screen.dart';
import 'package:life_fit/modules/rutinas/screens/routines_screen.dart';
import 'package:life_fit/shared/utils/date_utils.dart';

class AppNavigation {
  static String get todayDateKey => DateKeys.fromDate(DateTime.now());

  static MaterialPageRoute<void> dayRoutineRoute(String dateKey) {
    return MaterialPageRoute<void>(
      builder: (_) => DayRoutineScreen(dateKey: dateKey),
    );
  }

  static void openDayRoutine(BuildContext context, String dateKey) {
    Navigator.of(context).push(dayRoutineRoute(dateKey));
  }

  static void replaceWithDayRoutine(BuildContext context, String dateKey) {
    Navigator.of(context).pushReplacement(dayRoutineRoute(dateKey));
  }

  static Future<void> openTodayGym(BuildContext context) {
    return TodayGymCoordinator.start(context);
  }

  static void openRoutines(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const RoutinesScreen()),
    );
  }

  static void openExerciseLibrary(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ExerciseLibraryScreen()),
    );
  }

  static void openStretchingLibrary(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const StretchingLibraryScreen()),
    );
  }

  static void openWarmUpLibrary(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const WarmUpLibraryScreen()),
    );
  }

  static Future<String?> openExerciseLibraryForCreation(BuildContext context) {
    return Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) => const ExerciseLibraryScreen(creationMode: true),
      ),
    );
  }

  static Future<String?> openStretchingLibraryForCreation(BuildContext context) {
    return Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) => const StretchingLibraryScreen(creationMode: true),
      ),
    );
  }

  static Future<String?> openWarmUpLibraryForCreation(BuildContext context) {
    return Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) => const WarmUpLibraryScreen(creationMode: true),
      ),
    );
  }

  static Future<String?> openExerciseLibraryToCreate(BuildContext context) {
    return Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) => const ExerciseLibraryScreen(returnCreatedId: true),
      ),
    );
  }

  static Future<String?> openStretchingLibraryToCreate(BuildContext context) {
    return Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) => const StretchingLibraryScreen(returnCreatedId: true),
      ),
    );
  }

  static Future<String?> openWarmUpLibraryToCreate(BuildContext context) {
    return Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) => const WarmUpLibraryScreen(returnCreatedId: true),
      ),
    );
  }

  static void openPlanner(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const PlannerScreen()),
    );
  }
}
