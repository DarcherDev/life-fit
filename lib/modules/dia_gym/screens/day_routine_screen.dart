import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import 'package:life_fit/core/navigation/app_navigation.dart';
import 'package:life_fit/core/widgets/app_scaffold.dart';
import 'package:life_fit/core/repositories/app_repositories.dart';
import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/modules/calentamiento/models/warm_up.dart';
import 'package:life_fit/modules/rutinas/widgets/routine_card_preview.dart';
import 'package:life_fit/shared/models/routine_exercise_slot.dart';
import 'package:life_fit/shared/models/routine_stretching_slot.dart';
import 'package:life_fit/shared/utils/routine_resolver.dart';
import 'package:life_fit/shared/utils/template_l10n.dart';
import 'package:life_fit/shared/widgets/library_picker_sheet.dart';
import 'package:life_fit/shared/models/routine_card.dart';
import 'package:life_fit/shared/utils/date_utils.dart';
import 'package:life_fit/shared/utils/locale_format.dart';
import 'package:life_fit/shared/widgets/confirm_dialog.dart';
import 'package:life_fit/shared/models/resolved_routine.dart';
import 'package:life_fit/shared/widgets/exercise_weight_dialog.dart';
import 'package:life_fit/shared/widgets/routine_assign_sheet.dart';

