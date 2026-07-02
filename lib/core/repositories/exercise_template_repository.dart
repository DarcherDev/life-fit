import 'package:life_fit/modules/ejercicios/models/exercise_template.dart';

abstract class ExerciseTemplateRepository {
  List<ExerciseTemplate> getExerciseTemplates();

  ExerciseTemplate? getExerciseTemplateById(String templateId);

  Future<void> upsertExerciseTemplate(ExerciseTemplate template);

  Future<bool> deleteExerciseTemplate(String templateId);
}
