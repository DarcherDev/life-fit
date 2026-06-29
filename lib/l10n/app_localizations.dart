import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'Life Fit'**
  String get appTitle;

  /// No description provided for @homeTagline.
  ///
  /// In es, this message translates to:
  /// **'gestiona tu vida'**
  String get homeTagline;

  /// No description provided for @homeGymDayTitle.
  ///
  /// In es, this message translates to:
  /// **'Dia de gym'**
  String get homeGymDayTitle;

  /// No description provided for @homeGymDaySubtitle.
  ///
  /// In es, this message translates to:
  /// **'Rutina asignada para hoy'**
  String get homeGymDaySubtitle;

  /// No description provided for @homeExercisesTitle.
  ///
  /// In es, this message translates to:
  /// **'Ejercicios'**
  String get homeExercisesTitle;

  /// No description provided for @homeExercisesSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Crea y personaliza tus tarjetas de ejercicios'**
  String get homeExercisesSubtitle;

  /// No description provided for @homePlannerTitle.
  ///
  /// In es, this message translates to:
  /// **'Planificador'**
  String get homePlannerTitle;

  /// No description provided for @homePlannerSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Asigna rutinas a tu calendario'**
  String get homePlannerSubtitle;

  /// No description provided for @languageMenu.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get languageMenu;

  /// No description provided for @languageSpanish.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// No description provided for @languageEnglish.
  ///
  /// In es, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @themeMenu.
  ///
  /// In es, this message translates to:
  /// **'Tema'**
  String get themeMenu;

  /// No description provided for @themeLight.
  ///
  /// In es, this message translates to:
  /// **'Claro'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In es, this message translates to:
  /// **'Oscuro'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In es, this message translates to:
  /// **'Sistema'**
  String get themeSystem;

  /// No description provided for @localePromptTitle.
  ///
  /// In es, this message translates to:
  /// **'Elige tu idioma'**
  String get localePromptTitle;

  /// No description provided for @localePromptMessage.
  ///
  /// In es, this message translates to:
  /// **'El idioma de tu dispositivo no está disponible en la app. ¿En qué idioma quieres usar Life Fit?'**
  String get localePromptMessage;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @remove.
  ///
  /// In es, this message translates to:
  /// **'Quitar'**
  String get remove;

  /// No description provided for @delete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get save;

  /// No description provided for @back.
  ///
  /// In es, this message translates to:
  /// **'Volver'**
  String get back;

  /// No description provided for @required.
  ///
  /// In es, this message translates to:
  /// **'Obligatorio'**
  String get required;

  /// No description provided for @validNumber.
  ///
  /// In es, this message translates to:
  /// **'Número válido'**
  String get validNumber;

  /// No description provided for @noTitle.
  ///
  /// In es, this message translates to:
  /// **'Sin título'**
  String get noTitle;

  /// No description provided for @plannerTitle.
  ///
  /// In es, this message translates to:
  /// **'Planificador'**
  String get plannerTitle;

  /// No description provided for @createExercisesFirst.
  ///
  /// In es, this message translates to:
  /// **'Primero crea ejercicios en la sección Ejercicios.'**
  String get createExercisesFirst;

  /// No description provided for @routineRemovedFromDay.
  ///
  /// In es, this message translates to:
  /// **'Rutina quitada del día'**
  String get routineRemovedFromDay;

  /// No description provided for @routineAssignedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Rutina asignada correctamente'**
  String get routineAssignedSuccess;

  /// No description provided for @noRoutineAssigned.
  ///
  /// In es, this message translates to:
  /// **'Sin rutina asignada'**
  String get noRoutineAssigned;

  /// No description provided for @tapToAssignRoutine.
  ///
  /// In es, this message translates to:
  /// **'Toca para asignar una rutina'**
  String get tapToAssignRoutine;

  /// No description provided for @plannerItemsTapToChange.
  ///
  /// In es, this message translates to:
  /// **'{count} items · Toca para cambiar'**
  String plannerItemsTapToChange(int count);

  /// No description provided for @plannerDescriptionTapToChange.
  ///
  /// In es, this message translates to:
  /// **'{description} · Toca para cambiar'**
  String plannerDescriptionTapToChange(String description);

  /// No description provided for @assignRoutineForDate.
  ///
  /// In es, this message translates to:
  /// **'Asignar rutina para {date}'**
  String assignRoutineForDate(String date);

  /// No description provided for @changeRoutineForDate.
  ///
  /// In es, this message translates to:
  /// **'Cambiar rutina del {date}'**
  String changeRoutineForDate(String date);

  /// No description provided for @changeRoutine.
  ///
  /// In es, this message translates to:
  /// **'Cambiar rutina'**
  String get changeRoutine;

  /// No description provided for @searchRoutineHint.
  ///
  /// In es, this message translates to:
  /// **'Buscar rutina...'**
  String get searchRoutineHint;

  /// No description provided for @removeRoutineFromDay.
  ///
  /// In es, this message translates to:
  /// **'Quitar rutina del día'**
  String get removeRoutineFromDay;

  /// No description provided for @noMatchingRoutines.
  ///
  /// In es, this message translates to:
  /// **'No hay rutinas que coincidan'**
  String get noMatchingRoutines;

  /// No description provided for @exercisesModuleTitle.
  ///
  /// In es, this message translates to:
  /// **'Ejercicios'**
  String get exercisesModuleTitle;

  /// No description provided for @deleteExerciseCardTitle.
  ///
  /// In es, this message translates to:
  /// **'Eliminar tarjeta'**
  String get deleteExerciseCardTitle;

  /// No description provided for @deleteExerciseCardMessage.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar {title}? También se quitará del planificador.'**
  String deleteExerciseCardMessage(String title);

  /// No description provided for @noExerciseCardsYet.
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes tarjetas de ejercicios'**
  String get noExerciseCardsYet;

  /// No description provided for @noExerciseCardsHint.
  ///
  /// In es, this message translates to:
  /// **'Crea tarjetas con ejercicios para usarlas en el planificador.'**
  String get noExerciseCardsHint;

  /// No description provided for @newExerciseCard.
  ///
  /// In es, this message translates to:
  /// **'Nueva tarjeta'**
  String get newExerciseCard;

  /// No description provided for @editExerciseCard.
  ///
  /// In es, this message translates to:
  /// **'Editar tarjeta'**
  String get editExerciseCard;

  /// No description provided for @addExercise.
  ///
  /// In es, this message translates to:
  /// **'Agregar ejercicio'**
  String get addExercise;

  /// No description provided for @fieldTitle.
  ///
  /// In es, this message translates to:
  /// **'Título'**
  String get fieldTitle;

  /// No description provided for @fieldTitleHint.
  ///
  /// In es, this message translates to:
  /// **'Ej. MIÉRCOLES'**
  String get fieldTitleHint;

  /// No description provided for @titleRequired.
  ///
  /// In es, this message translates to:
  /// **'El título es obligatorio'**
  String get titleRequired;

  /// No description provided for @fieldDescription.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get fieldDescription;

  /// No description provided for @fieldDescriptionHint.
  ///
  /// In es, this message translates to:
  /// **'Ej. TREN SUPERIOR 1'**
  String get fieldDescriptionHint;

  /// No description provided for @previewTitle.
  ///
  /// In es, this message translates to:
  /// **'Vista previa'**
  String get previewTitle;

  /// No description provided for @previewEmptyHint.
  ///
  /// In es, this message translates to:
  /// **'Aquí verás la tarjeta cuando escribas el título o completes ejercicios.'**
  String get previewEmptyHint;

  /// No description provided for @exercisesTitle.
  ///
  /// In es, this message translates to:
  /// **'Ejercicios'**
  String get exercisesTitle;

  /// No description provided for @addFirstExerciseHint.
  ///
  /// In es, this message translates to:
  /// **'Pulsa el botón + para agregar tu primer ejercicio.'**
  String get addFirstExerciseHint;

  /// No description provided for @exerciseLabel.
  ///
  /// In es, this message translates to:
  /// **'Ejercicio {number}'**
  String exerciseLabel(int number);

  /// No description provided for @exerciseHint.
  ///
  /// In es, this message translates to:
  /// **'Ej. Press de Banca Plana'**
  String get exerciseHint;

  /// No description provided for @fieldSeries.
  ///
  /// In es, this message translates to:
  /// **'Series'**
  String get fieldSeries;

  /// No description provided for @fieldSeriesHint.
  ///
  /// In es, this message translates to:
  /// **'4'**
  String get fieldSeriesHint;

  /// No description provided for @fieldRepetitions.
  ///
  /// In es, this message translates to:
  /// **'Repeticiones'**
  String get fieldRepetitions;

  /// No description provided for @fieldRepetitionsHint.
  ///
  /// In es, this message translates to:
  /// **'10'**
  String get fieldRepetitionsHint;

  /// No description provided for @saveExerciseCard.
  ///
  /// In es, this message translates to:
  /// **'Guardar tarjeta'**
  String get saveExerciseCard;

  /// No description provided for @completeBeforeAddAnother.
  ///
  /// In es, this message translates to:
  /// **'Completa nombre, series y repeticiones antes de agregar otro.'**
  String get completeBeforeAddAnother;

  /// No description provided for @addAtLeastOneExercise.
  ///
  /// In es, this message translates to:
  /// **'Agrega al menos un ejercicio completo.'**
  String get addAtLeastOneExercise;

  /// No description provided for @completeAllBeforeSave.
  ///
  /// In es, this message translates to:
  /// **'Completa todos los ejercicios antes de guardar.'**
  String get completeAllBeforeSave;

  /// No description provided for @seriesRepsFormat.
  ///
  /// In es, this message translates to:
  /// **'{series} series x {repetitions} repeticiones'**
  String seriesRepsFormat(int series, int repetitions);

  /// No description provided for @removeRoutineTitle.
  ///
  /// In es, this message translates to:
  /// **'Quitar rutina'**
  String get removeRoutineTitle;

  /// No description provided for @removeRoutineMessage.
  ///
  /// In es, this message translates to:
  /// **'¿Quitar la rutina de este día? El progreso del día se conservará.'**
  String get removeRoutineMessage;

  /// No description provided for @noRoutineForDay.
  ///
  /// In es, this message translates to:
  /// **'No hay rutina asignada para este día'**
  String get noRoutineForDay;

  /// No description provided for @todayRoutine.
  ///
  /// In es, this message translates to:
  /// **'Rutina de hoy'**
  String get todayRoutine;

  /// No description provided for @finishRoutine.
  ///
  /// In es, this message translates to:
  /// **'Terminar rutina'**
  String get finishRoutine;

  /// No description provided for @routineCompleted.
  ///
  /// In es, this message translates to:
  /// **'¡Rutina completada! 🎉'**
  String get routineCompleted;

  /// No description provided for @warmUpTitle.
  ///
  /// In es, this message translates to:
  /// **'Calentamiento'**
  String get warmUpTitle;

  /// No description provided for @warmUpEnableSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Caminadora, bici estática, elíptica, etc.'**
  String get warmUpEnableSubtitle;

  /// No description provided for @warmUpDescriptionLabel.
  ///
  /// In es, this message translates to:
  /// **'Actividad'**
  String get warmUpDescriptionLabel;

  /// No description provided for @warmUpDescriptionHint.
  ///
  /// In es, this message translates to:
  /// **'Ej. Caminadora inclinada'**
  String get warmUpDescriptionHint;

  /// No description provided for @warmUpMinutesLabel.
  ///
  /// In es, this message translates to:
  /// **'Tiempo (minutos)'**
  String get warmUpMinutesLabel;

  /// No description provided for @warmUpMinutesHint.
  ///
  /// In es, this message translates to:
  /// **'10'**
  String get warmUpMinutesHint;

  /// No description provided for @warmUpPlacementTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Cuándo hacerlo?'**
  String get warmUpPlacementTitle;

  /// No description provided for @warmUpPlacementStart.
  ///
  /// In es, this message translates to:
  /// **'Al inicio'**
  String get warmUpPlacementStart;

  /// No description provided for @warmUpPlacementEnd.
  ///
  /// In es, this message translates to:
  /// **'Al final'**
  String get warmUpPlacementEnd;

  /// No description provided for @warmUpMinutesFormat.
  ///
  /// In es, this message translates to:
  /// **'{minutes} min'**
  String warmUpMinutesFormat(int minutes);

  /// No description provided for @completeWarmUpFields.
  ///
  /// In es, this message translates to:
  /// **'Completa la actividad y los minutos del calentamiento.'**
  String get completeWarmUpFields;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
