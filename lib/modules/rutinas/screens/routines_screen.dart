import 'package:flutter/material.dart';

import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/core/services/local_storage_service.dart';
import 'package:life_fit/modules/rutinas/screens/routine_form_screen.dart';
import 'package:life_fit/modules/rutinas/widgets/routine_card_preview.dart';
import 'package:life_fit/shared/models/routine_card.dart';
import 'package:life_fit/shared/utils/routine_resolver.dart';
import 'package:life_fit/shared/widgets/confirm_dialog.dart';

class RoutinesScreen extends StatefulWidget {
  const RoutinesScreen({super.key});

  @override
  State<RoutinesScreen> createState() => _RoutinesScreenState();
}

class _RoutinesScreenState extends State<RoutinesScreen> {
  final _storage = LocalStorageService.instance;
  List<RoutineCard> _routines = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    setState(() => _routines = _storage.getRoutineCards());
  }

  Future<void> _openForm({RoutineCard? routine}) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => RoutineFormScreen(routine: routine),
      ),
    );
    if (saved == true) {
      _load();
    }
  }

  Future<void> _delete(RoutineCard routine) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await ConfirmDialog.show(
      context,
      title: l10n.deleteRoutineTitle,
      message: l10n.deleteRoutineMessage(routine.title),
      confirmLabel: l10n.delete,
    );
    if (!confirmed) {
      return;
    }
    await _storage.deleteRoutineCard(routine.id);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final libraries = _storage.getLibraries();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.routinesModuleTitle)),
      body: _routines.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.noRoutinesYet,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _routines.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final routine = _routines[index];
                final resolved = resolveRoutine(routine, libraries, l10n: l10n);
                return Dismissible(
                  key: ValueKey(routine.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (_) async {
                    await _delete(routine);
                    return false;
                  },
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _openForm(routine: routine),
                      onLongPress: () => _delete(routine),
                      borderRadius: BorderRadius.circular(16),
                      child: RoutineCardPreview(
                        routine: resolved,
                        compact: true,
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: Text(l10n.newRoutine),
      ),
    );
  }
}
