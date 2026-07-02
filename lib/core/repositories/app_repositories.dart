import 'package:shared_preferences/shared_preferences.dart';

import 'package:life_fit/core/repositories/day_assignment_repository.dart';
import 'package:life_fit/core/repositories/day_progress_repository.dart';
import 'package:life_fit/core/repositories/exercise_template_repository.dart';
import 'package:life_fit/core/repositories/local/local_day_assignment_repository.dart';
import 'package:life_fit/core/repositories/local/local_day_progress_repository.dart';
import 'package:life_fit/core/repositories/local/local_exercise_template_repository.dart';
import 'package:life_fit/core/repositories/local/local_routine_repository.dart';
import 'package:life_fit/core/repositories/local/local_stretching_template_repository.dart';
import 'package:life_fit/core/repositories/local/local_warm_up_template_repository.dart';
import 'package:life_fit/core/repositories/local/shared_prefs_json_store.dart';
import 'package:life_fit/core/repositories/routine_repository.dart';
import 'package:life_fit/core/repositories/stretching_template_repository.dart';
import 'package:life_fit/core/repositories/warm_up_template_repository.dart';
import 'package:life_fit/core/services/default_library_seed.dart';
import 'package:life_fit/core/services/storage_migration.dart';
import 'package:life_fit/shared/utils/routine_resolver.dart';

/// Raíz de composición: expone abstracciones de persistencia (DIP).
class AppRepositories {
  AppRepositories._({
    required this.exerciseTemplates,
    required this.stretchingTemplates,
    required this.warmUpTemplates,
    required this.routines,
    required this.assignments,
    required this.progress,
  });

  final ExerciseTemplateRepository exerciseTemplates;
  final StretchingTemplateRepository stretchingTemplates;
  final WarmUpTemplateRepository warmUpTemplates;
  final RoutineRepository routines;
  final DayAssignmentRepository assignments;
  final DayProgressRepository progress;

  static AppRepositories? _instance;

  static Future<AppRepositories> init() async {
    final prefs = await SharedPreferences.getInstance();
    await StorageMigration.runIfNeeded(prefs);
    await DefaultLibrarySeed.runIfNeeded(prefs);

    final store = SharedPrefsJsonStore(prefs);
    final assignments = LocalDayAssignmentRepository(store);
    final routines = LocalRoutineRepository(store, assignments);
    final exerciseTemplates =
        LocalExerciseTemplateRepository(store, routines);
    final stretchingTemplates =
        LocalStretchingTemplateRepository(store, routines);
    final warmUpTemplates = LocalWarmUpTemplateRepository(store, routines);
    final progress = LocalDayProgressRepository(store);

    _instance = AppRepositories._(
      exerciseTemplates: exerciseTemplates,
      stretchingTemplates: stretchingTemplates,
      warmUpTemplates: warmUpTemplates,
      routines: routines,
      assignments: assignments,
      progress: progress,
    );
    return _instance!;
  }

  static AppRepositories get instance {
    final repos = _instance;
    if (repos == null) {
      throw StateError('AppRepositories not initialized. Call init() first.');
    }
    return repos;
  }

  RoutineLibraries getLibraries() {
    return RoutineLibraries.fromLists(
      exercises: exerciseTemplates.getExerciseTemplates(),
      stretchings: stretchingTemplates.getStretchingTemplates(),
      warmUps: warmUpTemplates.getWarmUpTemplates(),
    );
  }
}