/// Pantalla del módulo **Día de gym**.
///
/// Hoy ejecuta ejercicios, calentamiento y estiramiento opcionales.

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
  final _repos = AppRepositories.instance;
  late final ConfettiController _confettiController;
  RoutineCard? _routine;
  Set<String> _completedItemIds = {};
  /// Completados visualmente pero aún sin bajar al final de la lista.
  final Set<String> _pendingSettleIds = {};
  var _isCelebrating = false;

  static const _completeSettleDelay = Duration(milliseconds: 500);

  bool get _isToday => widget.dateKey == AppNavigation.todayDateKey;

  Set<String> get _visualCompletedItemIds => {
        ..._completedItemIds,
        ..._pendingSettleIds,
      };

  bool get _allItemsCompleted {
    final routine = _routine;
    if (routine == null || !routine.hasExercises) {
      return false;
    }

    final exercisesDone = routine.exerciseSlots.every(
      (slot) => _completedItemIds.contains(slot.slotId),
    );

    if (!routine.hasWarmUp && !routine.hasStretching) {
      return exercisesDone;
    }

    final warmUpDone =
        !routine.hasWarmUp || _completedItemIds.contains(warmUpProgressItemId);
    final stretchingDone = !routine.hasStretching ||
        routine.stretchingSlots.every(
          (slot) => _completedItemIds.contains(slot.slotId),
        );

    return exercisesDone && warmUpDone && stretchingDone;
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
    final assignment = _repos.assignments.getAssignmentForDate(widget.dateKey);
    final routine = assignment == null
        ? null
        : _repos.routines.getRoutineById(assignment.routineId);
    final progress = _repos.progress.getDayProgress(widget.dateKey);

    setState(() {
      _routine = routine;
      _completedItemIds = Set<String>.from(progress.completedItemIds);
      _pendingSettleIds.clear();
    });
  }

  DateTime get _date => DateKeys.toDate(widget.dateKey);

  Future<void> _toggleItem(String itemId, bool completed) async {
    if (_isCelebrating) {
      return;
    }

    if (completed) {
      setState(() {
        _pendingSettleIds.add(itemId);
      });
      await _repos.progress.toggleItem(widget.dateKey, itemId, true);
      await Future<void>.delayed(_completeSettleDelay);
      if (!mounted || !_pendingSettleIds.contains(itemId)) {
        return;
      }
      setState(() {
        _pendingSettleIds.remove(itemId);
        _completedItemIds.add(itemId);
      });
      if (_allItemsCompleted) {
        await _finishRoutine();
      }
      return;
    }

    setState(() {
      _pendingSettleIds.remove(itemId);
      _completedItemIds.remove(itemId);
    });
    await _repos.progress.toggleItem(widget.dateKey, itemId, false);
  }

  Future<void> _reorderExercises(int oldIndex, int newIndex) async {
    final routine = _routine;
    if (routine == null || _isCelebrating) {
      return;
    }

    final reordered = _reorderSlotsByDisplayOrder(
      slots: routine.exerciseSlots,
      slotIdOf: (slot) => slot.slotId,
      oldIndex: oldIndex,
      newIndex: newIndex,
    );
    if (reordered == null) {
      return;
    }

    final updated = routine.copyWith(exerciseSlots: reordered);
    await _repos.routines.upsertRoutineCard(updated);
    if (!mounted) {
      return;
    }
    setState(() => _routine = updated);
  }

  Future<void> _reorderStretchings(int oldIndex, int newIndex) async {
    final routine = _routine;
    if (routine == null || _isCelebrating) {
      return;
    }

    final reordered = _reorderSlotsByDisplayOrder(
      slots: routine.stretchingSlots,
      slotIdOf: (slot) => slot.slotId,
      oldIndex: oldIndex,
      newIndex: newIndex,
    );
    if (reordered == null) {
      return;
    }

    final updated = routine.copyWith(stretchingSlots: reordered);
    await _repos.routines.upsertRoutineCard(updated);
    if (!mounted) {
      return;
    }
    setState(() => _routine = updated);
  }

  /// Reordena según la lista visual (pendientes primero, luego completados).
  List<T>? _reorderSlotsByDisplayOrder<T>({
    required List<T> slots,
    required String Function(T slot) slotIdOf,
    required int oldIndex,
    required int newIndex,
  }) {
    if (oldIndex < 0 || oldIndex >= slots.length) {
      return null;
    }

    final pending = <T>[];
    final done = <T>[];
    for (final slot in slots) {
      if (_completedItemIds.contains(slotIdOf(slot))) {
        done.add(slot);
      } else {
        pending.add(slot);
      }
    }
    final display = [...pending, ...done];
    if (oldIndex >= display.length) {
      return null;
    }

    var targetIndex = newIndex;
    if (targetIndex > oldIndex) {
      targetIndex -= 1;
    }
    if (targetIndex < 0) {
      targetIndex = 0;
    }
    if (targetIndex > display.length) {
      targetIndex = display.length;
    }

    final item = display.removeAt(oldIndex);
    display.insert(targetIndex, item);
    return display;
  }

  Future<void> _editExerciseWeight(ResolvedExercise exercise) async {
    final template =
        _repos.getLibraries().exercises[exercise.exerciseId];
    if (template == null) {
      return;
    }

    final result = await ExerciseWeightDialog.show(
      context,
      exerciseTitle: exercise.title,
      series: exercise.series,
      repetitions: exercise.repetitions,
      currentWeightKg: exercise.weightKg,
    );
    if (result.cancelled || !mounted) {
      return;
    }

    await _repos.exerciseTemplates.upsertExerciseTemplate(
      template.copyWith(
        series: result.series,
        repetitions: result.repetitions,
        weightKg: result.weightKg,
        clearWeightKg: result.clearWeightKg,
      ),
    );
    if (mounted) {
      _loadData();
    }
  }

  Future<void> _persistRoutine(
    RoutineCard updated, {
    String? clearProgressForItemId,
  }) async {
    await _repos.routines.upsertRoutineCard(updated);
    if (clearProgressForItemId != null &&
        _completedItemIds.contains(clearProgressForItemId)) {
      await _repos.progress.toggleItem(
        widget.dateKey,
        clearProgressForItemId,
        false,
      );
    }
    if (mounted) {
      _loadData();
    }
  }

  Future<void> _replaceExercise(ResolvedExercise exercise) async {
    if (_isCelebrating) {
      return;
    }
    final routine = _routine;
    if (routine == null || exercise.isMissing) {
      return;
    }

    final l10n = AppLocalizations.of(context);
    final templates = _repos.exerciseTemplates.getExerciseTemplates();
    String? selectedId;
    if (templates.isEmpty) {
      selectedId = await AppNavigation.openExerciseLibraryForCreation(context);
    } else {
      final selected = await LibraryPickerSheet.show(
        context,
        title: l10n.changeExercise,
        multiSelect: false,
        selectedIds: [exercise.exerciseId],
        createButtonLabel: l10n.newExerciseTemplate,
        onCreateItem: () async =>
            AppNavigation.openExerciseLibraryToCreate(context),
        items: templates
            .map(
              (item) => LibraryPickerItem(
                id: item.id,
                title: item.title,
                subtitle: item.localizedSubtitle(l10n),
              ),
            )
            .toList(),
      );
      if (selected == null || selected.isEmpty) {
        return;
      }
      selectedId = selected.first;
    }

    if (!mounted || selectedId == null || selectedId == exercise.exerciseId) {
      return;
    }

    final updatedSlots = routine.exerciseSlots
        .map(
          (slot) => slot.slotId == exercise.slotId
              ? RoutineExerciseSlot(
                  slotId: slot.slotId,
                  exerciseId: selectedId!,
                )
              : slot,
        )
        .toList();

    await _persistRoutine(
      routine.copyWith(exerciseSlots: updatedSlots),
      clearProgressForItemId: exercise.slotId,
    );
  }

  Future<void> _replaceStretching(ResolvedStretching stretching) async {
    if (_isCelebrating) {
      return;
    }
    final routine = _routine;
    if (routine == null || stretching.isMissing) {
      return;
    }

    final l10n = AppLocalizations.of(context);
    final templates = _repos.stretchingTemplates.getStretchingTemplates();
    final currentSlot = routine.stretchingSlots.firstWhere(
      (slot) => slot.slotId == stretching.slotId,
    );
    String? selectedId;
    if (templates.isEmpty) {
      selectedId =
          await AppNavigation.openStretchingLibraryForCreation(context);
    } else {
      final selected = await LibraryPickerSheet.show(
        context,
        title: l10n.changeStretching,
        multiSelect: false,
        selectedIds: [currentSlot.stretchingId],
        createButtonLabel: l10n.newStretchingTemplate,
        onCreateItem: () async =>
            AppNavigation.openStretchingLibraryToCreate(context),
        items: templates
            .map(
              (item) => LibraryPickerItem(
                id: item.id,
                title: item.description,
                subtitle: l10n.stretchingRepetitionsFormat(item.repetitions),
              ),
            )
            .toList(),
      );
      if (selected == null || selected.isEmpty) {
        return;
      }
      selectedId = selected.first;
    }

    if (!mounted || selectedId == null) {
      return;
    }

    if (selectedId == currentSlot.stretchingId) {
      return;
    }

    final updatedSlots = routine.stretchingSlots
        .map(
          (slot) => slot.slotId == stretching.slotId
              ? RoutineStretchingSlot(
                  slotId: slot.slotId,
                  stretchingId: selectedId!,
                )
              : slot,
        )
        .toList();

    await _persistRoutine(
      routine.copyWith(stretchingSlots: updatedSlots),
      clearProgressForItemId: stretching.slotId,
    );
  }

  Future<void> _replaceWarmUp() async {
    if (_isCelebrating) {
      return;
    }
    final routine = _routine;
    if (routine == null || !routine.hasWarmUp) {
      return;
    }

    final l10n = AppLocalizations.of(context);
    final templates = _repos.warmUpTemplates.getWarmUpTemplates();
    String? selectedId;
    if (templates.isEmpty) {
      selectedId = await AppNavigation.openWarmUpLibraryForCreation(context);
    } else {
      final selected = await LibraryPickerSheet.show(
        context,
        title: l10n.changeWarmUp,
        multiSelect: false,
        selectedIds: routine.warmUpId == null ? [] : [routine.warmUpId!],
        createButtonLabel: l10n.newWarmUpTemplate,
        onCreateItem: () async =>
            AppNavigation.openWarmUpLibraryToCreate(context),
        items: templates
            .map(
              (item) => LibraryPickerItem(
                id: item.id,
                title: item.description,
                subtitle: l10n.warmUpMinutesFormat(item.minutes),
              ),
            )
            .toList(),
      );
      if (selected == null || selected.isEmpty) {
        return;
      }
      selectedId = selected.first;
    }

    if (!mounted || selectedId == null || selectedId == routine.warmUpId) {
      return;
    }

    await _persistRoutine(
      routine.copyWith(warmUpId: selectedId),
      clearProgressForItemId: warmUpProgressItemId,
    );
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
    final assignment = _repos.assignments.getAssignmentForDate(widget.dateKey);
    final selectedId = await RoutineAssignSheet.show(
      context,
      date: _date,
      routines: _repos.routines.getRoutineCards(),
      currentRoutineId: assignment?.routineId,
      title: l10n.changeRoutine,
    );

    if (selectedId == null || selectedId.isEmpty) {
      return;
    }

    await _repos.assignments.saveAssignment(widget.dateKey, selectedId);
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

    await _repos.assignments.saveAssignment(widget.dateKey, null);
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
    final resolved = routine == null
        ? null
        : resolveRoutine(routine, _repos.getLibraries(), l10n: l10n);

    return Stack(
      children: [
        AppScaffold(
          title: _isToday
              ? l10n.todayRoutine
              : formatShortDate(context, _date),
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
          body: resolved == null
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
                    RoutineCardPreview(
                      routine: resolved,
                      interactive: !_isCelebrating,
                      pendingItemsFirst: true,
                      completedItemIds: _visualCompletedItemIds,
                      settledCompletedItemIds: _completedItemIds,
                      onItemToggle: _toggleItem,
                      onExerciseWeightEdit: _editExerciseWeight,
                      onExerciseReplace: _replaceExercise,
                      onStretchingReplace: _replaceStretching,
                      onWarmUpReplace: _replaceWarmUp,
                      onReorderExercises: _reorderExercises,
                      onReorderStretchings: _reorderStretchings,
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
