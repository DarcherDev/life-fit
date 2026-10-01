import 'package:flutter_test/flutter_test.dart';

import 'package:life_fit/modules/calentamiento/models/warm_up_placement.dart';
import 'package:life_fit/modules/calentamiento/models/warm_up_template.dart';
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
      startWarmUpId: 'warm-1',
      endWarmUpId: 'warm-2',
      stretchingSlots: [
        RoutineStretchingSlot(slotId: 'str-slot-1', stretchingId: 'str-1'),
      ],
    );

    final decoded = RoutineCard.fromJson(card.toJson());

    expect(decoded.startWarmUpId, 'warm-1');
    expect(decoded.endWarmUpId, 'warm-2');
    expect(decoded.exerciseSlots.first.exerciseId, 'ex-1');
    expect(decoded.stretchingSlots.first.stretchingId, 'str-1');
  });

  test('RoutineCard antigua con warmUpPlacement end se lee como final', () {
    final decoded = RoutineCard.fromJson({
      'id': 'routine-1',
      'title': 'Pierna',
      'description': '',
      'exerciseSlots': [
        {'slotId': 'slot-1', 'exerciseId': 'ex-1'},
      ],
      'warmUpId': 'warm-1',
      'warmUpPlacement': 'end',
    });

    expect(decoded.startWarmUpId, isNull);
    expect(decoded.endWarmUpId, 'warm-1');
    expect(decoded.toJson().containsKey('warmUpId'), isFalse);
    expect(decoded.toJson()['endWarmUpId'], 'warm-1');
  });

  test('RoutineCard antigua sin warmUpPlacement se lee como inicio', () {
    final decoded = RoutineCard.fromJson({
      'id': 'routine-1',
      'title': 'Pierna',
      'description': '',
      'warmUpId': 'warm-1',
    });

    expect(decoded.startWarmUpId, 'warm-1');
    expect(decoded.endWarmUpId, isNull);
  });

  test('withWarmUp asigna y quita por posición', () {
    const card = RoutineCard(id: 'r1', title: 'A', description: '');

    final withBoth = card
        .withWarmUp(WarmUpPlacement.start, 'warm-1')
        .withWarmUp(WarmUpPlacement.end, 'warm-2');
    expect(withBoth.warmUpIdFor(WarmUpPlacement.start), 'warm-1');
    expect(withBoth.warmUpIdFor(WarmUpPlacement.end), 'warm-2');
    expect(withBoth.referencesWarmUp('warm-2'), isTrue);

    final withoutStart = withBoth.withWarmUp(WarmUpPlacement.start, null);
    expect(withoutStart.startWarmUpId, isNull);
    expect(withoutStart.endWarmUpId, 'warm-2');
    expect(withoutStart.hasWarmUp, isTrue);
  });

  test('resolveRoutine resuelve calentamiento inicial y final', () {
    const card = RoutineCard(
      id: 'r1',
      title: 'A',
      description: '',
      startWarmUpId: 'wu-bike',
      endWarmUpId: 'wu-missing',
    );
    final libraries = RoutineLibraries.fromLists(
      exercises: const [],
      stretchings: const [],
      warmUps: const [
        WarmUpTemplate(id: 'wu-bike', description: 'Bicicleta', minutes: 10),
      ],
    );

    final resolved = resolveRoutine(card, libraries);

    expect(resolved.startWarmUp!.description, 'Bicicleta');
    expect(resolved.endWarmUp!.isMissing, isTrue);
    expect(resolved.hasMissingItems, isTrue);
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
