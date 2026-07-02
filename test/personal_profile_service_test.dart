import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:life_fit/core/profile/models/personal_profile.dart';
import 'package:life_fit/core/services/personal_profile_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await PersonalProfileService.instance.init();
  });

  test('guarda y restaura perfil personal', () async {
    const profile = PersonalProfile(
      ageYears: 28,
      heightCm: 175,
      bodyWeightKg: 72.5,
    );

    await PersonalProfileService.instance.saveProfile(profile);
    await PersonalProfileService.instance.init();

    final restored = PersonalProfileService.instance.profile;
    expect(restored.ageYears, 28);
    expect(restored.heightCm, 175);
    expect(restored.bodyWeightKg, 72.5);
  });
}
