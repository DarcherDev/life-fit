import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/core/widgets/app_scaffold.dart';
import 'package:life_fit/shared/widgets/exercise_weight_dialog.dart';
import 'package:life_fit/core/navigation/app_navigation.dart';
import 'package:life_fit/core/repositories/app_repositories.dart';
import 'package:life_fit/modules/calentamiento/models/warm_up_placement.dart';
import 'package:life_fit/modules/calentamiento/widgets/warm_up_placement_dialog.dart';
import 'package:life_fit/shared/flows/library_quick_edit_actions.dart';
import 'package:life_fit/shared/models/routine_card.dart';
import 'package:life_fit/shared/models/routine_exercise_slot.dart';
import 'package:life_fit/shared/models/routine_stretching_slot.dart';
import 'package:life_fit/shared/utils/routine_resolver.dart';
import 'package:life_fit/shared/utils/template_l10n.dart';
import 'package:life_fit/shared/widgets/library_picker_sheet.dart';

class RoutineFormScreen extends StatefulWidget {
  const RoutineFormScreen({
    super.key,
    this.routine,
    this.autoAssignDateKey,
  });

  final RoutineCard? routine;
  final String? autoAssignDateKey;

  @override
  State<RoutineFormScreen> createState() => _RoutineFormScreenState();
}

