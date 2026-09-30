import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:life_fit/core/services/weight_unit_service.dart';
import 'package:life_fit/core/utils/weight_format.dart';
import 'package:life_fit/l10n/app_localizations.dart';

class ExerciseWeightDialogResult {
  const ExerciseWeightDialogResult._({
    required this.cancelled,
    this.series,
    this.repetitions,
    this.weightKg,
    this.clearWeightKg = false,
  });

  final bool cancelled;
  final int? series;
  final int? repetitions;
  final double? weightKg;
  final bool clearWeightKg;

  static const cancelledResult = ExerciseWeightDialogResult._(cancelled: true);
}

class ExerciseWeightDialog {
  static Future<ExerciseWeightDialogResult> show(
    BuildContext context, {
    required String exerciseTitle,
    required int series,
    required int repetitions,
    double? currentWeightKg,
  }) {
    return showDialog<ExerciseWeightDialogResult>(
      context: context,
      builder: (dialogContext) => _ExerciseWeightDialog(
        exerciseTitle: exerciseTitle,
        initialSeries: series,
        initialRepetitions: repetitions,
        currentWeightKg: currentWeightKg,
      ),
    ).then(
      (result) => result ?? ExerciseWeightDialogResult.cancelledResult,
    );
  }
}

class _ExerciseWeightDialog extends StatefulWidget {
  const _ExerciseWeightDialog({
    required this.exerciseTitle,
    required this.initialSeries,
    required this.initialRepetitions,
    required this.currentWeightKg,
  });

  final String exerciseTitle;
  final int initialSeries;
  final int initialRepetitions;
  final double? currentWeightKg;

  @override
  State<_ExerciseWeightDialog> createState() => _ExerciseWeightDialogState();
}

class _ExerciseWeightDialogState extends State<_ExerciseWeightDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _seriesController;
  late final TextEditingController _repetitionsController;
  late final TextEditingController _weightController;
  late final WeightUnit _unit;
  late final String _initialWeightText;

  @override
  void initState() {
    super.initState();
    _unit = WeightUnitService.instance.unit;
    _seriesController = TextEditingController(
      text: widget.initialSeries.toString(),
    );
    _repetitionsController = TextEditingController(
      text: widget.initialRepetitions.toString(),
    );
    _initialWeightText =
        exerciseWeightInputFromKg(widget.currentWeightKg, _unit) ?? '';
    _weightController = TextEditingController(text: _initialWeightText);
  }

  @override
  void dispose() {
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
    if (parseWeightInput(value, _unit) == null) {
      return l10n.invalidWeight;
    }
    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final weightText = _weightController.text.trim();
    final double? weightKg;
    if (weightText.isEmpty) {
      weightKg = null;
    } else if (weightText == _initialWeightText) {
      weightKg = widget.currentWeightKg;
    } else {
      weightKg = parseWeightInput(weightText, _unit);
    }

    Navigator.of(context).pop(
      ExerciseWeightDialogResult._(
        cancelled: false,
        series: _parsePositiveInt(_seriesController.text),
        repetitions: _parsePositiveInt(_repetitionsController.text),
        weightKg: weightKg,
        clearWeightKg: weightText.isEmpty && widget.currentWeightKg != null,
      ),
    );
  }

  void _clearWeight() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).pop(
      ExerciseWeightDialogResult._(
        cancelled: false,
        series: _parsePositiveInt(_seriesController.text),
        repetitions: _parsePositiveInt(_repetitionsController.text),
        weightKg: null,
        clearWeightKg: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(l10n.editExercise),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.exerciseTitle,
              style: Theme.of(context).textTheme.titleSmall,
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
                      isDense: true,
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
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) => _validateNumber(value, l10n),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _weightController,
              decoration: InputDecoration(
                labelText: l10n.exerciseWeightLabel,
                hintText: l10n.exerciseWeightHint,
                suffixText: weightUnitLabel(_unit, l10n),
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
              ],
              validator: (value) => _validateOptionalWeight(value, l10n),
            ),
          ],
        ),
      ),
      actions: [
        if (widget.currentWeightKg != null)
          TextButton(
            onPressed: _clearWeight,
            child: Text(l10n.remove),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(
            ExerciseWeightDialogResult.cancelledResult,
          ),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _save,
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
