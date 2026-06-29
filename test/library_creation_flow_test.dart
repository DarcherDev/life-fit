import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:life_fit/core/services/local_storage_service.dart';
import 'package:life_fit/core/services/theme_service.dart';
import 'package:life_fit/core/services/weight_unit_service.dart';
import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/modules/ejercicios/screens/exercise_library_screen.dart';
import 'package:life_fit/modules/ejercicios/screens/exercise_template_form_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({'library_migration_v1_done': true});
    await LocalStorageService.init();
    await ThemeService.instance.init();
    await WeightUnitService.instance.init();
  });

  testWidgets('ExerciseLibraryScreen creationMode abre formulario si está vacía',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('es'),
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('es'), Locale('en')],
        home: ExerciseLibraryScreen(creationMode: true),
      ),
    );
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.byType(ExerciseTemplateFormScreen), findsOneWidget);
  });
}
