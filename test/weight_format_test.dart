import 'package:flutter_test/flutter_test.dart';

import 'package:life_fit/core/services/weight_unit_service.dart';
import 'package:life_fit/core/utils/gym_weight_rounding.dart';
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

  test('formatExerciseWeight respeta unidad y redondea al paso de gym', () {
    expect(formatExerciseWeight(60, WeightUnit.kg, l10n), '60 kg');
    expect(formatExerciseWeight(60, WeightUnit.lb, l10n), '130 lb');
  });

  test('peso ingresado en la unidad mostrada no se redondea', () {
    expect(displayExerciseWeightFromKg(22, WeightUnit.kg), 22);
    expect(displayExerciseWeightFromKg(22.5, WeightUnit.kg), 22.5);
    expect(displayExerciseWeightFromKg(lbToKg(44), WeightUnit.lb), 44);
  });

  test('kg vistos en lb se redondean de 5 en 5', () {
    expect(displayExerciseWeightFromKg(20, WeightUnit.lb), 45);
    expect(exerciseWeightInputFromKg(20, WeightUnit.lb), '45');
  });

  test('lb vistas en kg se redondean de 2.5 en 2.5', () {
    expect(displayExerciseWeightFromKg(lbToKg(45), WeightUnit.kg), 20);
    expect(displayExerciseWeightFromKg(lbToKg(25), WeightUnit.kg), 12.5);
  });

  test('ida y vuelta de 45 lb conserva el valor exacto', () {
    final storedKg = parseWeightInput('45', WeightUnit.lb)!;
    expect(displayExerciseWeightFromKg(storedKg, WeightUnit.kg), 20);
    expect(displayExerciseWeightFromKg(storedKg, WeightUnit.lb), 45);
  });

  test('peso corporal no usa el redondeo de gym', () {
    expect(weightInputFromKg(20, WeightUnit.lb), '44.1');
  });
}
