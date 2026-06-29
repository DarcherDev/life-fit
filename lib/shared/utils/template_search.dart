import 'package:life_fit/modules/calentamiento/models/warm_up_template.dart';
import 'package:life_fit/modules/ejercicios/models/exercise_template.dart';
import 'package:life_fit/modules/estiramiento/models/stretching_template.dart';

List<ExerciseTemplate> filterExerciseTemplates(
  List<ExerciseTemplate> templates,
  String query,
) {
  final normalized = query.trim().toLowerCase();
  if (normalized.isEmpty) {
    return templates;
  }
  return templates.where((item) {
    return item.title.toLowerCase().contains(normalized) ||
        item.description.toLowerCase().contains(normalized);
  }).toList();
}

List<StretchingTemplate> filterStretchingTemplates(
  List<StretchingTemplate> templates,
  String query,
) {
  final normalized = query.trim().toLowerCase();
  if (normalized.isEmpty) {
    return templates;
  }
  return templates
      .where((item) => item.description.toLowerCase().contains(normalized))
      .toList();
}

List<WarmUpTemplate> filterWarmUpTemplates(
  List<WarmUpTemplate> templates,
  String query,
) {
  final normalized = query.trim().toLowerCase();
  if (normalized.isEmpty) {
    return templates;
  }
  return templates
      .where((item) => item.description.toLowerCase().contains(normalized))
      .toList();
}
