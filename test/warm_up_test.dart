import 'package:flutter_test/flutter_test.dart';

import 'package:life_fit/modules/calentamiento/models/warm_up_placement.dart';
import 'package:life_fit/modules/ejercicios/models/exercise_template.dart';
import 'package:life_fit/shared/models/routine_card.dart';
import 'package:life_fit/shared/models/routine_exercise_slot.dart';
import 'package:life_fit/shared/models/routine_stretching_slot.dart';
import 'package:life_fit/shared/utils/routine_resolver.dart';

void main() {
  test('RoutineCard conserva referencias de biblioteca', () {
    const card = RoutineCard(
      id: 'routine-1',
      title: 'MIÉRCOLES',
      description: 'TREN SUPERIOR',
      exerciseSlots: [
        RoutineExerciseSlot(slotId: 'slot-1', exerciseId: 'ex-1'),
      ],
      warmUpId: 'warm-1',
      warmUpPlacement: WarmUpPlacement.end,
      stretchingSlots: [
        RoutineStretchingSlot(slotId: 'str-slot-1', stretchingId: 'str-1'),
      ],
    );

    final decoded = RoutineCard.fromJson(card.toJson());

    expect(decoded.warmUpId, 'warm-1');
    expect(decoded.exerciseSlots.first.exerciseId, 'ex-1');
    expect(decoded.stretchingSlots.first.stretchingId, 'str-1');
  });

  test('resolveRoutine refleja cambios en biblioteca', () {
    var exercise = const ExerciseTemplate(
      id: 'ex-1',
      title: 'Press',
      series: 4,
      repetitions: 10,
    );

    const card = RoutineCard(
      id: 'routine-1',
      title: 'MIÉRCOLES',
      description: '',
      exerciseSlots: [
        RoutineExerciseSlot(slotId: 'slot-1', exerciseId: 'ex-1'),
      ],
    );

    var libraries = RoutineLibraries.fromLists(
      exercises: [exercise],
      stretchings: const [],
      warmUps: const [],
    );

    expect(resolveRoutine(card, libraries).exercises.first.series, 4);

    exercise = exercise.copyWith(series: 5);
    libraries = RoutineLibraries.fromLists(
      exercises: [exercise],
      stretchings: const [],
      warmUps: const [],
    );

    expect(resolveRoutine(card, libraries).exercises.first.series, 5);
  });
}
