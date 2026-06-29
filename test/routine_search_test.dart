import 'package:flutter_test/flutter_test.dart';

import 'package:life_fit/shared/models/checklist_item.dart';
import 'package:life_fit/shared/models/routine_card.dart';
import 'package:life_fit/shared/utils/routine_search.dart';

void main() {
  const routines = [
    RoutineCard(
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
    ),
    RoutineCard(
      id: 'routine-2',
      title: 'VIERNES',
      description: 'TREN INFERIOR',
      items: [
        ChecklistItem(
          id: 'item-2',
          title: 'Sentadilla',
          series: 4,
          repetitions: 8,
        ),
      ],
    ),
  ];

  test('query vacío devuelve todas las rutinas', () {
    expect(filterRoutineCards(routines, ''), routines);
    expect(filterRoutineCards(routines, '   '), routines);
  });

  test('filtra por título sin distinguir mayúsculas', () {
    final result = filterRoutineCards(routines, 'miér');

    expect(result, hasLength(1));
    expect(result.first.id, 'routine-1');
  });

  test('filtra por descripción', () {
    final result = filterRoutineCards(routines, 'inferior');

    expect(result, hasLength(1));
    expect(result.first.id, 'routine-2');
  });

  test('sin coincidencias devuelve lista vacía', () {
    expect(filterRoutineCards(routines, 'domingo'), isEmpty);
  });
}
