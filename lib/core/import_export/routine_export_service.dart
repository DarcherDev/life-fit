import 'dart:convert';

import 'package:life_fit/core/import_export/life_fit_export_document.dart';
import 'package:life_fit/core/profile/models/personal_profile.dart';
import 'package:life_fit/core/repositories/app_repositories.dart';
import 'package:life_fit/core/services/weight_unit_service.dart';
import 'package:life_fit/modules/ejercicios/models/exercise_template.dart';
import 'package:life_fit/shared/models/routine_card.dart';
import 'package:life_fit/shared/utils/routine_resolver.dart';

/// Construye el documento JSON denormalizado (perfil + rutinas resueltas).
class RoutineExportService {
  const RoutineExportService({
    required AppRepositories repositories,
    required PersonalProfile Function() profileReader,
    required WeightUnit Function() weightUnitReader,
    DateTime Function()? clock,
  })  : _repositories = repositories,
        _profileReader = profileReader,
        _weightUnitReader = weightUnitReader,
        _clock = clock;

  final AppRepositories _repositories;
  final PersonalProfile Function() _profileReader;
  final WeightUnit Function() _weightUnitReader;
  final DateTime Function()? _clock;

  LifeFitExportDocument buildDocument() {
    final profile = _profileReader();
    final libraries = _repositories.getLibraries();
    final routines = _repositories.routines
        .getRoutineCards()
        .map((card) => _mapRoutine(card, libraries))
        .toList();

    final now = (_clock ?? DateTime.now)().toUtc();

    return LifeFitExportDocument(
      schemaVersion: LifeFitExportDocument.supportedSchemaVersion,
      exportedAt: now.toIso8601String(),
      profile: ExportProfile(
        ageYears: profile.ageYears,
        heightCm: profile.heightCm,
        bodyWeightKg: profile.bodyWeightKg,
        weightUnit: _weightUnitReader(),
      ),
      routines: routines,
    );
  }

  String buildJsonString({bool pretty = true}) {
    final document = buildDocument();
    if (pretty) {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(document.toJson());
    }
    return jsonEncode(document.toJson());
  }

  ExportRoutine _mapRoutine(RoutineCard card, RoutineLibraries libraries) {
    ExportWarmUp? warmUp;
    if (card.warmUpId != null) {
      final template = libraries.warmUps[card.warmUpId];
      warmUp = ExportWarmUp(
        id: card.warmUpId,
        description: template?.description ?? '',
        minutes: template?.minutes ?? 0,
      );
    }

    final stretchings = card.stretchingSlots.map((slot) {
      final template = libraries.stretchings[slot.stretchingId];
      return ExportStretching(
        id: slot.stretchingId,
        description: template?.description ?? '',
        repetitions: template?.repetitions ?? 0,
      );
    }).toList();

    final exercises = card.exerciseSlots.map((slot) {
      final template = libraries.exercises[slot.exerciseId] ??
          ExerciseTemplate(
            id: slot.exerciseId,
            title: '',
            series: 0,
            repetitions: 0,
          );
      return ExportExercise(
        id: slot.exerciseId,
        title: template.title,
        series: template.series,
        repetitions: template.repetitions,
        description: template.description,
        weightKg: template.weightKg,
      );
    }).toList();

    return ExportRoutine(
      id: card.id,
      title: card.title,
      description: card.description,
      warmUpPlacement: card.warmUpPlacement,
      warmUp: warmUp,
      stretchings: stretchings,
      exercises: exercises,
    );
  }
}
