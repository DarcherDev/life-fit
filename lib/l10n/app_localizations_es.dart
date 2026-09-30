import 'app_localizations.dart';

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Life Fit';

  @override
  String get homeTagline => 'gestiona tu vida';

  @override
  String get homeTodayProgressSubtitle => 'Progreso de la rutina de hoy';

  @override
  String get homeTodayNoRoutine => 'Sin rutina asignada hoy';

  @override
  String get homeTodayRoutineEmpty => 'La rutina de hoy no tiene ítems';

  @override
  String get homeTodayRoutineComplete => '¡Rutina de hoy completada!';

  @override
  String homeTodayProgressCount(int completed, int total) {
    return '$completed de $total';
  }

  @override
  String get homeGymDayTitle => 'Dia de gym';

  @override
  String get homeGymDaySubtitle => 'Rutina asignada para hoy';

  @override
  String get homeExercisesTitle => 'Ejercicios';

  @override
  String get homeExercisesSubtitle => 'Biblioteca de ejercicios reutilizables';

  @override
  String get homeRoutineTitle => 'Rutina';

  @override
  String get homeRoutineSubtitle => 'Arma rutinas con ejercicios, estiramientos y calentamiento';

  @override
  String get homeStretchingTitle => 'Estiramientos';

  @override
  String get homeStretchingSubtitle => 'Biblioteca de estiramientos reutilizables';

  @override
  String get homeWarmUpTitle => 'Calentamiento';

  @override
  String get homeWarmUpSubtitle => 'Biblioteca de calentamientos reutilizables';

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
  String get themeMenu => 'Tema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get myProcessTitle => 'Mi proceso';

  @override
  String get myProcessDescription => 'Registra tus datos físicos para llevar un control personal de tu evolución.';

  @override
  String get exportRoutinesTitle => 'Exportar rutinas';

  @override
  String get exportRoutinesDescription => 'Copia este JSON y pégalo en ChatGPT o Gemini para analizar o rediseñar tus rutinas. No incluye el planificador.';

  @override
  String get exportRoutinesEmptyDescription => 'Aún no tienes rutinas. Copia este ejemplo, pídele a ChatGPT o Gemini que lo adapte a tu entrenamiento y pega el resultado en Importar rutinas.';

  @override
  String get exportSampleRoutineTitle => 'Rutina de ejemplo';

  @override
  String get exportSampleRoutineDescription => 'Adapta esta rutina con IA y vuelve a importarla';

  @override
  String get exportRoutinesCopy => 'Copiar JSON';

  @override
  String get exportRoutinesCopied => 'JSON copiado al portapapeles';

  @override
  String get importRoutinesTitle => 'Importar rutinas';

  @override
  String get importRoutinesDescription => 'Pega un JSON exportado o generado por IA. Se reemplazarán todas las rutinas. Las bibliotecas se actualizarán sin borrar ítems no usados.';

  @override
  String get importRoutinesHint => 'Pega aquí el JSON completo';

  @override
  String get importRoutinesAction => 'Importar';

  @override
  String get importRoutinesConfirmTitle => '¿Reemplazar rutinas?';

  @override
  String get importRoutinesConfirmMessage => 'Se eliminarán las rutinas actuales y se cargarán las del JSON. Los ejercicios, estiramientos y calentamientos de la biblioteca se actualizarán o crearán; los no usados se conservan. El planificador limpia solo asignaciones rotas.';

  @override
  String get importRoutinesConfirmAction => 'Importar';

  @override
  String get importRoutinesSuccess => 'Rutinas importadas correctamente';

  @override
  String get importRoutinesErrorEmpty => 'Pega un JSON para importar';

  @override
  String get importRoutinesErrorInvalidJson => 'El texto no es un JSON válido';

  @override
  String get importRoutinesErrorSchema => 'Versión de esquema no soportada';

  @override
  String get importRoutinesErrorGeneric => 'No se pudo importar el JSON';

  @override
  String get personalAgeLabel => 'Edad';

  @override
  String get personalAgeHint => 'Años';

  @override
  String get personalHeightLabel => 'Altura';

  @override
  String get personalHeightHint => 'Centímetros';

  @override
  String get personalBodyWeightLabel => 'Peso corporal';

  @override
  String get invalidAge => 'Edad válida entre 1 y 120';

  @override
  String get invalidHeight => 'Altura válida mayor que cero';

  @override
  String get profileSaved => 'Datos guardados';

  @override
  String get weightUnitTitle => 'Sistema de peso';

  @override
  String get weightUnitKg => 'Kilogramos';

  @override
  String get weightUnitLb => 'Libras';

  @override
  String get weightUnitKgShort => 'kg';

  @override
  String get weightUnitLbShort => 'lb';

  @override
  String get exerciseWeightLabel => 'Peso';

  @override
  String get exerciseWeightHint => 'Opcional';

  @override
  String get editExerciseWeight => 'Editar peso';

  @override
  String get editExercise => 'Editar ejercicio';

  @override
  String weightFormat(String weight, String unit) {
    return '$weight $unit';
  }

  @override
  String get invalidWeight => 'Peso válido mayor que cero';

  @override
  String get localePromptTitle => 'Elige tu idioma';

  @override
  String get localePromptMessage => 'El idioma de tu dispositivo no está disponible en la app. ¿En qué idioma quieres usar Life Fit?';

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
  String get createRoutinesFirst => 'Primero crea rutinas en la sección Rutina.';

  @override
  String get routineRemovedFromDay => 'Rutina quitada del día';

  @override
  String get routineAssignedSuccess => 'Rutina asignada correctamente';

  @override
  String get pickRoutineForDay => 'Elige una rutina para este día';

  @override
  String plannerItemsCount(int count) {
    return '$count items';
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
  String get changeExercise => 'Cambiar ejercicio';

  @override
  String get changeStretching => 'Cambiar estiramiento';

  @override
  String get changeWarmUp => 'Cambiar calentamiento';

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

  @override
  String get stretchingsTitle => 'Estiramientos';

  @override
  String get stretchingsSubtitle => 'Al inicio de la rutina, después del calentamiento si lo hay.';

  @override
  String stretchingLabel(int index) {
    return 'Estiramiento $index';
  }

  @override
  String get stretchingDescriptionHint => 'Ej. Rotación de hombros';

  @override
  String get stretchingRepetitionsLabel => 'Repeticiones';

  @override
  String get stretchingRepetitionsHint => '10';

  @override
  String stretchingRepetitionsFormat(int repetitions) {
    return '$repetitions repeticiones';
  }

  @override
  String get addStretching => 'Agregar estiramiento';

  @override
  String get addFirstStretchingHint => 'Agrega uno o más estiramientos para esta rutina.';

  @override
  String get completeBeforeAddAnotherStretching => 'Completa descripción y repeticiones antes de agregar otro estiramiento.';

  @override
  String get completeAllStretchingsBeforeSave => 'Completa todos los estiramientos antes de guardar.';

  @override
  String get routinesModuleTitle => 'Rutinas';

  @override
  String get noRoutinesYet => 'Aún no tienes rutinas. Arma una desde las bibliotecas.';

  @override
  String get newRoutine => 'Nueva rutina';

  @override
  String get editRoutine => 'Editar rutina';

  @override
  String get saveRoutine => 'Guardar rutina';

  @override
  String get deleteRoutineTitle => 'Eliminar rutina';

  @override
  String deleteRoutineMessage(String title) {
    return '¿Eliminar $title? También se quitará del planificador.';
  }

  @override
  String get exerciseLibraryTitle => 'Biblioteca de ejercicios';

  @override
  String get exerciseLibraryEmpty => 'Crea ejercicios reutilizables para armar rutinas.';

  @override
  String get newExerciseTemplate => 'Nuevo ejercicio';

  @override
  String get editExerciseTemplate => 'Editar ejercicio';

  @override
  String get exerciseTemplateNameLabel => 'Nombre del ejercicio';

  @override
  String get deleteExerciseTemplateTitle => 'Eliminar ejercicio';

  @override
  String deleteExerciseTemplateMessage(String title) {
    return '¿Eliminar $title?';
  }

  @override
  String get stretchingLibraryTitle => 'Biblioteca de estiramientos';

  @override
  String get stretchingLibraryEmpty => 'Crea estiramientos reutilizables para armar rutinas.';

  @override
  String get newStretchingTemplate => 'Nuevo estiramiento';

  @override
  String get editStretchingTemplate => 'Editar estiramiento';

  @override
  String get deleteStretchingTemplateTitle => 'Eliminar estiramiento';

  @override
  String deleteStretchingTemplateMessage(String description) {
    return '¿Eliminar $description?';
  }

  @override
  String get warmUpLibraryTitle => 'Biblioteca de calentamiento';

  @override
  String get warmUpLibraryEmpty => 'Crea calentamientos reutilizables para armar rutinas.';

  @override
  String get newWarmUpTemplate => 'Nuevo calentamiento';

  @override
  String get editWarmUpTemplate => 'Editar calentamiento';

  @override
  String get deleteWarmUpTemplateTitle => 'Eliminar calentamiento';

  @override
  String deleteWarmUpTemplateMessage(String description) {
    return '¿Eliminar $description?';
  }

  @override
  String get templateInUseMessage => 'No se puede eliminar porque está en uso en una rutina.';

  @override
  String get pickWarmUpTitle => 'Elegir calentamiento';

  @override
  String get pickExercisesTitle => 'Elegir ejercicios';

  @override
  String get pickStretchingsTitle => 'Elegir estiramientos';

  @override
  String get noWarmUpSelected => 'Sin calentamiento asignado';

  @override
  String get addFromLibrary => 'Agregar desde biblioteca';

  @override
  String get routineSlotsEmpty => 'Ninguno asignado aún';

  @override
  String get addAtLeastOneExerciseToRoutine => 'Agrega al menos un ejercicio a la rutina.';

  @override
  String get searchLibraryHint => 'Buscar...';

  @override
  String get noMatchingLibraryItems => 'No hay coincidencias';

  @override
  String get addSelected => 'Agregar seleccionados';

  @override
  String get missingTemplateLabel => 'No disponible';

  @override
  String get missingTemplateWarning => 'Algunos ítems de la biblioteca ya no existen.';

  @override
  String get aboutTitle => 'Acerca de';

  @override
  String aboutVersion(String version) {
    return 'Versión $version';
  }

  @override
  String get licenseLink => 'LICENSE';

  @override
  String get licenseScreenTitle => 'Licencia';
}
