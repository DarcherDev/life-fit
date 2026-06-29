import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/core/navigation/app_navigation.dart';
import 'package:life_fit/core/services/local_storage_service.dart';
import 'package:life_fit/modules/ejercicios/widgets/exercise_card_preview.dart';
import 'package:life_fit/shared/models/checklist_item.dart';
import 'package:life_fit/shared/models/routine_card.dart';
import 'package:life_fit/shared/utils/checklist_l10n.dart';

class ExerciseFormScreen extends StatefulWidget {
  const ExerciseFormScreen({
    super.key,
    this.routine,
    this.autoAssignDateKey,
  });

  final RoutineCard? routine;
  final String? autoAssignDateKey;

  @override
  State<ExerciseFormScreen> createState() => _ExerciseFormScreenState();
}

class _ExerciseFormItem {
  _ExerciseFormItem({
    required this.id,
    required this.titleController,
    required this.seriesController,
    required this.repetitionsController,
    required this.titleFocusNode,
  });

  final String id;
  final TextEditingController titleController;
  final TextEditingController seriesController;
  final TextEditingController repetitionsController;
  final FocusNode titleFocusNode;
  final GlobalKey itemKey = GlobalKey();
}

class _ExerciseFormScreenState extends State<ExerciseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storage = LocalStorageService.instance;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _scrollController = ScrollController();
  final _items = <_ExerciseFormItem>[];
  final _uuid = const Uuid();

  bool get _isEditing => widget.routine != null;

  @override
  void initState() {
    super.initState();
    final routine = widget.routine;
    if (routine != null) {
      _titleController.text = routine.title;
      _descriptionController.text = routine.description;
      for (final item in routine.items) {
        _items.add(_createFormItem(
          id: item.id,
          title: item.title,
          series: item.series,
          repetitions: item.repetitions,
        ));
      }
    }
  }

  _ExerciseFormItem _createFormItem({
    String? id,
    String title = '',
    int? series,
    int? repetitions,
  }) {
    return _ExerciseFormItem(
      id: id ?? _uuid.v4(),
      titleController: TextEditingController(text: title),
      seriesController: TextEditingController(
        text: series?.toString() ?? '',
      ),
      repetitionsController: TextEditingController(
        text: repetitions?.toString() ?? '',
      ),
      titleFocusNode: FocusNode(),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _scrollController.dispose();
    for (final item in _items) {
      item.titleController.dispose();
      item.seriesController.dispose();
      item.repetitionsController.dispose();
      item.titleFocusNode.dispose();
    }
    super.dispose();
  }

  int? _parsePositiveInt(String value) {
    final parsed = int.tryParse(value.trim());
    if (parsed == null || parsed <= 0) {
      return null;
    }
    return parsed;
  }

  ChecklistItem? _itemFromForm(_ExerciseFormItem item) {
    final title = item.titleController.text.trim();
    final series = _parsePositiveInt(item.seriesController.text);
    final repetitions = _parsePositiveInt(item.repetitionsController.text);

    if (title.isEmpty || series == null || repetitions == null) {
      return null;
    }

    return ChecklistItem(
      id: item.id,
      title: title,
      series: series,
      repetitions: repetitions,
    );
  }

  bool _isItemComplete(_ExerciseFormItem item) {
    return _itemFromForm(item) != null;
  }

  int? _firstIncompleteItemIndex() {
    for (var i = 0; i < _items.length; i++) {
      if (!_isItemComplete(_items[i])) {
        return i;
      }
    }
    return null;
  }

  void _scrollToItem(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _items[index].itemKey.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: 0.2,
        );
      }
    });
  }

  void _addItem() {
    final l10n = AppLocalizations.of(context);
    final incompleteIndex = _firstIncompleteItemIndex();
    if (incompleteIndex != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.completeBeforeAddAnother)),
      );
      _scrollToItem(incompleteIndex);
      _items[incompleteIndex].titleFocusNode.requestFocus();
      return;
    }

    setState(() {
      _items.add(_createFormItem());
    });

    final newIndex = _items.length - 1;
    _scrollToItem(newIndex);
    _items[newIndex].titleFocusNode.requestFocus();
  }

  void _removeItem(int index) {
    setState(() {
      final item = _items.removeAt(index);
      item.titleController.dispose();
      item.seriesController.dispose();
      item.repetitionsController.dispose();
      item.titleFocusNode.dispose();
    });
  }

  List<ChecklistItem> _validPreviewItems() {
    return _items
        .map(_itemFromForm)
        .whereType<ChecklistItem>()
        .toList();
  }

  RoutineCard? _buildPreviewCard(AppLocalizations l10n) {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final items = _validPreviewItems();

    if (title.isEmpty && description.isEmpty && items.isEmpty) {
      return null;
    }

    return RoutineCard(
      id: widget.routine?.id ?? 'preview',
      title: title.isEmpty ? l10n.noTitle : title,
      description: description,
      items: items,
    );
  }

  String? _validateSeries(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.required;
    }
    if (_parsePositiveInt(value) == null) {
      return l10n.validNumber;
    }
    return null;
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);

    if (!_formKey.currentState!.validate()) {
      final incompleteIndex = _firstIncompleteItemIndex();
      if (incompleteIndex != null) {
        _scrollToItem(incompleteIndex);
      }
      return;
    }

    final validItems = _validPreviewItems();

    if (validItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.addAtLeastOneExercise)),
      );
      return;
    }

    if (validItems.length != _items.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.completeAllBeforeSave)),
      );
      final incompleteIndex = _firstIncompleteItemIndex();
      if (incompleteIndex != null) {
        _scrollToItem(incompleteIndex);
      }
      return;
    }

    final card = RoutineCard(
      id: widget.routine?.id ?? _uuid.v4(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      items: validItems,
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final previewCard = _buildPreviewCard(l10n);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.editExerciseCard : l10n.newExerciseCard),
        actions: [
          IconButton(
            onPressed: _save,
            icon: const Icon(Icons.check),
            tooltip: l10n.save,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        tooltip: l10n.addExercise,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Form(
        key: _formKey,
        child: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: l10n.fieldTitle,
                hintText: l10n.fieldTitleHint,
                border: const OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.characters,
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
                hintText: l10n.fieldDescriptionHint,
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.previewTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            if (previewCard == null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceVariant
                      .withOpacity(0.35),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color:
                        Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  l10n.previewEmptyHint,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              )
            else
              ExerciseCardPreview(routine: previewCard),
            const SizedBox(height: 24),
            Text(
              l10n.exercisesTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            if (_items.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  l10n.addFirstExerciseHint,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            ...List.generate(_items.length, (index) {
              final item = _items[index];
              final formItem = _itemFromForm(item);

              return Card(
                key: item.itemKey,
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: item.titleController,
                        focusNode: item.titleFocusNode,
                        decoration: InputDecoration(
                          labelText: l10n.exerciseLabel(index + 1),
                          hintText: l10n.exerciseHint,
                          border: const OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.required;
                          }
                          return null;
                        },
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: item.seriesController,
                              decoration: InputDecoration(
                                labelText: l10n.fieldSeries,
                                hintText: l10n.fieldSeriesHint,
                                border: const OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) => _validateSeries(value, l10n),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: item.repetitionsController,
                              decoration: InputDecoration(
                                labelText: l10n.fieldRepetitions,
                                hintText: l10n.fieldRepetitionsHint,
                                border: const OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) => _validateSeries(value, l10n),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                        ],
                      ),
                      if (formItem != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          formItem.localizedSubtitle(l10n),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () => _removeItem(index),
                          icon: const Icon(Icons.delete_outline),
                          label: Text(l10n.delete),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: Text(l10n.saveExerciseCard),
            ),
          ],
        ),
      ),
    );
  }
}
