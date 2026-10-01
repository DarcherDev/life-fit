import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/modules/calentamiento/models/warm_up_placement.dart';
import 'package:life_fit/modules/calentamiento/widgets/warm_up_placement_dialog.dart';

Future<void> _openDialog(
  WidgetTester tester, {
  String? startOccupiedBy,
  String? endOccupiedBy,
  required void Function(WarmUpPlacement? result) onResult,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('es'), Locale('en')],
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              onResult(
                await WarmUpPlacementDialog.show(
                  context,
                  startOccupiedBy: startOccupiedBy,
                  endOccupiedBy: endOccupiedBy,
                ),
              );
            },
            child: const Text('abrir'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('abrir'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('devuelve la posición elegida', (tester) async {
    WarmUpPlacement? result;
    await _openDialog(tester, onResult: (value) => result = value);

    expect(find.text('¿Cuándo hacerlo?'), findsOneWidget);
    expect(find.textContaining('Reemplaza a'), findsNothing);

    await tester.tap(find.text('Al final'));
    await tester.pumpAndSettle();

    expect(result, WarmUpPlacement.end);
    expect(find.text('¿Cuándo hacerlo?'), findsNothing);
  });

  testWidgets('avisa qué calentamiento reemplaza en una posición ocupada',
      (tester) async {
    WarmUpPlacement? result;
    await _openDialog(
      tester,
      startOccupiedBy: 'Bicicleta',
      onResult: (value) => result = value,
    );

    expect(find.text('Reemplaza a Bicicleta'), findsOneWidget);

    await tester.tap(find.text('Al inicio'));
    await tester.pumpAndSettle();

    expect(result, WarmUpPlacement.start);
  });
}
