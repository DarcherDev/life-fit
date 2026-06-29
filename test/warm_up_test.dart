import 'package:flutter_test/flutter_test.dart';

import 'package:life_fit/modules/calentamiento/models/warm_up.dart';
import 'package:life_fit/modules/calentamiento/models/warm_up_placement.dart';
import 'package:life_fit/shared/models/checklist_item.dart';
import 'package:life_fit/shared/models/routine_card.dart';

void main() {
  test('WarmUp serializa y deserializa correctamente', () {
    const warmUp = WarmUp(description: 'Caminadora', minutes: 10);

    final decoded = WarmUp.fromJson(warmUp.toJson());

    expect(decoded.description, 'Caminadora');
    expect(decoded.minutes, 10);
  });

  test('RoutineCard conserva calentamiento y ubicación', () {
    const card = RoutineCard(
      id: 'routine-1',
      title: 'MIÉRCOLES',
      description: 'TREN SUPERIOR',
      items: [
        ChecklistItem(
          id: 'item-1',
          title: 'Press',
          series: 4,
          repetitions: 10,
        ),
      ],
      warmUp: WarmUp(description: 'Bici estática', minutes: 8),
      warmUpPlacement: WarmUpPlacement.end,
    );

    final decoded = RoutineCard.fromJson(card.toJson());

    expect(decoded.warmUp?.description, 'Bici estática');
    expect(decoded.warmUp?.minutes, 8);
    expect(decoded.warmUpPlacement, WarmUpPlacement.end);
  });

  test('RoutineCard sin calentamiento sigue siendo compatible', () {
    const legacyJson = {
      'id': 'routine-1',
      'title': 'MIÉRCOLES',
      'description': 'TREN SUPERIOR',
      'items': [
        {
          'id': 'item-1',
          'title': 'Press',
          'series': 4,
          'repetitions': 10,
        },
      ],
    };

    final decoded = RoutineCard.fromJson(legacyJson);

    expect(decoded.warmUp, isNull);
    expect(decoded.warmUpPlacement, WarmUpPlacement.start);
  });
}
