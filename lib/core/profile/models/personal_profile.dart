class PersonalProfile {
  const PersonalProfile({
    this.ageYears,
    this.heightCm,
    this.bodyWeightKg,
  });

  final int? ageYears;
  final double? heightCm;
  final double? bodyWeightKg;

  static const empty = PersonalProfile();

  PersonalProfile copyWith({
    int? ageYears,
    double? heightCm,
    double? bodyWeightKg,
    bool clearAgeYears = false,
    bool clearHeightCm = false,
    bool clearBodyWeightKg = false,
  }) {
    return PersonalProfile(
      ageYears: clearAgeYears ? null : (ageYears ?? this.ageYears),
      heightCm: clearHeightCm ? null : (heightCm ?? this.heightCm),
      bodyWeightKg:
          clearBodyWeightKg ? null : (bodyWeightKg ?? this.bodyWeightKg),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (ageYears != null) 'ageYears': ageYears,
      if (heightCm != null) 'heightCm': heightCm,
      if (bodyWeightKg != null) 'bodyWeightKg': bodyWeightKg,
    };
  }

  static PersonalProfile fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) {
      return PersonalProfile.empty;
    }
    return PersonalProfile(
      ageYears: json['ageYears'] as int?,
      heightCm: (json['heightCm'] as num?)?.toDouble(),
      bodyWeightKg: (json['bodyWeightKg'] as num?)?.toDouble(),
    );
  }
}
