import 'app_localizations.dart';

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Life Fit';

  @override
  String get homeTagline => 'gestiona tu vida';

  @override
  String get homeGymDayTitle => 'Dia de gym';

  @override
  String get homeGymDaySubtitle => 'Rutina asignada para hoy';

  @override
  String get homeExercisesTitle => 'Ejercicios';

  @override
  String get homeExercisesSubtitle => 'Crea y personaliza tus tarjetas de ejercicios';

  @override
  String get homePlannerTitle => 'Planificador';

  @override
  String get homePlannerSubtitle => 'Asigna rutinas a tu calendario';

  @override
  String get languageMenu => 'Idioma';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageEnglish => 'English';

  @override
  String get cancel => 'Cancelar';

  @override
  String get remove => 'Quitar';

  @override
  String get delete => 'Eliminar';

  @override
  String get save => 'Guardar';

  @override
  String get back => 'Volver';

  @override
  String get required => 'Obligatorio';

  @override
  String get validNumber => 'Número válido';

  @override
  String get noTitle => 'Sin título';

  @override
  String get plannerTitle => 'Planificador';

  @override
  String get createExercisesFirst => 'Primero crea ejercicios en la sección Ejercicios.';

  @override
  String get routineRemovedFromDay => 'Rutina quitada del día';

  @override
  String get routineAssignedSuccess => 'Rutina asignada correctamente';

  @override
  String get noRoutineAssigned => 'Sin rutina asignada';

  @override
  String get tapToAssignRoutine => 'Toca para asignar una rutina';

  @override
  String plannerItemsTapToChange(int count) {
    return '$count items · Toca para cambiar';
  }

  @override
  String plannerDescriptionTapToChange(String description) {
    return '$description · Toca para cambiar';
  }

  @override
  String assignRoutineForDate(String date) {
    return 'Asignar rutina para $date';
  }

  @override
  String changeRoutineForDate(String date) {
    return 'Cambiar rutina del $date';
  }

  @override
  String get changeRoutine => 'Cambiar rutina';

  @override
  String get searchRoutineHint => 'Buscar rutina...';

  @override
  String get removeRoutineFromDay => 'Quitar rutina del día';

  @override
  String get noMatchingRoutines => 'No hay rutinas que coincidan';

  @override
  String get exercisesModuleTitle => 'Ejercicios';

  @override
  String get deleteExerciseCardTitle => 'Eliminar tarjeta';

  @override
  String deleteExerciseCardMessage(String title) {
    return '¿Eliminar $title? También se quitará del planificador.';
  }

  @override
  String get noExerciseCardsYet => 'Aún no tienes tarjetas de ejercicios';

  @override
  String get noExerciseCardsHint => 'Crea tarjetas con ejercicios para usarlas en el planificador.';

  @override
  String get newExerciseCard => 'Nueva tarjeta';

  @override
  String get editExerciseCard => 'Editar tarjeta';

  @override
  String get addExercise => 'Agregar ejercicio';

  @override
  String get fieldTitle => 'Título';

  @override
  String get fieldTitleHint => 'Ej. MIÉRCOLES';

  @override
  String get titleRequired => 'El título es obligatorio';

  @override
  String get fieldDescription => 'Descripción';

  @override
  String get fieldDescriptionHint => 'Ej. TREN SUPERIOR 1';

  @override
  String get previewTitle => 'Vista previa';

  @override
  String get previewEmptyHint => 'Aquí verás la tarjeta cuando escribas el título o completes ejercicios.';

  @override
  String get exercisesTitle => 'Ejercicios';

  @override
  String get addFirstExerciseHint => 'Pulsa el botón + para agregar tu primer ejercicio.';

  @override
  String exerciseLabel(int number) {
    return 'Ejercicio $number';
  }

  @override
  String get exerciseHint => 'Ej. Press de Banca Plana';

  @override
  String get fieldSeries => 'Series';

  @override
  String get fieldSeriesHint => '4';

  @override
  String get fieldRepetitions => 'Repeticiones';

  @override
  String get fieldRepetitionsHint => '10';

  @override
  String get saveExerciseCard => 'Guardar tarjeta';

  @override
  String get completeBeforeAddAnother => 'Completa nombre, series y repeticiones antes de agregar otro.';

  @override
  String get addAtLeastOneExercise => 'Agrega al menos un ejercicio completo.';

  @override
  String get completeAllBeforeSave => 'Completa todos los ejercicios antes de guardar.';

  @override
  String seriesRepsFormat(int series, int repetitions) {
    return '$series series x $repetitions repeticiones';
  }

  @override
  String get removeRoutineTitle => 'Quitar rutina';

  @override
  String get removeRoutineMessage => '¿Quitar la rutina de este día? El progreso del día se conservará.';

  @override
  String get noRoutineForDay => 'No hay rutina asignada para este día';

  @override
  String get todayRoutine => 'Rutina de hoy';

  @override
  String get finishRoutine => 'Terminar rutina';

  @override
  String get routineCompleted => '¡Rutina completada! 🎉';

  @override
  String get warmUpTitle => 'Calentamiento';

  @override
  String get warmUpEnableSubtitle => 'Caminadora, bici estática, elíptica, etc.';

  @override
  String get warmUpDescriptionLabel => 'Actividad';

  @override
  String get warmUpDescriptionHint => 'Ej. Caminadora inclinada';

  @override
  String get warmUpMinutesLabel => 'Tiempo (minutos)';

  @override
  String get warmUpMinutesHint => '10';

  @override
  String get warmUpPlacementTitle => '¿Cuándo hacerlo?';

  @override
  String get warmUpPlacementStart => 'Al inicio';

  @override
  String get warmUpPlacementEnd => 'Al final';

  @override
  String warmUpMinutesFormat(int minutes) {
    return '$minutes min';
  }

  @override
  String get completeWarmUpFields => 'Completa la actividad y los minutos del calentamiento.';
}
