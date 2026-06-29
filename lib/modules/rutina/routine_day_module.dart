/// Los tres módulos que componen una rutina del día de gym.
///
/// Hoy solo [ejercicios] está implementado. [calentamiento] y [estiramiento]
/// tienen carpeta propia y se integrarán en [DayRoutineScreen] más adelante.
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
