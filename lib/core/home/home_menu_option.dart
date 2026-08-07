/// Opciones del menú principal (Home).
enum HomeMenuOption {
  gymDay,
  routines,
  planner,
  exercises,
  stretching,
  warmUp;

  String get storageId => name;

  static HomeMenuOption? fromStorage(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    for (final option in values) {
      if (option.name == value) {
        return option;
      }
    }
    return null;
  }

  static const List<HomeMenuOption> defaultOrder = [
    HomeMenuOption.gymDay,
    HomeMenuOption.routines,
    HomeMenuOption.planner,
    HomeMenuOption.exercises,
    HomeMenuOption.stretching,
    HomeMenuOption.warmUp,
  ];
}
