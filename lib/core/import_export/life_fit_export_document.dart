import 'dart:convert';

import 'package:life_fit/core/services/weight_unit_service.dart';
import 'package:life_fit/modules/calentamiento/models/warm_up_placement.dart';

String encodeExportDocument(
  LifeFitExportDocument document, {
  bool pretty = true,
}) {
  if (pretty) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(document.toJson());
  }
  return jsonEncode(document.toJson());
}

/// Documento JSON de export/import (schemaVersion 1).
class LifeFitExportDocument {
  const LifeFitExportDocument({
    required this.schemaVersion,
    required this.exportedAt,
    required this.profile,
    required this.routines,
  });

  static const supportedSchemaVersion = 1;

  final int schemaVersion;
  final String exportedAt;
  final ExportProfile profile;
  final List<ExportRoutine> routines;

  Map<String, dynamic> toJson() {
    return {
      'schemaVersion': schemaVersion,
      'exportedAt': exportedAt,
      'profile': profile.toJson(),
      'routines': routines.map((item) => item.toJson()).toList(),
    };
  }

  factory LifeFitExportDocument.fromJson(Map<String, dynamic> json) {
    final schemaVersion = json['schemaVersion'] as int? ?? 0;
    final routinesJson = json['routines'] as List<dynamic>? ?? [];
    final profileJson = json['profile'];

    return LifeFitExportDocument(
      schemaVersion: schemaVersion,
      exportedAt: json['exportedAt'] as String? ?? '',
      profile: ExportProfile.fromJson(
        profileJson is Map<String, dynamic> ? profileJson : null,
      ),
      routines: routinesJson
          .map((item) => ExportRoutine.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ExportProfile {
  const ExportProfile({
    this.ageYears,
    this.heightCm,
    this.bodyWeightKg,
    this.weightUnit,
  });

  final int? ageYears;
  final double? heightCm;
  final double? bodyWeightKg;
  final WeightUnit? weightUnit;

  Map<String, dynamic> toJson() {
    return {
      if (ageYears != null) 'ageYears': ageYears,
      if (heightCm != null) 'heightCm': heightCm,
      if (bodyWeightKg != null) 'bodyWeightKg': bodyWeightKg,
      if (weightUnit != null) 'weightUnit': weightUnit!.toStorage(),
    };
  }

  factory ExportProfile.fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) {
      return const ExportProfile();
    }
    return ExportProfile(
      ageYears: json['ageYears'] as int?,
      heightCm: (json['heightCm'] as num?)?.toDouble(),
      bodyWeightKg: (json['bodyWeightKg'] as num?)?.toDouble(),
      weightUnit: WeightUnit.fromStorage(json['weightUnit'] as String?),
    );
  }
}

class ExportRoutine {
  const ExportRoutine({
    this.id,
    required this.title,
    this.description = '',
    this.warmUpStart,
    this.warmUpEnd,
    this.stretchings = const [],
    this.exercises = const [],
  });

  final String? id;
  final String title;
  final String description;
  final ExportWarmUp? warmUpStart;
  final ExportWarmUp? warmUpEnd;
  final List<ExportStretching> stretchings;
  final List<ExportExercise> exercises;

  ExportWarmUp? warmUpFor(WarmUpPlacement placement) {
    return placement == WarmUpPlacement.start ? warmUpStart : warmUpEnd;
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      if (description.isNotEmpty) 'description': description,
      if (warmUpStart != null) 'warmUpStart': warmUpStart!.toJson(),
      if (warmUpEnd != null) 'warmUpEnd': warmUpEnd!.toJson(),
      if (stretchings.isNotEmpty)
        'stretchings': stretchings.map((item) => item.toJson()).toList(),
      'exercises': exercises.map((item) => item.toJson()).toList(),
    };
  }

  factory ExportRoutine.fromJson(Map<String, dynamic> json) {
    final stretchingsJson = json['stretchings'] as List<dynamic>? ?? [];
    final exercisesJson = json['exercises'] as List<dynamic>? ?? [];
    var warmUpStart = _parseWarmUp(json['warmUpStart']);
    var warmUpEnd = _parseWarmUp(json['warmUpEnd']);
    final legacyWarmUp = _parseWarmUp(json['warmUp']);
    if (legacyWarmUp != null && warmUpStart == null && warmUpEnd == null) {
      final placement =
          WarmUpPlacement.fromJson(json['warmUpPlacement'] as String?);
      if (placement == WarmUpPlacement.end) {
        warmUpEnd = legacyWarmUp;
      } else {
        warmUpStart = legacyWarmUp;
      }
    }

    return ExportRoutine(
      id: json['id'] as String?,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      warmUpStart: warmUpStart,
      warmUpEnd: warmUpEnd,
      stretchings: stretchingsJson
          .map(
            (item) => ExportStretching.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      exercises: exercisesJson
          .map(
            (item) => ExportExercise.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  static ExportWarmUp? _parseWarmUp(Object? json) {
    return json is Map<String, dynamic> ? ExportWarmUp.fromJson(json) : null;
  }
}

class ExportWarmUp {
  const ExportWarmUp({
    this.id,
    required this.description,
    required this.minutes,
  });

  final String? id;
  final String description;
  final int minutes;

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'description': description,
      'minutes': minutes,
    };
  }

  factory ExportWarmUp.fromJson(Map<String, dynamic> json) {
    return ExportWarmUp(
      id: json['id'] as String?,
      description: json['description'] as String? ?? '',
      minutes: json['minutes'] as int? ?? 0,
    );
  }
}

class ExportStretching {
  const ExportStretching({
    this.id,
    required this.description,
    required this.repetitions,
  });

  final String? id;
  final String description;
  final int repetitions;

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'description': description,
      'repetitions': repetitions,
    };
  }

  factory ExportStretching.fromJson(Map<String, dynamic> json) {
    return ExportStretching(
      id: json['id'] as String?,
      description: json['description'] as String? ?? '',
      repetitions: json['repetitions'] as int? ?? 0,
    );
  }
}

class ExportExercise {
  const ExportExercise({
    this.id,
    required this.title,
    required this.series,
    required this.repetitions,
    this.description = '',
    this.weightKg,
  });

  final String? id;
  final String title;
  final int series;
  final int repetitions;
  final String description;
  final double? weightKg;

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'series': series,
      'repetitions': repetitions,
      if (description.isNotEmpty) 'description': description,
      if (weightKg != null) 'weightKg': weightKg,
    };
  }

  factory ExportExercise.fromJson(Map<String, dynamic> json) {
    return ExportExercise(
      id: json['id'] as String?,
      title: json['title'] as String? ?? '',
      series: json['series'] as int? ?? 0,
      repetitions: json['repetitions'] as int? ?? 0,
      description: json['description'] as String? ?? '',
      weightKg: (json['weightKg'] as num?)?.toDouble(),
    );
  }
}
