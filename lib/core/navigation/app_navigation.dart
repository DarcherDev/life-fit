import 'package:flutter/material.dart';

import 'package:life_fit/modules/dia_gym/flows/today_gym_coordinator.dart';import 'package:life_fit/modules/dia_gym/screens/day_routine_screen.dart';
import 'package:life_fit/modules/ejercicios/screens/exercises_screen.dart';
import 'package:life_fit/modules/planificador/screens/planner_screen.dart';
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

  static void openExercises(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const ExercisesScreen(),
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
}
