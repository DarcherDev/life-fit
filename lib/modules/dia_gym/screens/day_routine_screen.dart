import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import 'package:life_fit/core/navigation/app_navigation.dart';
import 'package:life_fit/core/services/local_storage_service.dart';
import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/modules/ejercicios/widgets/exercise_card_preview.dart';
import 'package:life_fit/modules/rutina/routine_day_module.dart';
import 'package:life_fit/shared/models/routine_card.dart';
import 'package:life_fit/shared/utils/date_utils.dart';
import 'package:life_fit/shared/utils/locale_format.dart';
import 'package:life_fit/shared/widgets/confirm_dialog.dart';
import 'package:life_fit/shared/widgets/routine_assign_sheet.dart';

/// Pantalla del módulo **Día de gym**.
///
/// Hoy ejecuta el submódulo [RoutineDayModule.ejercicios].
/// [RoutineDayModule.calentamiento] y [RoutineDayModule.estiramiento]
/// se integrarán aquí cuando estén implementados.

class DayRoutineScreen extends StatefulWidget {
  const DayRoutineScreen({
    super.key,
    required this.dateKey,
  });

  final String dateKey;

  @override
  State<DayRoutineScreen> createState() => _DayRoutineScreenState();
}

class _DayRoutineScreenState extends State<DayRoutineScreen> {
  final _storage = LocalStorageService.instance;
  late final ConfettiController _confettiController;
  RoutineCard? _routine;
  Set<String> _completedItemIds = {};
  var _isCelebrating = false;

  bool get _isToday => widget.dateKey == AppNavigation.todayDateKey;

  bool get _allItemsCompleted {
    final routine = _routine;
    if (routine == null || routine.items.isEmpty) {
      return false;
    }
    return routine.items.every(
      (item) => _completedItemIds.contains(item.id),
    );
  }

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(milliseconds: 1500),
    );
    _loadData();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _loadData() {
    final assignment = _storage.getAssignmentForDate(widget.dateKey);
    final routine = assignment == null
        ? null
        : _storage.getRoutineById(assignment.routineId);
    final progress = _storage.getDayProgress(widget.dateKey);

    setState(() {
      _routine = routine;
      _completedItemIds = Set<String>.from(progress.completedItemIds);
    });
  }

  DateTime get _date => DateKeys.toDate(widget.dateKey);

  Future<void> _toggleItem(String itemId, bool completed) async {
    if (_isCelebrating) {
      return;
    }

    await _storage.toggleItem(widget.dateKey, itemId, completed);
    _loadData();

    if (completed && _allItemsCompleted) {
      await _finishRoutine();
    }
  }

  Future<void> _finishRoutine() async {
    if (_isCelebrating || !mounted) {
      return;
    }

    setState(() => _isCelebrating = true);
    _confettiController.play();

    await Future<void>.delayed(const Duration(milliseconds: 1500));

    if (!mounted) {
      return;
    }

    _confettiController.stop();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Future<void> _changeRoutine() async {
    final l10n = AppLocalizations.of(context);
    final assignment = _storage.getAssignmentForDate(widget.dateKey);
    final selectedId = await RoutineAssignSheet.show(
      context,
      date: _date,
      currentRoutineId: assignment?.routineId,
      title: l10n.changeRoutine,
    );

    if (selectedId == null || selectedId.isEmpty) {
      return;
    }

    await _storage.saveAssignment(widget.dateKey, selectedId);
    _loadData();
  }

  Future<void> _removeRoutine() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await ConfirmDialog.show(
      context,
      title: l10n.removeRoutineTitle,
      message: l10n.removeRoutineMessage,
      confirmLabel: l10n.remove,
    );

    if (!confirmed) {
      return;
    }

    await _storage.saveAssignment(widget.dateKey, null);
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  Widget _buildMissingRoutineState() {
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fitness_center_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noRoutineForDay,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.back),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfetti() {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: _confettiController,
        blastDirectionality: BlastDirectionality.explosive,
        shouldLoop: false,
        emissionFrequency: 0.08,
        numberOfParticles: 24,
        maxBlastForce: 28,
        minBlastForce: 12,
        gravity: 0.2,
        colors: const [
          Colors.green,
          Colors.teal,
          Colors.orange,
          Colors.amber,
          Colors.blue,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final routine = _routine;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              _isToday
                  ? l10n.todayRoutine
                  : formatShortDate(context, _date),
            ),
            actions: [
              if (routine != null && !_isCelebrating) ...[
                IconButton(
                  onPressed: _changeRoutine,
                  icon: const Icon(Icons.swap_horiz),
                  tooltip: l10n.changeRoutine,
                ),
                IconButton(
                  onPressed: _removeRoutine,
                  icon: const Icon(Icons.event_busy),
                  tooltip: l10n.removeRoutineTitle,
                ),
              ],
            ],
          ),
          body: routine == null
              ? _buildMissingRoutineState()
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      formatWeekday(context, _date),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 12),
                    ExerciseCardPreview(
                      routine: routine,
                      interactive: !_isCelebrating,
                      completedItemIds: _completedItemIds,
                      onItemToggle: _toggleItem,
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _isCelebrating ? null : _finishRoutine,
                      icon: const Icon(Icons.check_circle_outline),
                      label: Text(l10n.finishRoutine),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                      ),
                    ),
                    if (_isCelebrating) ...[
                      const SizedBox(height: 24),
                      Text(
                        l10n.routineCompleted,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ],
                  ],
                ),
        ),
        _buildConfetti(),
      ],
    );
  }
}
