import 'package:flutter_test/flutter_test.dart';

import 'package:life_fit/core/services/weight_unit_service.dart';
import 'package:life_fit/core/utils/weight_format.dart';
import 'package:life_fit/l10n/app_localizations_es.dart';

void main() {
  final l10n = AppLocalizationsEs();

  test('convierte kg a lb y viceversa', () {
    expect(kgToLb(1), closeTo(2.2046, 0.001));
    expect(lbToKg(2.2046), closeTo(1, 0.001));
  });

  test('parseWeightInput guarda siempre en kg', () {
    expect(parseWeightInput('60', WeightUnit.kg), 60);
    expect(parseWeightInput('132', WeightUnit.lb), closeTo(59.87, 0.01));
    expect(parseWeightInput('', WeightUnit.kg), isNull);
    expect(parseWeightInput('0', WeightUnit.kg), isNull);
  });

  test('formatWeight respeta unidad de visualización', () {
    expect(
      formatWeight(60, WeightUnit.kg, l10n),
      '60 kg',
    );
    expect(
      formatWeight(60, WeightUnit.lb, l10n),
      '${formatWeightValue(kgToLb(60))} lb',
    );
  });
}
