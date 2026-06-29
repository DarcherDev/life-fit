import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:life_fit/core/home/home_screen.dart';
import 'package:life_fit/core/services/local_storage_service.dart';
import 'package:life_fit/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({'library_migration_v1_done': true});
    await LocalStorageService.init();
  });

  testWidgets('Home muestra las seis opciones', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('es'),
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('es'),
          Locale('en'),
        ],
        home: HomeScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Life Fit'), findsOneWidget);
    expect(find.text('Dia de gym'), findsOneWidget);
    expect(find.text('Rutina'), findsOneWidget);
    expect(find.text('Ejercicios'), findsOneWidget);
    expect(find.text('Estiramientos'), findsOneWidget);
    expect(find.text('Calentamiento'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Planificador'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Planificador'), findsOneWidget);
  });
}
