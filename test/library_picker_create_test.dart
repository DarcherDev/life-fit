import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/shared/widgets/library_picker_sheet.dart';

void main() {
  testWidgets('LibraryPickerSheet muestra botón crear sin coincidencias',
      (WidgetTester tester) async {
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
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    LibraryPickerSheet.show(
                      context,
                      title: 'Elegir ejercicios',
                      createButtonLabel: 'Nuevo ejercicio',
                      onCreateItem: () async {},
                      items: const [
                        LibraryPickerItem(
                          id: 'ex-1',
                          title: 'Press banca',
                          subtitle: '4 series x 10 repeticiones',
                        ),
                      ],
                    );
                  },
                  child: const Text('Abrir'),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();

    expect(find.text('Press banca'), findsOneWidget);
    expect(find.text('Nuevo ejercicio'), findsNothing);

    await tester.enterText(find.byType(TextField), 'sentadilla');
    await tester.pump();

    expect(find.text('No hay coincidencias'), findsOneWidget);
    expect(find.text('Nuevo ejercicio'), findsOneWidget);
  });
}
