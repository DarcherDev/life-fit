import 'package:life_fit/core/data/default_library_catalog.dart';
import 'package:life_fit/core/import_export/life_fit_export_document.dart';
import 'package:life_fit/core/profile/models/personal_profile.dart';
import 'package:life_fit/core/services/weight_unit_service.dart';
import 'package:life_fit/modules/calentamiento/models/warm_up_template.dart';

/// Documento de ejemplo (perfil + una rutina) para usuarios sin rutinas.
///
/// Usa los `id` de la biblioteca base para que importarlo sin cambios no
/// duplique plantillas.
class SampleRoutineDocumentBuilder {
  const SampleRoutineDocumentBuilder({
    required PersonalProfile Function() profileReader,
    required WeightUnit Function() weightUnitReader,
    required this.routineTitle,
    required this.routineDescription,
    DateTime Function()? clock,
  })  : _profileReader = profileReader,
        _weightUnitReader = weightUnitReader,
        _clock = clock;

  static const sampleRoutineId = 'sample-routine';
  static const _stretchingCount = 2;
  static const _exerciseCount = 4;

  final PersonalProfile Function() _profileReader;
  final WeightUnit Function() _weightUnitReader;
  final DateTime Function()? _clock;
  final String routineTitle;
  final String routineDescription;

  LifeFitExportDocument buildDocument() {
    final profile = _profileReader();
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
      routines: [_buildRoutine()],
    );
  }

  String buildJsonString({bool pretty = true}) =>
      encodeExportDocument(buildDocument(), pretty: pretty);

  ExportRoutine _buildRoutine() {
    const warmUps = DefaultLibraryCatalog.warmUpTemplates;

    return ExportRoutine(
      id: sampleRoutineId,
      title: routineTitle,
      description: routineDescription,
      warmUpStart: _toExportWarmUp(warmUps.first),
      warmUpEnd: warmUps.length > 1 ? _toExportWarmUp(warmUps[1]) : null,
      stretchings: DefaultLibraryCatalog.stretchingTemplates
          .take(_stretchingCount)
          .map(
            (item) => ExportStretching(
              id: item.id,
              description: item.description,
              repetitions: item.repetitions,
            ),
          )
          .toList(),
      exercises: DefaultLibraryCatalog.exerciseTemplates
          .take(_exerciseCount)
          .map(
            (item) => ExportExercise(
              id: item.id,
              title: item.title,
              series: item.series,
              repetitions: item.repetitions,
              description: item.description,
              weightKg: item.weightKg,
            ),
          )
          .toList(),
    );
  }

  static ExportWarmUp _toExportWarmUp(WarmUpTemplate template) {
    return ExportWarmUp(
      id: template.id,
      description: template.description,
      minutes: template.minutes,
    );
  }
}
