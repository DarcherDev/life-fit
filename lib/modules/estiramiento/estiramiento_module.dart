import 'package:life_fit/modules/rutina/routine_day_module.dart';

export 'models/stretching.dart';
export 'models/stretching_template.dart';
export 'screens/stretching_library_screen.dart';
export 'screens/stretching_template_form_screen.dart';
export 'widgets/stretching_preview_tile.dart';

/// Módulo de estiramiento — biblioteca reutilizable.
abstract class EstiramientoModule {
  EstiramientoModule._();

  static const id = RoutineDayModule.estiramiento;
}
