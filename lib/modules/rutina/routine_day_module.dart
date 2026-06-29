/// Los tres módulos que componen una rutina del día de gym.
///
/// [ejercicios] y [calentamiento] están integrados en la tarjeta y el día de gym.
/// [estiramiento] tendrá carpeta propia cuando se implemente.
enum RoutineDayModule {
  calentamiento,
  ejercicios,
  estiramiento,
}

/// Orden sugerido de ejecución en el día de gym.
const routineDayModuleOrder = <RoutineDayModule>[
  RoutineDayModule.calentamiento,
  RoutineDayModule.ejercicios,
  RoutineDayModule.estiramiento,
];
