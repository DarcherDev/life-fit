import 'package:life_fit/modules/rutina/routine_day_module.dart';

export 'models/warm_up.dart';
export 'models/warm_up_placement.dart';
export 'widgets/warm_up_form_section.dart';
export 'widgets/warm_up_preview_tile.dart';

/// Módulo de calentamiento — parte de la rutina del día.
abstract class CalentamientoModule {
  CalentamientoModule._();

  static const id = RoutineDayModule.calentamiento;
}
