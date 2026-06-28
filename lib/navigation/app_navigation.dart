import 'package:flutter/material.dart';

import '../flows/today_gym_coordinator.dart';
import '../screens/planner/planner_screen.dart';
import '../screens/planner/day_routine_screen.dart';
import '../screens/routines/routines_screen.dart';
import '../utils/date_utils.dart';

class AppNavigation {
  static String get todayDateKey => DateKeys.fromDate(DateTime.now());

  static Future<void> openTodayGym(BuildContext context) {
    return TodayGymCoordinator.start(context);
  }

  static void openRoutines(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const RoutinesScreen(),
      ),
    );
  }

  static void openPlanner(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const PlannerScreen(),
      ),
    );
  }

  static void replaceWithTodayGym(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => DayRoutineScreen(dateKey: todayDateKey),
      ),
    );
  }

  static void replaceWithRoutines(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => const RoutinesScreen(),
      ),
    );
  }

  static void replaceWithPlanner(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => const PlannerScreen(),
      ),
    );
  }
}
