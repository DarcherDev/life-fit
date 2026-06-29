import 'package:flutter/material.dart';

import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/core/services/local_storage_service.dart';
import 'package:life_fit/shared/models/routine_card.dart';
import 'package:life_fit/shared/widgets/confirm_dialog.dart';
import 'package:life_fit/modules/ejercicios/screens/exercise_form_screen.dart';
import 'package:life_fit/modules/ejercicios/widgets/exercise_card_preview.dart';

/// Lista y CRUD de tarjetas del módulo **Ejercicios**.
class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  final _storage = LocalStorageService.instance;
  List<RoutineCard> _routines = [];

  @override
  void initState() {
    super.initState();
    _loadRoutines();
  }

  void _loadRoutines() {
    setState(() {
      _routines = _storage.getRoutineCards();
    });
  }

  Future<void> _openForm({RoutineCard? routine}) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => ExerciseFormScreen(routine: routine),
      ),
    );

    if (saved == true) {
      _loadRoutines();
    }
  }

  Future<void> _deleteRoutine(RoutineCard routine) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await ConfirmDialog.show(
      context,
      title: l10n.deleteExerciseCardTitle,
      message: l10n.deleteExerciseCardMessage(routine.title),
      confirmLabel: l10n.delete,
    );

    if (!confirmed) {
      return;
    }

    await _storage.deleteRoutineCard(routine.id);
    _loadRoutines();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.exercisesModuleTitle),
      ),
      body: _routines.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.dashboard_customize_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noExerciseCardsYet,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.noExerciseCardsHint,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _routines.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final routine = _routines[index];
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
                    await _deleteRoutine(routine);
                    return false;
                  },
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _openForm(routine: routine),
                      onLongPress: () => _deleteRoutine(routine),
                      borderRadius: BorderRadius.circular(16),
                      child: ExerciseCardPreview(
                        routine: routine,
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
        label: Text(l10n.newExerciseCard),
      ),
    );
  }
}
