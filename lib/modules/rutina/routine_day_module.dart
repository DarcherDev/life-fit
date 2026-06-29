/// Los tres módulos que componen una rutina del día de gym.
///
/// Todos están integrados en la tarjeta y el día de gym.
enum RoutineDayModule {
  calentamiento,
  ejercicios,
  estiramiento,
}

/// Orden de ejecución al inicio: calentamiento (si al inicio) → estiramiento → ejercicios.
const routineDayModuleOrder = <RoutineDayModule>[
  RoutineDayModule.calentamiento,
  RoutineDayModule.estiramiento,
  RoutineDayModule.ejercicios,
];
