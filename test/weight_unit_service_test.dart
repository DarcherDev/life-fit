import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:life_fit/core/services/weight_unit_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await WeightUnitService.instance.init();
  });

  test('por defecto usa kilogramos', () {
    expect(WeightUnitService.instance.unit, WeightUnit.kg);
  });

  test('persiste preferencia de libras', () async {
    await WeightUnitService.instance.setUnit(WeightUnit.lb);
    expect(WeightUnitService.instance.unit, WeightUnit.lb);

    SharedPreferences.setMockInitialValues({'app_weight_unit': 'lb'});
    await WeightUnitService.instance.init();
    expect(WeightUnitService.instance.unit, WeightUnit.lb);
  });
}
