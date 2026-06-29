import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:life_fit/core/services/weight_unit_service.dart';
import 'package:life_fit/core/utils/weight_format.dart';
import 'package:life_fit/l10n/app_localizations.dart';

class ExerciseWeightDialogResult {
  const ExerciseWeightDialogResult._({required this.cancelled, this.weightKg});

  final bool cancelled;
  final double? weightKg;

  static const cancelledResult = ExerciseWeightDialogResult._(cancelled: true);
}

class ExerciseWeightDialog {
  static Future<ExerciseWeightDialogResult> show(
    BuildContext context, {
    required String exerciseTitle,
    double? currentWeightKg,
  }) {
    return showDialog<ExerciseWeightDialogResult>(
      context: context,
      builder: (dialogContext) => _ExerciseWeightDialog(
        exerciseTitle: exerciseTitle,
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
    required this.currentWeightKg,
  });

  final String exerciseTitle;
  final double? currentWeightKg;

  @override
  State<_ExerciseWeightDialog> createState() => _ExerciseWeightDialogState();
}

class _ExerciseWeightDialogState extends State<_ExerciseWeightDialog> {
  late final TextEditingController _controller;
  late final WeightUnit _unit;

  @override
  void initState() {
    super.initState();
    _unit = WeightUnitService.instance.unit;
    _controller = TextEditingController(
      text: weightInputFromKg(widget.currentWeightKg, _unit) ?? '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final l10n = AppLocalizations.of(context);
    final trimmed = _controller.text.trim();
    if (trimmed.isEmpty) {
      Navigator.of(context).pop(
        const ExerciseWeightDialogResult._(
          cancelled: false,
          weightKg: null,
        ),
      );
      return;
    }
    final parsed = parseWeightInput(trimmed, _unit);
    if (parsed == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.invalidWeight)),
      );
      return;
    }
    Navigator.of(context).pop(
      ExerciseWeightDialogResult._(
        cancelled: false,
        weightKg: parsed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(l10n.editExerciseWeight),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.exerciseTitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
            ],
            decoration: InputDecoration(
              labelText: l10n.exerciseWeightLabel,
              hintText: l10n.exerciseWeightHint,
              suffixText: weightUnitLabel(_unit, l10n),
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (_) => _save(),
          ),
        ],
      ),
      actions: [
        if (widget.currentWeightKg != null)
          TextButton(
            onPressed: () => Navigator.of(context).pop(
              const ExerciseWeightDialogResult._(
                cancelled: false,
                weightKg: null,
              ),
            ),
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
