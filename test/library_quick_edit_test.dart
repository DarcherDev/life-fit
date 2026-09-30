import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:life_fit/core/repositories/stretching_template_repository.dart';
import 'package:life_fit/core/repositories/warm_up_template_repository.dart';
import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/modules/calentamiento/models/warm_up_template.dart';
import 'package:life_fit/modules/estiramiento/models/stretching_template.dart';
import 'package:life_fit/shared/flows/library_quick_edit_actions.dart';
import 'package:life_fit/shared/widgets/number_edit_dialog.dart';

class _MemoryWarmUpRepository implements WarmUpTemplateRepository {
  _MemoryWarmUpRepository(List<WarmUpTemplate> templates)
      : _templates = {for (final t in templates) t.id: t};

  final Map<String, WarmUpTemplate> _templates;

  @override
  List<WarmUpTemplate> getWarmUpTemplates() => _templates.values.toList();

  @override
  WarmUpTemplate? getWarmUpTemplateById(String templateId) =>
      _templates[templateId];

  @override
  Future<void> upsertWarmUpTemplate(WarmUpTemplate template) async {
    _templates[template.id] = template;
  }

  @override
  Future<bool> deleteWarmUpTemplate(String templateId) async =>
      _templates.remove(templateId) != null;
}

class _MemoryStretchingRepository implements StretchingTemplateRepository {
  _MemoryStretchingRepository(List<StretchingTemplate> templates)
      : _templates = {for (final t in templates) t.id: t};

  final Map<String, StretchingTemplate> _templates;

  @override
  List<StretchingTemplate> getStretchingTemplates() =>
      _templates.values.toList();

  @override
  StretchingTemplate? getStretchingTemplateById(String templateId) =>
      _templates[templateId];

  @override
  Future<void> upsertStretchingTemplate(StretchingTemplate template) async {
    _templates[template.id] = template;
  }

  @override
  Future<bool> deleteStretchingTemplate(String templateId) async =>
      _templates.remove(templateId) != null;
}

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

Future<BuildContext> _pumpContext(WidgetTester tester) async {
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
  return captured;
}

void main() {
  group('NumberEditDialog', () {
    Future<Future<int?>> openDialog(WidgetTester tester) async {
      final context = await _pumpContext(tester);
      final result = NumberEditDialog.show(
        context,
        title: 'Editar calentamiento',
        itemName: 'Caminadora',
        label: 'Tiempo (minutos)',
        initialValue: 15,
      );
      await tester.pumpAndSettle();
      return result;
    }

    testWidgets('devuelve el valor nuevo al guardar', (tester) async {
      final result = await openDialog(tester);

      expect(find.text('Caminadora'), findsOneWidget);
      expect(find.text('15'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), '30');
      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();

      expect(await result, 30);
    });

    testWidgets('rechaza vacío y cero', (tester) async {
      final result = await openDialog(tester);

      await tester.enterText(find.byType(TextFormField), '');
      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), '0');
      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      expect(await result, isNull);
    });

    testWidgets('devuelve null al cancelar', (tester) async {
      final result = await openDialog(tester);

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(await result, isNull);
    });
  });

  group('LibraryQuickEditActions', () {
    late _MemoryWarmUpRepository warmUps;
    late _MemoryStretchingRepository stretchings;

    setUp(() {
      warmUps = _MemoryWarmUpRepository(const [
        WarmUpTemplate(id: 'wu-1', description: 'Caminadora', minutes: 15),
      ]);
      stretchings = _MemoryStretchingRepository(const [
        StretchingTemplate(id: 'st-1', description: 'Gato-Camello', repetitions: 15),
      ]);
    });

    LibraryQuickEditActions actionsReturning(int? value) {
      return LibraryQuickEditActions(
        warmUpTemplates: warmUps,
        stretchingTemplates: stretchings,
        promptNumber: (
          context, {
          required title,
          required itemName,
          required label,
          required initialValue,
        }) async =>
            value,
      );
    }

    testWidgets('actualiza los minutos del calentamiento', (tester) async {
      final context = await _pumpContext(tester);

      final changed =
          await actionsReturning(30).editWarmUpMinutes(context, 'wu-1');

      expect(changed, isTrue);
      expect(warmUps.getWarmUpTemplateById('wu-1')!.minutes, 30);
      expect(warmUps.getWarmUpTemplateById('wu-1')!.description, 'Caminadora');
    });

    testWidgets('actualiza las repeticiones del estiramiento', (tester) async {
      final context = await _pumpContext(tester);

      final changed = await actionsReturning(20)
          .editStretchingRepetitions(context, 'st-1');

      expect(changed, isTrue);
      expect(stretchings.getStretchingTemplateById('st-1')!.repetitions, 20);
    });

    testWidgets('no guarda si se cancela o el valor no cambia', (tester) async {
      final context = await _pumpContext(tester);

      expect(
        await actionsReturning(null).editWarmUpMinutes(context, 'wu-1'),
        isFalse,
      );
      expect(
        await actionsReturning(15).editWarmUpMinutes(context, 'wu-1'),
        isFalse,
      );
      expect(
        await actionsReturning(30).editWarmUpMinutes(context, 'missing'),
        isFalse,
      );
      expect(warmUps.getWarmUpTemplateById('wu-1')!.minutes, 15);
    });
  });
}
