import 'dart:convert';

import 'package:uuid/uuid.dart';

import 'package:life_fit/core/import_export/life_fit_export_document.dart';
import 'package:life_fit/core/profile/models/personal_profile.dart';
import 'package:life_fit/core/repositories/app_repositories.dart';
import 'package:life_fit/core/services/weight_unit_service.dart';
import 'package:life_fit/modules/calentamiento/models/warm_up_template.dart';
import 'package:life_fit/modules/ejercicios/models/exercise_template.dart';
import 'package:life_fit/modules/estiramiento/models/stretching_template.dart';
import 'package:life_fit/shared/models/routine_card.dart';
import 'package:life_fit/shared/models/routine_exercise_slot.dart';
import 'package:life_fit/shared/models/routine_stretching_slot.dart';

class RoutineImportException implements Exception {
  RoutineImportException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Importa un documento JSON: upsert de plantillas, reemplazo de rutinas,
/// limpieza de asignaciones huérfanas y aplicación de perfil/unidad.
class RoutineImportService {
  RoutineImportService({
    required AppRepositories repositories,
    required PersonalProfile Function() profileReader,
    required Future<void> Function(PersonalProfile profile) saveProfile,
    required Future<void> Function(WeightUnit unit) saveWeightUnit,
    Uuid? uuid,
  })  : _repositories = repositories,
        _profileReader = profileReader,
        _saveProfile = saveProfile,
        _saveWeightUnit = saveWeightUnit,
        _uuid = uuid ?? const Uuid();

  final AppRepositories _repositories;
  final PersonalProfile Function() _profileReader;
  final Future<void> Function(PersonalProfile profile) _saveProfile;
  final Future<void> Function(WeightUnit unit) _saveWeightUnit;
  final Uuid _uuid;

  Future<LifeFitExportDocument> importJsonString(String raw) async {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      throw RoutineImportException('empty');
    }

    late final Object? decoded;
    try {
      decoded = jsonDecode(trimmed);
    } catch (_) {
      throw RoutineImportException('invalid_json');
    }

    if (decoded is! Map<String, dynamic>) {
      throw RoutineImportException('invalid_json');
    }

    final document = LifeFitExportDocument.fromJson(decoded);
    if (document.schemaVersion !=
        LifeFitExportDocument.supportedSchemaVersion) {
      throw RoutineImportException('unsupported_schema');
    }

    await importDocument(document);
    return document;
  }

  Future<void> importDocument(LifeFitExportDocument document) async {
    final assignmentDatesBefore = _repositories.assignments
        .getAssignments()
        .map((assignment) => assignment.dateKey)
        .toSet();

    final builtRoutines = <RoutineCard>[];
    var emptyRoutineTitleCount = 0;
    for (final exportRoutine in document.routines) {
      final hasTitle = exportRoutine.title.trim().isNotEmpty;
      if (!hasTitle) {
        emptyRoutineTitleCount += 1;
      }
      builtRoutines.add(
        await _buildRoutineCard(
          exportRoutine,
          emptyRoutineTitleNumber: hasTitle ? null : emptyRoutineTitleCount,
        ),
      );
    }

    await _repositories.routines.replaceAllRoutineCards(builtRoutines);

    final validRoutineIds = builtRoutines.map((card) => card.id).toSet();
    final orphanDates = <String>{};

    for (final assignment in _repositories.assignments.getAssignments()) {
      if (!validRoutineIds.contains(assignment.routineId)) {
        orphanDates.add(assignment.dateKey);
        await _repositories.assignments
            .saveAssignment(assignment.dateKey, null);
      }
    }

    final datesToClear = assignmentDatesBefore.union(orphanDates).union(
          _repositories.assignments
              .getAssignments()
              .map((assignment) => assignment.dateKey)
              .toSet(),
        );

    for (final dateKey in datesToClear) {
      await _repositories.progress.clearDayProgress(dateKey);
    }

    final currentProfile = _profileReader();
    await _saveProfile(
      PersonalProfile(
        ageYears: document.profile.ageYears ?? currentProfile.ageYears,
        heightCm: document.profile.heightCm ?? currentProfile.heightCm,
        bodyWeightKg:
            document.profile.bodyWeightKg ?? currentProfile.bodyWeightKg,
      ),
    );
    final weightUnit = document.profile.weightUnit;
    if (weightUnit != null) {
      await _saveWeightUnit(weightUnit);
    }
  }

