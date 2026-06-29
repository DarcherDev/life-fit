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
  }) async {
    final l10n = AppLocalizations.of(context);
    final unit = WeightUnitService.instance.unit;
    final controller = TextEditingController(
      text: weightInputFromKg(currentWeightKg, unit) ?? '',
    );

    final result = await showDialog<ExerciseWeightDialogResult>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.editExerciseWeight),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                exerciseTitle,
                style: Theme.of(dialogContext).textTheme.titleSmall,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
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
                  suffixText: weightUnitLabel(unit, l10n),
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            if (currentWeightKg != null)
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(
                  const ExerciseWeightDialogResult._(
                    cancelled: false,
                    weightKg: null,
                  ),
                ),
                child: Text(l10n.remove),
              ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(
                ExerciseWeightDialogResult.cancelledResult,
              ),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                final trimmed = controller.text.trim();
                if (trimmed.isEmpty) {
                  Navigator.of(dialogContext).pop(
                    const ExerciseWeightDialogResult._(
                      cancelled: false,
                      weightKg: null,
                    ),
                  );
                  return;
                }
                final parsed = parseWeightInput(trimmed, unit);
                if (parsed == null) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text(l10n.invalidWeight)),
                  );
                  return;
                }
                Navigator.of(dialogContext).pop(
                  ExerciseWeightDialogResult._(
                    cancelled: false,
                    weightKg: parsed,
                  ),
                );
              },
              child: Text(l10n.save),
            ),
          ],
        );
      },
    );

    controller.dispose();
    return result ?? ExerciseWeightDialogResult.cancelledResult;
  }
}
