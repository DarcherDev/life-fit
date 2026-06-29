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
  String get homeExercisesSubtitle => 'Create and customize your exercise cards';

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
  String get createExercisesFirst => 'Create exercises in the Exercises section first.';

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
}
