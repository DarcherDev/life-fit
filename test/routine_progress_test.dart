import 'package:flutter_test/flutter_test.dart';

import 'package:life_fit/modules/calentamiento/models/warm_up.dart';
import 'package:life_fit/shared/models/routine_card.dart';
import 'package:life_fit/shared/models/routine_exercise_slot.dart';
import 'package:life_fit/shared/models/routine_stretching_slot.dart';
import 'package:life_fit/shared/utils/routine_progress.dart';

void main() {
  test('calculateRoutineProgress cuenta calentamiento, estiramientos y ejercicios',
      () {
    const routine = RoutineCard(
      id: 'r1',
      title: 'Pierna',
      description: 'Fuerza',
      warmUpId: 'w1',
      stretchingSlots: [
        RoutineStretchingSlot(slotId: 's1', stretchingId: 'st1'),
        RoutineStretchingSlot(slotId: 's2', stretchingId: 'st2'),
      ],
      exerciseSlots: [
        RoutineExerciseSlot(slotId: 'e1', exerciseId: 'ex1'),
        RoutineExerciseSlot(slotId: 'e2', exerciseId: 'ex2'),
        RoutineExerciseSlot(slotId: 'e3', exerciseId: 'ex3'),
        RoutineExerciseSlot(slotId: 'e4', exerciseId: 'ex4'),
        RoutineExerciseSlot(slotId: 'e5', exerciseId: 'ex5'),
      ],
    );

    final summary = calculateRoutineProgress(
      routine: routine,
      completedItemIds: {
        warmUpProgressItemId,
        's1',
        's2',
        'e1',
      },
    );

    expect(summary.totalItems, 8);
    expect(summary.completedItems, 4);
    expect(summary.percent, 50);
    expect(summary.fraction, 0.5);
  });

  test('calculateRoutineProgress sin rutina devuelve cero', () {
    final summary = calculateRoutineProgress(
      routine: null,
      completedItemIds: {'e1'},
    );

    expect(summary.hasRoutine, isFalse);
    expect(summary.percent, 0);
  });
}
