import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:life_fit/core/services/weight_unit_service.dart';
import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/shared/widgets/exercise_weight_dialog.dart';
import 'package:life_fit/shared/widgets/expandable_description.dart';

Widget _localizedApp(Widget home) {
  return MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('es'), Locale('en')],
    home: Scaffold(body: home),
  );
}

final _longText = List.filled(
  40,
  'Mantén la espalda baja pegada al banco y controla la bajada.',
).join(' ');

void main() {
  testWidgets('texto corto no muestra Ver más', (tester) async {
    await tester.pumpWidget(
      _localizedApp(const ExpandableDescription('Sube despacio.')),
    );

    expect(find.text('Sube despacio.'), findsOneWidget);
    expect(find.text('Ver más'), findsNothing);
  });

  testWidgets('texto largo se expande con Ver más y se recoge con Ver menos',
      (tester) async {
    await tester.pumpWidget(
      _localizedApp(
          SizedBox(width: 300, child: ExpandableDescription(_longText))),
    );

    final collapsed = tester.widget<Text>(find.text(_longText));
    expect(collapsed.maxLines, 3);
    expect(find.text('Ver más'), findsOneWidget);

    await tester.tap(find.text('Ver más'));
    await tester.pump();

    expect(tester.widget<Text>(find.text(_longText)).maxLines, isNull);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(
      tester.getSize(find.byType(SingleChildScrollView)).height,
      lessThanOrEqualTo(160),
    );
    expect(find.text('Ver menos'), findsOneWidget);

    await tester.tap(find.text('Ver menos'));
    await tester.pump();
    expect(tester.widget<Text>(find.text(_longText)).maxLines, 3);
  });

  testWidgets('diálogo de editar ejercicio usa el nombre y la descripción',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    await WeightUnitService.instance.init();

    late BuildContext captured;
    await tester.pumpWidget(
      _localizedApp(
        Builder(
          builder: (context) {
            captured = context;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    ExerciseWeightDialog.show(
      captured,
      exerciseTitle: 'Dragon Flag (progresión)',
      description: _longText,
      series: 3,
      repetitions: 5,
    );
    await tester.pumpAndSettle();

    expect(find.text('Dragon Flag (progresión)'), findsOneWidget);
    expect(find.text('Editar ejercicio'), findsNothing);
    expect(find.text(_longText), findsOneWidget);
    expect(find.text('Ver más'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
