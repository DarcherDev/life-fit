import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/core/widgets/app_scaffold.dart';
import 'package:life_fit/shared/widgets/exercise_weight_dialog.dart';
import 'package:life_fit/core/navigation/app_navigation.dart';
import 'package:life_fit/core/services/local_storage_service.dart';
import 'package:life_fit/modules/calentamiento/models/warm_up_placement.dart';
import 'package:life_fit/modules/rutinas/widgets/routine_card_preview.dart';
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
  final _storage = LocalStorageService.instance;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _uuid = const Uuid();

  String? _warmUpId;
  var _warmUpPlacement = WarmUpPlacement.start;
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
      _warmUpId = routine.warmUpId;
      _warmUpPlacement = routine.warmUpPlacement;
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

  RoutineCard _buildCard() {
    return RoutineCard(
      id: widget.routine?.id ?? 'preview',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      exerciseSlots: List.unmodifiable(_exerciseSlots),
      warmUpId: _warmUpId,
      warmUpPlacement: _warmUpPlacement,
      stretchingSlots: List.unmodifiable(_stretchingSlots),
    );
  }

  Future<void> _assignWarmUpFromCreatedId(String? createdId) async {
    if (!mounted || createdId == null) {
      return;
    }
    setState(() => _warmUpId = createdId);
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
    final templates = _storage.getWarmUpTemplates();
    if (templates.isEmpty) {
      await _assignWarmUpFromCreatedId(
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
        await _assignWarmUpFromCreatedId(
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
      setState(() => _warmUpId = selected.first);
    }
  }

  Future<void> _pickExercises() async {
    final l10n = AppLocalizations.of(context);
    final templates = _storage.getExerciseTemplates();
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
    final templates = _storage.getStretchingTemplates();
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
    final template = _storage.getLibraries().exercises[slot.exerciseId];
    if (template == null) {
      return;
    }

    final result = await ExerciseWeightDialog.show(
      context,
      exerciseTitle: template.title,
      currentWeightKg: template.weightKg,
    );
    if (result.cancelled || !mounted) {
      return;
    }

    await _storage.upsertExerciseTemplate(
      template.copyWith(
        weightKg: result.weightKg,
        clearWeightKg: result.weightKg == null,
      ),
    );
    if (mounted) {
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
                      tooltip: l10n.editExerciseWeight,
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

    if (_exerciseSlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.addAtLeastOneExerciseToRoutine)),
      );
      return;
    }

    final card = RoutineCard(
      id: widget.routine?.id ?? _uuid.v4(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      exerciseSlots: List.unmodifiable(_exerciseSlots),
      warmUpId: _warmUpId,
      warmUpPlacement: _warmUpPlacement,
      stretchingSlots: List.unmodifiable(_stretchingSlots),
    );

    await _storage.upsertRoutineCard(card);
    if (!mounted) {
      return;
    }

    final autoAssignDateKey = widget.autoAssignDateKey;
    if (autoAssignDateKey != null) {
      await _storage.saveAssignment(autoAssignDateKey, card.id);
      if (!mounted) {
        return;
      }
      AppNavigation.replaceWithDayRoutine(context, autoAssignDateKey);
      return;
    }

    Navigator.of(context).pop(true);
  }

  Widget _buildSlotList<T>({
    required String title,
    required List<T> slots,
    required String Function(T slot) label,
    required String? Function(T slot) subtitle,
    required VoidCallback onAdd,
    required ValueChanged<int> onRemove,
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
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(label(slot)),
              subtitle: subtitle(slot) == null ? null : Text(subtitle(slot)!),
              trailing: IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () => onRemove(index),
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
    final libraries = _storage.getLibraries();
    final preview = resolveRoutine(_buildCard(), libraries, l10n: l10n);
    final warmUpTemplate = _warmUpId == null
        ? null
        : libraries.warmUps[_warmUpId];

    return AppScaffold(
      title: _isEditing ? l10n.editRoutine : l10n.newRoutine,
      actions: [
        IconButton(
          onPressed: _save,
          icon: const Icon(Icons.check),
          tooltip: l10n.save,
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
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: l10n.fieldDescription,
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.warmUpTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            if (warmUpTemplate != null)
              Card(
                child: ListTile(
                  title: Text(warmUpTemplate.description),
                  subtitle: Text(l10n.warmUpMinutesFormat(warmUpTemplate.minutes)),
                  trailing: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => setState(() => _warmUpId = null),
                  ),
                ),
              )
            else
              Text(
                l10n.noWarmUpSelected,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _pickWarmUp,
              icon: const Icon(Icons.local_fire_department),
              label: Text(l10n.pickWarmUpTitle),
            ),
            if (_warmUpId != null) ...[
              const SizedBox(height: 12),
              SegmentedButton<WarmUpPlacement>(
                segments: [
                  ButtonSegment(
                    value: WarmUpPlacement.start,
                    label: Text(l10n.warmUpPlacementStart),
                  ),
                  ButtonSegment(
                    value: WarmUpPlacement.end,
                    label: Text(l10n.warmUpPlacementEnd),
                  ),
                ],
                selected: {_warmUpPlacement},
                onSelectionChanged: (value) {
                  setState(() => _warmUpPlacement = value.first);
                },
              ),
            ],
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
            ),
            _buildExerciseSlotList(libraries),
            Text(
              l10n.previewTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            RoutineCardPreview(routine: preview),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: Text(l10n.saveRoutine),
            ),
          ],
        ),
      ),
    );
  }
}
