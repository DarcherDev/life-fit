import 'package:life_fit/core/services/weight_unit_service.dart';
import 'package:life_fit/core/utils/weight_format.dart';

/// Incremento mínimo de peso realizable en el gimnasio para cada unidad.
double gymWeightStep(WeightUnit unit) {
  switch (unit) {
    case WeightUnit.kg:
      return 2.5;
    case WeightUnit.lb:
      return 5;
  }
}

double roundToGymStep(double value, WeightUnit unit) {
  final step = gymWeightStep(unit);
  return (value / step).round() * step;
}

/// Peso de ejercicio en la unidad mostrada.
///
/// Solo se guarda `weightKg`, sin la unidad en que se ingresó: un valor que ya
/// es múltiplo de 0.5 en [unit] se asume ingresado en esa unidad y se deja
/// igual; el resto viene de la otra unidad y se redondea a [gymWeightStep].
double displayExerciseWeightFromKg(double weightKg, WeightUnit unit) {
  final value = displayWeightFromKg(weightKg, unit);
  final halfSteps = value * 2;
  if ((halfSteps - halfSteps.round()).abs() <= 0.02) {
    return halfSteps.round() / 2;
  }
  return roundToGymStep(value, unit);
}
