import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:life_fit/core/home/home_screen.dart';
import 'package:life_fit/core/repositories/app_repositories.dart';
import 'package:life_fit/core/services/home_menu_order_service.dart';
import 'package:life_fit/core/services/theme_service.dart';
import 'package:life_fit/core/services/weight_unit_service.dart';
import 'package:life_fit/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'library_migration_v1_done': true,
      'default_library_seed_v1_done': true,
    });
    await AppRepositories.init();
    await ThemeService.instance.init();
    await WeightUnitService.instance.init();
    await HomeMenuOrderService.instance.init();
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
    expect(find.text('Planificador'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Ejercicios'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Ejercicios'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Estiramientos'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Estiramientos'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Calentamiento'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Calentamiento'), findsOneWidget);
  });

  testWidgets('Drawer muestra accesos a ajustes y mi proceso', (WidgetTester tester) async {
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

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    expect(find.text('Ajustes'), findsOneWidget);
    expect(find.text('Tema, idioma y sistema de peso'), findsOneWidget);
    expect(find.text('Mi proceso'), findsOneWidget);
    expect(find.text('Edad, altura y peso corporal'), findsOneWidget);
    expect(find.text('Tema'), findsNothing);

    await tester.tap(find.text('Ajustes'));
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsOneWidget);
    expect(find.text('Tema'), findsOneWidget);
    expect(find.text('Idioma'), findsOneWidget);
    expect(find.text('Sistema de peso'), findsOneWidget);
  });
}
