import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:uuid/uuid.dart';

import 'package:life_fit/core/services/weight_unit_service.dart';
import 'package:life_fit/core/utils/weight_format.dart';
import 'package:life_fit/core/widgets/app_scaffold.dart';
import 'package:life_fit/l10n/app_localizations.dart';
import 'package:life_fit/core/services/local_storage_service.dart';
import 'package:life_fit/modules/ejercicios/models/exercise_template.dart';

class ExerciseTemplateFormScreen extends StatefulWidget {
  const ExerciseTemplateFormScreen({super.key, this.template});

  final ExerciseTemplate? template;

  @override
  State<ExerciseTemplateFormScreen> createState() =>
      _ExerciseTemplateFormScreenState();
}

class _ExerciseTemplateFormScreenState
    extends State<ExerciseTemplateFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storage = LocalStorageService.instance;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _seriesController = TextEditingController();
  final _repetitionsController = TextEditingController();
  final _weightController = TextEditingController();
  final _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    final template = widget.template;
    if (template != null) {
      _titleController.text = template.title;
      _descriptionController.text = template.description;
      _seriesController.text = template.series.toString();
      _repetitionsController.text = template.repetitions.toString();
      final weightText = weightInputFromKg(
        template.weightKg,
        WeightUnitService.instance.unit,
      );
      if (weightText != null) {
        _weightController.text = weightText;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _seriesController.dispose();
    _repetitionsController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  int? _parsePositiveInt(String value) {
    final parsed = int.tryParse(value.trim());
    if (parsed == null || parsed <= 0) {
      return null;
    }
    return parsed;
  }

  String? _validateNumber(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.required;
    }
    if (_parsePositiveInt(value) == null) {
      return l10n.validNumber;
    }
    return null;
  }

  String? _validateOptionalWeight(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    if (parseWeightInput(value, WeightUnitService.instance.unit) == null) {
      return l10n.invalidWeight;
    }
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final weightKg = parseWeightInput(
      _weightController.text,
      WeightUnitService.instance.unit,
    );

    final template = ExerciseTemplate(
      id: widget.template?.id ?? _uuid.v4(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      series: _parsePositiveInt(_seriesController.text)!,
      repetitions: _parsePositiveInt(_repetitionsController.text)!,
      weightKg: weightKg,
    );

    await _storage.upsertExerciseTemplate(template);
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isEditing = widget.template != null;
    final unit = WeightUnitService.instance.unit;

    return AppScaffold(
      title: isEditing ? l10n.editExerciseTemplate : l10n.newExerciseTemplate,
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
                labelText: l10n.exerciseTemplateNameLabel,
                hintText: l10n.exerciseHint,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.required;
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
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _seriesController,
                    decoration: InputDecoration(
                      labelText: l10n.fieldSeries,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) => _validateNumber(value, l10n),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _repetitionsController,
                    decoration: InputDecoration(
                      labelText: l10n.fieldRepetitions,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) => _validateNumber(value, l10n),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _weightController,
              decoration: InputDecoration(
                labelText: l10n.exerciseWeightLabel,
                hintText: l10n.exerciseWeightHint,
                suffixText: weightUnitLabel(unit, l10n),
                border: const OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
              ],
              validator: (value) => _validateOptionalWeight(value, l10n),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }
}
