import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/shared/widgets/library_searchable_list.dart';

void main() {
  testWidgets('LibrarySearchableList muestra crear si no hay coincidencias',
      (WidgetTester tester) async {
    var createdQuery = '';

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('es'),
          Locale('en'),
        ],
        home: Scaffold(
          body: LibrarySearchableList<String>(
            items: const ['Sentadilla Copa', 'Press Banca'],
            titleFor: (item) => item,
            createButtonLabel: 'Nuevo ejercicio',
            onCreate: (query) => createdQuery = query,
            itemBuilder: (context, item) => ListTile(title: Text(item)),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Zancadas');
    await tester.pumpAndSettle();

    expect(find.text('No hay coincidencias'), findsOneWidget);
    expect(find.text('Nuevo ejercicio'), findsOneWidget);

    await tester.tap(find.text('Nuevo ejercicio'));
    await tester.pumpAndSettle();

    expect(createdQuery, 'Zancadas');
  });

  testWidgets('LibrarySearchableList filtra resultados al escribir',
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
        supportedLocales: const [
          Locale('es'),
          Locale('en'),
        ],
        home: Scaffold(
          body: LibrarySearchableList<String>(
            items: const ['Sentadilla Copa', 'Press Banca'],
            titleFor: (item) => item,
            createButtonLabel: 'Nuevo ejercicio',
            onCreate: (_) {},
            itemBuilder: (context, item) => ListTile(title: Text(item)),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sentadilla Copa'), findsOneWidget);
    expect(find.text('Press Banca'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Press');
    await tester.pumpAndSettle();

    expect(find.byType(ListTile), findsOneWidget);
    expect(find.widgetWithText(ListTile, 'Press Banca'), findsOneWidget);
    expect(find.widgetWithText(ListTile, 'Sentadilla Copa'), findsNothing);
  });
}
