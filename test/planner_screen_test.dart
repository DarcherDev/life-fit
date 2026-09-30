import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:life_fit/core/repositories/app_repositories.dart';
import 'package:life_fit/core/services/home_menu_order_service.dart';
import 'package:life_fit/core/services/theme_service.dart';
import 'package:life_fit/core/services/weight_unit_service.dart';
import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/modules/planificador/screens/planner_screen.dart';
import 'package:life_fit/shared/models/routine_card.dart';
import 'package:life_fit/shared/utils/date_utils.dart';

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

    final repos = AppRepositories.instance;
    await repos.routines.upsertRoutineCard(
      const RoutineCard(id: 'r-torso', title: 'Torso', description: ''),
    );
    await repos.routines.upsertRoutineCard(
      const RoutineCard(id: 'r-pierna', title: 'Pierna', description: ''),
    );
  });

  Future<void> pumpPlanner(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

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
        home: PlannerScreen(),
      ),
    );
    await tester.pumpAndSettle();
  }

  String todayKey() => DateKeys.fromDate(DateTime.now());

  testWidgets('tocar un día no abre el menú inferior', (tester) async {
    await pumpPlanner(tester);

    await tester.tap(find.text('15').first);
    await tester.pumpAndSettle();

    expect(find.byType(BottomSheet), findsNothing);
    expect(find.text('Elige una rutina para este día'), findsOneWidget);
  });

  testWidgets('día sin rutina asigna desde la lista en línea', (tester) async {
    await pumpPlanner(tester);

    expect(find.text('Elige una rutina para este día'), findsOneWidget);
    expect(find.text('Torso'), findsOneWidget);
    expect(find.text('Pierna'), findsOneWidget);

    await tester.tap(find.text('Pierna'));
    await tester.pumpAndSettle();

    expect(
      AppRepositories.instance.assignments
          .getAssignmentForDate(todayKey())
          ?.routineId,
      'r-pierna',
    );
    expect(find.text('Elige una rutina para este día'), findsNothing);
    expect(find.text('Torso'), findsNothing);
    expect(find.text('Pierna'), findsOneWidget);
    expect(find.byTooltip('Cambiar rutina'), findsOneWidget);
    expect(find.byType(BottomSheet), findsNothing);
  });

  testWidgets('día con rutina solo abre el menú desde el botón editar',
      (tester) async {
    await AppRepositories.instance.assignments
        .saveAssignment(todayKey(), 'r-torso');
    await pumpPlanner(tester);

    expect(find.text('Elige una rutina para este día'), findsNothing);

    await tester.tap(find.text('Torso'));
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsNothing);

    await tester.tap(find.byTooltip('Cambiar rutina'));
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsOneWidget);
    expect(find.text('Quitar rutina del día'), findsOneWidget);
  });
}
