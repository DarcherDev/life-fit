import 'package:life_fit/core/services/weight_unit_service.dart';
import 'package:life_fit/l10n/app_localizations.dart';

const double _kgPerLb = 0.45359237;

double kgToLb(double kg) => kg / _kgPerLb;

double lbToKg(double lb) => lb * _kgPerLb;

double displayWeightFromKg(double weightKg, WeightUnit unit) {
  switch (unit) {
    case WeightUnit.kg:
      return weightKg;
    case WeightUnit.lb:
      return kgToLb(weightKg);
  }
}

double? displayWeightFromKgNullable(double? weightKg, WeightUnit unit) {
  if (weightKg == null) {
    return null;
  }
  return displayWeightFromKg(weightKg, unit);
}

String formatWeightValue(double value) {
  if (value == value.roundToDouble()) {
    return value.toInt().toString();
  }
  return value.toStringAsFixed(1);
}

String weightUnitLabel(WeightUnit unit, AppLocalizations l10n) {
  switch (unit) {
    case WeightUnit.kg:
      return l10n.weightUnitKgShort;
    case WeightUnit.lb:
      return l10n.weightUnitLbShort;
  }
}

String formatWeight(
  double? weightKg,
  WeightUnit unit,
  AppLocalizations l10n,
) {
  if (weightKg == null) {
    return '';
  }
  final display = displayWeightFromKg(weightKg, unit);
  return l10n.weightFormat(
    formatWeightValue(display),
    weightUnitLabel(unit, l10n),
  );
}

double? parseWeightInput(String text, WeightUnit unit) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) {
    return null;
  }
  final parsed = double.tryParse(trimmed.replaceAll(',', '.'));
  if (parsed == null || parsed <= 0) {
    return null;
  }
  switch (unit) {
    case WeightUnit.kg:
      return parsed;
    case WeightUnit.lb:
      return lbToKg(parsed);
  }
}

String? weightInputFromKg(double? weightKg, WeightUnit unit) {
  if (weightKg == null) {
    return null;
  }
  return formatWeightValue(displayWeightFromKg(weightKg, unit));
}
