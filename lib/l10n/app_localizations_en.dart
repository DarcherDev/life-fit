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
  String get homeRoutinesTitle => 'Routine';

  @override
  String get homeRoutinesSubtitle => 'Create and customize your cards';

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
  String get routinesTitle => 'Routine';

  @override
  String get deleteRoutineTitle => 'Delete routine';

  @override
  String deleteRoutineMessage(String title) {
    return 'Delete $title? It will also be removed from the planner.';
  }

  @override
  String get noRoutinesYet => 'You don\'t have routines yet';

  @override
  String get noRoutinesHint => 'Create cards with exercises or tasks to use them in the planner.';

  @override
  String get newRoutine => 'New routine';

  @override
  String get editRoutine => 'Edit routine';

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
  String get previewEmptyHint => 'Your routine preview will appear here when you enter a title or complete exercises.';

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
  String get saveRoutine => 'Save routine';

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
}
