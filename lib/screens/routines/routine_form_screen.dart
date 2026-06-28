import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import '../../models/checklist_item.dart';
import '../../models/routine_card.dart';
import '../../screens/planner/day_routine_screen.dart';
import '../../services/local_storage_service.dart';
import '../../widgets/routine_card_preview.dart';

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

class _RoutineFormItem {
  _RoutineFormItem({
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

class _RoutineFormScreenState extends State<RoutineFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storage = LocalStorageService.instance;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _scrollController = ScrollController();
  final _items = <_RoutineFormItem>[];
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

  _RoutineFormItem _createFormItem({
    String? id,
    String title = '',
    int? series,
    int? repetitions,
  }) {
    return _RoutineFormItem(
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

  ChecklistItem? _itemFromForm(_RoutineFormItem item) {
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

  bool _isItemComplete(_RoutineFormItem item) {
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
    final incompleteIndex = _firstIncompleteItemIndex();
    if (incompleteIndex != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Completa nombre, series y repeticiones antes de agregar otro.',
          ),
        ),
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

  RoutineCard? _buildPreviewCard() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final items = _validPreviewItems();

    if (title.isEmpty && description.isEmpty && items.isEmpty) {
      return null;
    }

    return RoutineCard(
      id: widget.routine?.id ?? 'preview',
      title: title.isEmpty ? 'Sin título' : title,
      description: description,
      items: items,
    );
  }

  String? _validateSeries(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Obligatorio';
    }
    if (_parsePositiveInt(value) == null) {
      return 'Número válido';
    }
    return null;
  }

  Future<void> _save() async {
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
        const SnackBar(
          content: Text('Agrega al menos un ejercicio completo.'),
        ),
      );
      return;
    }

    if (validItems.length != _items.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa todos los ejercicios antes de guardar.'),
        ),
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
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => DayRoutineScreen(dateKey: autoAssignDateKey),
        ),
      );
      return;
    }

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final previewCard = _buildPreviewCard();

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar rutina' : 'Nueva rutina'),
        actions: [
          IconButton(
            onPressed: _save,
            icon: const Icon(Icons.check),
            tooltip: 'Guardar',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        tooltip: 'Agregar ejercicio',
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
              decoration: const InputDecoration(
                labelText: 'Título',
                hintText: 'Ej. MIÉRCOLES',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.characters,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El título es obligatorio';
                }
                return null;
              },
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                hintText: 'Ej. TREN SUPERIOR 1',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),
            Text(
              'Vista previa',
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
                  'Aquí verás tu rutina cuando escribas el título o completes ejercicios.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              )
            else
              RoutineCardPreview(routine: previewCard),
            const SizedBox(height: 24),
            Text(
              'Ejercicios',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            if (_items.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Pulsa el botón + para agregar tu primer ejercicio.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            ...List.generate(_items.length, (index) {
              final item = _items[index];
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
                          labelText: 'Ejercicio ${index + 1}',
                          hintText: 'Ej. Press de Banca Plana',
                          border: const OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Obligatorio';
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
                              decoration: const InputDecoration(
                                labelText: 'Series',
                                hintText: '4',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: _validateSeries,
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: item.repetitionsController,
                              decoration: const InputDecoration(
                                labelText: 'Repeticiones',
                                hintText: '10',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: _validateSeries,
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                        ],
                      ),
                      if (_isItemComplete(item)) ...[
                        const SizedBox(height: 8),
                        Text(
                          _itemFromForm(item)!.formattedSubtitle,
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
                          label: const Text('Eliminar'),
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
              label: const Text('Guardar rutina'),
            ),
          ],
        ),
      ),
    );
  }
}