class _RoutineFormScreenState extends State<RoutineFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _repos = AppRepositories.instance;
  late final _quickEdit = LibraryQuickEditActions(
    warmUpTemplates: _repos.warmUpTemplates,
    stretchingTemplates: _repos.stretchingTemplates,
  );
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _uuid = const Uuid();

  final _warmUpIds = <WarmUpPlacement, String?>{};
  final _exerciseSlots = <RoutineExerciseSlot>[];
  final _stretchingSlots = <RoutineStretchingSlot>[];

  bool get _isEditing => widget.routine != null;

  @override
  void initState() {
    super.initState();
    final routine = widget.routine;
    if (routine != null) {
      _titleController.text = routine.title;
      _descriptionController.text = routine.description;
      for (final placement in WarmUpPlacement.values) {
        _warmUpIds[placement] = routine.warmUpIdFor(placement);
      }
      _exerciseSlots.addAll(routine.exerciseSlots);
      _stretchingSlots.addAll(routine.stretchingSlots);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// Pregunta la posición y asigna [warmUpId] allí, reemplazando si existía.
  Future<void> _assignWarmUp(String? warmUpId) async {
    if (!mounted || warmUpId == null) {
      return;
    }

    final warmUps = _repos.getLibraries().warmUps;
    String? occupiedBy(WarmUpPlacement placement) {
      final currentId = _warmUpIds[placement];
      if (currentId == null) {
        return null;
      }
      return warmUps[currentId]?.description ??
          AppLocalizations.of(context).missingTemplateLabel;
    }

    final placement = await WarmUpPlacementDialog.show(
      context,
      startOccupiedBy: occupiedBy(WarmUpPlacement.start),
      endOccupiedBy: occupiedBy(WarmUpPlacement.end),
    );
    if (!mounted || placement == null) {
      return;
    }
    setState(() => _warmUpIds[placement] = warmUpId);
  }

  Future<void> _assignExerciseFromCreatedId(String? createdId) async {
    if (!mounted || createdId == null) {
      return;
    }
    setState(() {
      _exerciseSlots.add(
        RoutineExerciseSlot(slotId: _uuid.v4(), exerciseId: createdId),
      );
    });
  }

  Future<void> _assignStretchingFromCreatedId(String? createdId) async {
    if (!mounted || createdId == null) {
      return;
    }
    setState(() {
      _stretchingSlots.add(
        RoutineStretchingSlot(slotId: _uuid.v4(), stretchingId: createdId),
      );
    });
  }

  Future<void> _pickWarmUp() async {
    final l10n = AppLocalizations.of(context);
    final templates = _repos.warmUpTemplates.getWarmUpTemplates();
    if (templates.isEmpty) {
      await _assignWarmUp(
        await AppNavigation.openWarmUpLibraryForCreation(context),
      );
      return;
    }

    final selected = await LibraryPickerSheet.show(
      context,
      title: l10n.pickWarmUpTitle,
      multiSelect: false,
      createButtonLabel: l10n.newWarmUpTemplate,
      onCreateItem: () async {
        await _assignWarmUp(
          await AppNavigation.openWarmUpLibraryToCreate(context),
        );
      },
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

    if (selected != null && selected.isNotEmpty) {
      await _assignWarmUp(selected.first);
    }
  }

  Future<void> _pickExercises() async {
    final l10n = AppLocalizations.of(context);
    final templates = _repos.exerciseTemplates.getExerciseTemplates();
    if (templates.isEmpty) {
      await _assignExerciseFromCreatedId(
        await AppNavigation.openExerciseLibraryForCreation(context),
      );
      return;
    }

    final selected = await LibraryPickerSheet.show(
      context,
      title: l10n.pickExercisesTitle,
      createButtonLabel: l10n.newExerciseTemplate,
      onCreateItem: () async {
        await _assignExerciseFromCreatedId(
          await AppNavigation.openExerciseLibraryToCreate(context),
        );
      },
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

    setState(() {
      for (final id in selected) {
        _exerciseSlots.add(
          RoutineExerciseSlot(slotId: _uuid.v4(), exerciseId: id),
        );
      }
    });
  }

  Future<void> _pickStretchings() async {
    final l10n = AppLocalizations.of(context);
    final templates = _repos.stretchingTemplates.getStretchingTemplates();
    if (templates.isEmpty) {
      await _assignStretchingFromCreatedId(
        await AppNavigation.openStretchingLibraryForCreation(context),
      );
      return;
    }

    final selected = await LibraryPickerSheet.show(
      context,
      title: l10n.pickStretchingsTitle,
      createButtonLabel: l10n.newStretchingTemplate,
      onCreateItem: () async {
        await _assignStretchingFromCreatedId(
          await AppNavigation.openStretchingLibraryToCreate(context),
        );
      },
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

    setState(() {
      for (final id in selected) {
        _stretchingSlots.add(
          RoutineStretchingSlot(slotId: _uuid.v4(), stretchingId: id),
        );
      }
    });
  }

  void _removeExerciseSlot(int index) {
    setState(() => _exerciseSlots.removeAt(index));
  }

  void _removeStretchingSlot(int index) {
    setState(() => _stretchingSlots.removeAt(index));
  }

  Future<void> _editExerciseWeight(RoutineExerciseSlot slot) async {
    final template = _repos.getLibraries().exercises[slot.exerciseId];
    if (template == null) {
      return;
    }

    final result = await ExerciseWeightDialog.show(
      context,
      exerciseTitle: template.title,
      description: template.description,
      series: template.series,
      repetitions: template.repetitions,
      currentWeightKg: template.weightKg,
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
      setState(() {});
    }
  }

  Future<void> _editWarmUp(String warmUpId) async {
    final changed = await _quickEdit.editWarmUpMinutes(context, warmUpId);
    if (changed && mounted) {
      setState(() {});
    }
  }

  Future<void> _editStretching(String stretchingId) async {
    final changed = await _quickEdit.editStretchingRepetitions(
      context,
      stretchingId,
    );
    if (changed && mounted) {
      setState(() {});
    }
  }

  Widget _buildExerciseSlotList(RoutineLibraries libraries) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.exercisesTitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        if (_exerciseSlots.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              l10n.routineSlotsEmpty,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        ...List.generate(_exerciseSlots.length, (index) {
          final slot = _exerciseSlots[index];
          final template = libraries.exercises[slot.exerciseId];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(template?.title ?? l10n.missingTemplateLabel),
              subtitle: template == null
                  ? null
                  : Text(template.localizedSubtitle(l10n)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (template != null)
                    IconButton(
                      icon: const Icon(Icons.scale_outlined),
                      tooltip: l10n.editExercise,
                      onPressed: () => _editExerciseWeight(slot),
                    ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () => _removeExerciseSlot(index),
                  ),
                ],
              ),
            ),
          );
        }),
        OutlinedButton.icon(
          onPressed: _pickExercises,
          icon: const Icon(Icons.add),
          label: Text(l10n.addFromLibrary),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final hasWarmUp = _warmUpIds.values.any((id) => id != null);
    if (!hasWarmUp && _stretchingSlots.isEmpty && _exerciseSlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.addAtLeastOneItemToRoutine)),
      );
      return;
    }

    final card = RoutineCard(
      id: widget.routine?.id ?? _uuid.v4(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      exerciseSlots: List.unmodifiable(_exerciseSlots),
      startWarmUpId: _warmUpIds[WarmUpPlacement.start],
      endWarmUpId: _warmUpIds[WarmUpPlacement.end],
      stretchingSlots: List.unmodifiable(_stretchingSlots),
    );

    await _repos.routines.upsertRoutineCard(card);
    if (!mounted) {
      return;
    }

    final autoAssignDateKey = widget.autoAssignDateKey;
    if (autoAssignDateKey != null) {
      await _repos.assignments.saveAssignment(autoAssignDateKey, card.id);
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(true);
      return;
    }

    Navigator.of(context).pop(true);
  }

  String _placementLabel(AppLocalizations l10n, WarmUpPlacement placement) {
    return placement == WarmUpPlacement.start
        ? l10n.warmUpPlacementStart
        : l10n.warmUpPlacementEnd;
  }

  Widget _buildWarmUpCard(
    RoutineLibraries libraries,
    WarmUpPlacement placement,
    String warmUpId,
  ) {
    final l10n = AppLocalizations.of(context);
    final template = libraries.warmUps[warmUpId];
    final placementLabel = _placementLabel(l10n, placement);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(template?.description ?? l10n.missingTemplateLabel),
        subtitle: Text(
          template == null
              ? placementLabel
              : l10n.warmUpWithPlacementFormat(
                  template.minutes,
                  placementLabel,
                ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (template != null)
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: l10n.editWarmUpTemplate,
                onPressed: () => _editWarmUp(template.id),
              ),
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => setState(() => _warmUpIds[placement] = null),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWarmUpSection(RoutineLibraries libraries) {
    final l10n = AppLocalizations.of(context);
    final assigned = [
      for (final placement in WarmUpPlacement.values)
        if (_warmUpIds[placement] != null)
          _buildWarmUpCard(libraries, placement, _warmUpIds[placement]!),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.warmUpTitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        if (assigned.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              l10n.noWarmUpSelected,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ...assigned,
        OutlinedButton.icon(
          onPressed: _pickWarmUp,
          icon: const Icon(Icons.local_fire_department),
          label: Text(l10n.pickWarmUpTitle),
        ),
      ],
    );
  }

  Widget _buildSlotList<T>({
    required String title,
    required List<T> slots,
    required String Function(T slot) label,
    required String? Function(T slot) subtitle,
    required VoidCallback onAdd,
    required ValueChanged<int> onRemove,
    VoidCallback? Function(T slot)? onEdit,
    String? editTooltip,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        if (slots.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              AppLocalizations.of(context).routineSlotsEmpty,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        ...List.generate(slots.length, (index) {
          final slot = slots[index];
          final editAction = onEdit?.call(slot);
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(label(slot)),
              subtitle: subtitle(slot) == null ? null : Text(subtitle(slot)!),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (editAction != null)
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      tooltip: editTooltip,
                      onPressed: editAction,
                    ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () => onRemove(index),
                  ),
                ],
              ),
            ),
          );
        }),
        OutlinedButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add),
          label: Text(AppLocalizations.of(context).addFromLibrary),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final libraries = _repos.getLibraries();

    return AppScaffold(
      title: _isEditing ? l10n.editRoutine : l10n.newRoutine,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: FilledButton(
            onPressed: _save,
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              minimumSize: const Size(48, 40),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Icon(Icons.check, size: 28, weight: 700),
          ),
        ),
      ],
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: l10n.fieldTitle,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.titleRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: l10n.fieldDescription,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            _buildWarmUpSection(libraries),
            const SizedBox(height: 24),
            _buildSlotList<RoutineStretchingSlot>(
              title: l10n.stretchingsTitle,
              slots: _stretchingSlots,
              label: (slot) =>
                  libraries.stretchings[slot.stretchingId]?.description ??
                  l10n.missingTemplateLabel,
              subtitle: (slot) {
                final template = libraries.stretchings[slot.stretchingId];
                return template == null
                    ? null
                    : l10n.stretchingRepetitionsFormat(template.repetitions);
              },
              onAdd: _pickStretchings,
              onRemove: _removeStretchingSlot,
              onEdit: (slot) =>
                  libraries.stretchings.containsKey(slot.stretchingId)
                      ? () => _editStretching(slot.stretchingId)
                      : null,
              editTooltip: l10n.editStretchingTemplate,
            ),
            _buildExerciseSlotList(libraries),
          ],
        ),
      ),
    );
  }
}
