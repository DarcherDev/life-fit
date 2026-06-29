import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Life Fit';

  @override
  String get homeTagline => 'manage your life';

  @override
  String get homeGymDayTitle => 'Gym day';

  @override
  String get homeGymDaySubtitle => 'Today\'s assigned routine';

  @override
  String get homeExercisesTitle => 'Exercises';

  @override
  String get homeExercisesSubtitle => 'Reusable exercise library';

  @override
  String get homeRoutineTitle => 'Routine';

  @override
  String get homeRoutineSubtitle => 'Build routines from your libraries';

  @override
  String get homeStretchingTitle => 'Stretching';

  @override
  String get homeStretchingSubtitle => 'Reusable stretching library';

  @override
  String get homeWarmUpTitle => 'Warm-up';

  @override
  String get homeWarmUpSubtitle => 'Reusable warm-up library';

  @override
  String get homePlannerTitle => 'Planner';

  @override
  String get homePlannerSubtitle => 'Assign routines to your calendar';

  @override
  String get languageMenu => 'Language';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageEnglish => 'English';

  @override
  String get themeMenu => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get weightUnitTitle => 'Weight system';

  @override
  String get weightUnitKg => 'Kilograms';

  @override
  String get weightUnitLb => 'Pounds';

  @override
  String get weightUnitKgShort => 'kg';

  @override
  String get weightUnitLbShort => 'lb';

  @override
  String get exerciseWeightLabel => 'Weight';

  @override
  String get exerciseWeightHint => 'Optional';

  @override
  String get editExerciseWeight => 'Edit weight';

  @override
  String weightFormat(String weight, String unit) {
    return '$weight $unit';
  }

  @override
  String get invalidWeight => 'Enter a valid weight greater than zero';

  @override
  String get localePromptTitle => 'Choose your language';

  @override
  String get localePromptMessage => 'Your device language is not available in the app. Which language do you want to use for Life Fit?';

  @override
  String get cancel => 'Cancel';

  @override
  String get remove => 'Remove';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get back => 'Back';

  @override
  String get required => 'Required';

  @override
  String get validNumber => 'Enter a valid number';

  @override
  String get noTitle => 'Untitled';

  @override
  String get plannerTitle => 'Planner';

  @override
  String get createRoutinesFirst => 'Create routines in the Routine section first.';

  @override
  String get routineRemovedFromDay => 'Routine removed from this day';

  @override
  String get routineAssignedSuccess => 'Routine assigned successfully';

  @override
  String get noRoutineAssigned => 'No routine assigned';

  @override
  String get tapToAssignRoutine => 'Tap to assign a routine';

  @override
  String plannerItemsTapToChange(int count) {
    return '$count items · Tap to change';
  }

  @override
  String plannerDescriptionTapToChange(String description) {
    return '$description · Tap to change';
  }

  @override
  String assignRoutineForDate(String date) {
    return 'Assign routine for $date';
  }

  @override
  String changeRoutineForDate(String date) {
    return 'Change routine for $date';
  }

  @override
  String get changeRoutine => 'Change routine';

  @override
  String get searchRoutineHint => 'Search routine...';

  @override
  String get removeRoutineFromDay => 'Remove routine from this day';

  @override
  String get noMatchingRoutines => 'No matching routines';

  @override
  String get exercisesModuleTitle => 'Exercises';

  @override
  String get deleteExerciseCardTitle => 'Delete card';

  @override
  String deleteExerciseCardMessage(String title) {
    return 'Delete $title? It will also be removed from the planner.';
  }

  @override
  String get noExerciseCardsYet => 'You don\'t have exercise cards yet';

  @override
  String get noExerciseCardsHint => 'Create cards with exercises to use them in the planner.';

  @override
  String get newExerciseCard => 'New card';

  @override
  String get editExerciseCard => 'Edit card';

  @override
  String get addExercise => 'Add exercise';

  @override
  String get fieldTitle => 'Title';

  @override
  String get fieldTitleHint => 'E.g. WEDNESDAY';

  @override
  String get titleRequired => 'Title is required';

  @override
  String get fieldDescription => 'Description';

  @override
  String get fieldDescriptionHint => 'E.g. UPPER BODY 1';

  @override
  String get previewTitle => 'Preview';

  @override
  String get previewEmptyHint => 'Your card preview will appear here when you enter a title or complete exercises.';

  @override
  String get exercisesTitle => 'Exercises';

  @override
  String get addFirstExerciseHint => 'Tap the + button to add your first exercise.';

  @override
  String exerciseLabel(int number) {
    return 'Exercise $number';
  }

  @override
  String get exerciseHint => 'E.g. Flat Bench Press';

  @override
  String get fieldSeries => 'Sets';

  @override
  String get fieldSeriesHint => '4';

  @override
  String get fieldRepetitions => 'Reps';

  @override
  String get fieldRepetitionsHint => '10';

  @override
  String get saveExerciseCard => 'Save card';

  @override
  String get completeBeforeAddAnother => 'Complete name, sets and reps before adding another.';

  @override
  String get addAtLeastOneExercise => 'Add at least one complete exercise.';

  @override
  String get completeAllBeforeSave => 'Complete all exercises before saving.';

  @override
  String seriesRepsFormat(int series, int repetitions) {
    return '$series sets x $repetitions reps';
  }

  @override
  String get removeRoutineTitle => 'Remove routine';

  @override
  String get removeRoutineMessage => 'Remove the routine from this day? Today\'s progress will be kept.';

  @override
  String get noRoutineForDay => 'No routine assigned for this day';

  @override
  String get todayRoutine => 'Today\'s routine';

  @override
  String get finishRoutine => 'Finish routine';

  @override
  String get routineCompleted => 'Routine completed! 🎉';

  @override
  String get warmUpTitle => 'Warm-up';

  @override
  String get warmUpEnableSubtitle => 'Treadmill, stationary bike, elliptical, etc.';

  @override
  String get warmUpDescriptionLabel => 'Activity';

  @override
  String get warmUpDescriptionHint => 'E.g. Incline treadmill';

  @override
  String get warmUpMinutesLabel => 'Time (minutes)';

  @override
  String get warmUpMinutesHint => '10';

  @override
  String get warmUpPlacementTitle => 'When to do it?';

  @override
  String get warmUpPlacementStart => 'At the start';

  @override
  String get warmUpPlacementEnd => 'At the end';

  @override
  String warmUpMinutesFormat(int minutes) {
    return '$minutes min';
  }

  @override
  String get completeWarmUpFields => 'Complete the warm-up activity and minutes.';

  @override
  String get stretchingsTitle => 'Stretching';

  @override
  String get stretchingsSubtitle => 'At the start of the routine, after warm-up if enabled.';

  @override
  String stretchingLabel(int index) {
    return 'Stretch $index';
  }

  @override
  String get stretchingDescriptionHint => 'E.g. Shoulder rotations';

  @override
  String get stretchingRepetitionsLabel => 'Repetitions';

  @override
  String get stretchingRepetitionsHint => '10';

  @override
  String stretchingRepetitionsFormat(int repetitions) {
    return '$repetitions reps';
  }

  @override
  String get addStretching => 'Add stretch';

  @override
  String get addFirstStretchingHint => 'Add one or more stretches for this routine.';

  @override
  String get completeBeforeAddAnotherStretching => 'Complete description and repetitions before adding another stretch.';

  @override
  String get completeAllStretchingsBeforeSave => 'Complete all stretches before saving.';

  @override
  String get routinesModuleTitle => 'Routines';

  @override
  String get noRoutinesYet => 'You don\'t have routines yet. Build one from your libraries.';

  @override
  String get newRoutine => 'New routine';

  @override
  String get editRoutine => 'Edit routine';

  @override
  String get saveRoutine => 'Save routine';

  @override
  String get deleteRoutineTitle => 'Delete routine';

  @override
  String deleteRoutineMessage(String title) {
    return 'Delete $title? It will also be removed from the planner.';
  }

  @override
  String get exerciseLibraryTitle => 'Exercise library';

  @override
  String get exerciseLibraryEmpty => 'Create reusable exercises to build routines.';

  @override
  String get newExerciseTemplate => 'New exercise';

  @override
  String get editExerciseTemplate => 'Edit exercise';

  @override
  String get exerciseTemplateNameLabel => 'Exercise name';

  @override
  String get deleteExerciseTemplateTitle => 'Delete exercise';

  @override
  String deleteExerciseTemplateMessage(String title) {
    return 'Delete $title?';
  }

  @override
  String get stretchingLibraryTitle => 'Stretching library';

  @override
  String get stretchingLibraryEmpty => 'Create reusable stretches to build routines.';

  @override
  String get newStretchingTemplate => 'New stretch';

  @override
  String get editStretchingTemplate => 'Edit stretch';

  @override
  String get deleteStretchingTemplateTitle => 'Delete stretch';

  @override
  String deleteStretchingTemplateMessage(String description) {
    return 'Delete $description?';
  }

  @override
  String get warmUpLibraryTitle => 'Warm-up library';

  @override
  String get warmUpLibraryEmpty => 'Create reusable warm-ups to build routines.';

  @override
  String get newWarmUpTemplate => 'New warm-up';

  @override
  String get editWarmUpTemplate => 'Edit warm-up';

  @override
  String get deleteWarmUpTemplateTitle => 'Delete warm-up';

  @override
  String deleteWarmUpTemplateMessage(String description) {
    return 'Delete $description?';
  }

  @override
  String get templateInUseMessage => 'Cannot delete because it is used in a routine.';

  @override
  String get pickWarmUpTitle => 'Pick warm-up';

  @override
  String get pickExercisesTitle => 'Pick exercises';

  @override
  String get pickStretchingsTitle => 'Pick stretches';

  @override
  String get noWarmUpSelected => 'No warm-up assigned';

  @override
  String get addFromLibrary => 'Add from library';

  @override
  String get routineSlotsEmpty => 'None assigned yet';

  @override
  String get addAtLeastOneExerciseToRoutine => 'Add at least one exercise to the routine.';

  @override
  String get searchLibraryHint => 'Search...';

  @override
  String get noMatchingLibraryItems => 'No matches';

  @override
  String get addSelected => 'Add selected';

  @override
  String get missingTemplateLabel => 'Unavailable';

  @override
  String get missingTemplateWarning => 'Some library items no longer exist.';
}
