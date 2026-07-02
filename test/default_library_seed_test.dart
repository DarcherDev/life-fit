import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:life_fit/core/data/default_library_catalog.dart';
import 'package:life_fit/core/repositories/app_repositories.dart';
import 'package:life_fit/core/services/default_library_seed.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('instalación nueva carga bibliotecas base', () async {
    SharedPreferences.setMockInitialValues({});
    await AppRepositories.init();

    final repos = AppRepositories.instance;
    expect(
      repos.exerciseTemplates.getExerciseTemplates().length,
      DefaultLibraryCatalog.exerciseTemplates.length,
    );
    expect(
      repos.warmUpTemplates.getWarmUpTemplates().length,
      DefaultLibraryCatalog.warmUpTemplates.length,
    );
    expect(
      repos.stretchingTemplates.getStretchingTemplates().length,
      DefaultLibraryCatalog.stretchingTemplates.length,
    );
    expect(
      repos.exerciseTemplates.getExerciseTemplateById('seed-ex-001')?.title,
      'Sentadilla Copa',
    );
    expect(
      repos.warmUpTemplates.getWarmUpTemplateById('seed-wu-001')?.description,
      'Bicicleta',
    );
    expect(
      repos.stretchingTemplates
          .getStretchingTemplateById('seed-st-001')
          ?.description,
      'Gato-Camello',
    );
  });

  test('no sobrescribe bibliotecas con datos existentes', () async {
    SharedPreferences.setMockInitialValues({
      'exercise_templates':
          '[{"id":"custom-1","title":"Press","series":4,"repetitions":10}]',
    });
    await DefaultLibrarySeed.runIfNeeded(
      await SharedPreferences.getInstance(),
    );

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('exercise_templates');
    expect(raw, contains('custom-1'));
    expect(raw, isNot(contains('seed-ex-001')));
  });
}
