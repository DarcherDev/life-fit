import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:life_fit/core/home/home_menu_option.dart';
import 'package:life_fit/core/services/home_menu_order_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await HomeMenuOrderService.instance.init();
  });

  test('por defecto usa el orden estándar', () {
    expect(
      HomeMenuOrderService.instance.order,
      HomeMenuOption.defaultOrder,
    );
  });

  test('reordenar persiste y normaliza opciones faltantes', () async {
    await HomeMenuOrderService.instance.reorder(0, 3);

    expect(HomeMenuOrderService.instance.order.first, HomeMenuOption.routines);
    expect(
      HomeMenuOrderService.instance.order[2],
      HomeMenuOption.gymDay,
    );

    SharedPreferences.setMockInitialValues({
      'home_menu_order': ['planner', 'gymDay', 'unknown'],
    });
    await HomeMenuOrderService.instance.init();

    final order = HomeMenuOrderService.instance.order;
    expect(order.first, HomeMenuOption.planner);
    expect(order[1], HomeMenuOption.gymDay);
    expect(order, containsAll(HomeMenuOption.defaultOrder));
    expect(order.length, HomeMenuOption.defaultOrder.length);
  });
}