  Future<RoutineCard> _buildRoutineCard(
    ExportRoutine exportRoutine, {
    int? emptyRoutineTitleNumber,
  }) async {
    final exerciseSlots = <RoutineExerciseSlot>[];
    var emptyExerciseTitleCount = 0;
    for (final exercise in exportRoutine.exercises) {
      final hasTitle = exercise.title.trim().isNotEmpty;
      if (!hasTitle) {
        emptyExerciseTitleCount += 1;
      }
      final exerciseId = await _upsertExercise(
        exercise,
        emptyExerciseTitleNumber: hasTitle ? null : emptyExerciseTitleCount,
      );
      exerciseSlots.add(
        RoutineExerciseSlot(
          slotId: _uuid.v4(),
          exerciseId: exerciseId,
        ),
      );
    }

    final stretchingSlots = <RoutineStretchingSlot>[];
    for (final stretching in exportRoutine.stretchings) {
      final stretchingId = await _upsertStretching(stretching);
      stretchingSlots.add(
        RoutineStretchingSlot(
          slotId: _uuid.v4(),
          stretchingId: stretchingId,
        ),
      );
    }

    final startWarmUp = exportRoutine.warmUpStart;
    final startWarmUpId =
        startWarmUp == null ? null : await _upsertWarmUp(startWarmUp);
    final endWarmUp = exportRoutine.warmUpEnd;
    final endWarmUpId =
        endWarmUp == null ? null : await _upsertWarmUp(endWarmUp);

    final routineId = (exportRoutine.id != null && exportRoutine.id!.isNotEmpty)
        ? exportRoutine.id!
        : _uuid.v4();

    final title = emptyRoutineTitleNumber != null
        ? 'Rutina $emptyRoutineTitleNumber'
        : exportRoutine.title.trim();

    return RoutineCard(
      id: routineId,
      title: title,
      description: exportRoutine.description,
      exerciseSlots: exerciseSlots,
      stretchingSlots: stretchingSlots,
      startWarmUpId: startWarmUpId,
      endWarmUpId: endWarmUpId,
    );
  }

  Future<String> _upsertExercise(
    ExportExercise exercise, {
    int? emptyExerciseTitleNumber,
  }) async {
    final id = (exercise.id != null && exercise.id!.isNotEmpty)
        ? exercise.id!
        : _uuid.v4();
    final title = emptyExerciseTitleNumber != null
        ? 'Ejercicio $emptyExerciseTitleNumber'
        : exercise.title.trim();
    final series = exercise.series > 0 ? exercise.series : 3;
    final repetitions = exercise.repetitions > 0 ? exercise.repetitions : 10;

    await _repositories.exerciseTemplates.upsertExerciseTemplate(
      ExerciseTemplate(
        id: id,
        title: title,
        series: series,
        repetitions: repetitions,
        description: exercise.description,
        weightKg: exercise.weightKg,
      ),
    );
    return id;
  }

  Future<String> _upsertStretching(ExportStretching stretching) async {
    final id = (stretching.id != null && stretching.id!.isNotEmpty)
        ? stretching.id!
        : _uuid.v4();
    final repetitions =
        stretching.repetitions > 0 ? stretching.repetitions : 10;
    await _repositories.stretchingTemplates.upsertStretchingTemplate(
      StretchingTemplate(
        id: id,
        description: stretching.description,
        repetitions: repetitions,
      ),
    );
    return id;
  }

  Future<String> _upsertWarmUp(ExportWarmUp warmUp) async {
    final id =
        (warmUp.id != null && warmUp.id!.isNotEmpty) ? warmUp.id! : _uuid.v4();
    final minutes = warmUp.minutes > 0 ? warmUp.minutes : 10;
    await _repositories.warmUpTemplates.upsertWarmUpTemplate(
      WarmUpTemplate(
        id: id,
        description: warmUp.description,
        minutes: minutes,
      ),
    );
    return id;
  }
}
