import 'package:life_fit/core/repositories/exercise_template_repository.dart';
import 'package:life_fit/core/repositories/local/shared_prefs_json_store.dart';
import 'package:life_fit/core/repositories/routine_repository.dart';
import 'package:life_fit/modules/ejercicios/models/exercise_template.dart';

class LocalExerciseTemplateRepository implements ExerciseTemplateRepository {
  LocalExerciseTemplateRepository(this._store, this._routines);

  static const _key = 'exercise_templates';

  final SharedPrefsJsonStore _store;
  final RoutineRepository _routines;

  @override
  List<ExerciseTemplate> getExerciseTemplates() {
    return _store.readList(_key, ExerciseTemplate.fromJson);
  }

  @override
  ExerciseTemplate? getExerciseTemplateById(String templateId) {
    for (final item in getExerciseTemplates()) {
      if (item.id == templateId) {
        return item;
      }
    }
    return null;
  }

  @override
  Future<void> upsertExerciseTemplate(ExerciseTemplate template) async {
    final items = getExerciseTemplates();
    final index = items.indexWhere((existing) => existing.id == template.id);
    if (index >= 0) {
      items[index] = template;
    } else {
      items.add(template);
    }
    await _store.writeList(_key, items, (item) => item.toJson());
  }

  @override
  Future<bool> deleteExerciseTemplate(String templateId) async {
    if (_isInUse(templateId)) {
      return false;
    }
    final items = getExerciseTemplates()
      ..removeWhere((item) => item.id == templateId);
    await _store.writeList(_key, items, (item) => item.toJson());
    return true;
  }

  bool _isInUse(String templateId) {
    return _routines
        .getRoutineCards()
        .any((card) => card.referencesExercise(templateId));
  }
}
