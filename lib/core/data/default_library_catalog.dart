import 'package:life_fit/modules/calentamiento/models/warm_up_template.dart';
import 'package:life_fit/modules/ejercicios/models/exercise_template.dart';
import 'package:life_fit/modules/estiramiento/models/stretching_template.dart';

/// Plantillas incluidas en instalaciones nuevas (bibliotecas vacías).
class DefaultLibraryCatalog {
  DefaultLibraryCatalog._();

  static const List<ExerciseTemplate> exerciseTemplates = [
    ExerciseTemplate(
      id: 'seed-ex-001',
      title: 'Sentadilla Copa',
      series: 4,
      repetitions: 12,
      description: '10-12 reps · 1 mancuerna',
    ),
    ExerciseTemplate(
      id: 'seed-ex-002',
      title: 'Zancadas',
      series: 3,
      repetitions: 10,
      description: 'Por pierna',
    ),
    ExerciseTemplate(
      id: 'seed-ex-003',
      title: 'Puente de Glúteo',
      series: 4,
      repetitions: 12,
      description: 'Suelo',
    ),
    ExerciseTemplate(
      id: 'seed-ex-004',
      title: 'P. Muerto Rumano',
      series: 3,
      repetitions: 12,
      description: 'Mancuernas',
    ),
    ExerciseTemplate(
      id: 'seed-ex-005',
      title: 'Plancha Abdominal',
      series: 3,
      repetitions: 60,
      description: '45-60 seg',
    ),
    ExerciseTemplate(
      id: 'seed-ex-006',
      title: 'Dominadas Clásicas',
      series: 4,
      repetitions: 1,
      description: 'Hasta el fallo · agarre prono',
    ),
    ExerciseTemplate(
      id: 'seed-ex-007',
      title: 'Press de Banca Plana',
      series: 4,
      repetitions: 10,
      description: '8-10 reps',
    ),
    ExerciseTemplate(
      id: 'seed-ex-008',
      title: 'Remo con Barra',
      series: 4,
      repetitions: 10,
    ),
    ExerciseTemplate(
      id: 'seed-ex-009',
      title: 'Press Militar Sentado',
      series: 3,
      repetitions: 10,
      description: 'Mancuernas',
    ),
    ExerciseTemplate(
      id: 'seed-ex-010',
      title: 'Press Francés',
      series: 3,
      repetitions: 12,
      description: 'Sustituye copa',
    ),
    ExerciseTemplate(
      id: 'seed-ex-011',
      title: 'Sentadilla Búlgara',
      series: 3,
      repetitions: 10,
      description: '8-10 reps por pierna',
    ),
    ExerciseTemplate(
      id: 'seed-ex-012',
      title: 'Peso Muerto Sumo',
      series: 4,
      repetitions: 10,
      description: '1 mancuerna',
    ),
    ExerciseTemplate(
      id: 'seed-ex-013',
      title: 'Supermans (Espalda)',
      series: 3,
      repetitions: 15,
      description: 'Suelo',
    ),
    ExerciseTemplate(
      id: 'seed-ex-014',
      title: 'Elevación Talones',
      series: 4,
      repetitions: 15,
      description: 'De pie',
    ),
    ExerciseTemplate(
      id: 'seed-ex-015',
      title: 'Dead Bug',
      series: 3,
      repetitions: 12,
      description: 'Por lado',
    ),
    ExerciseTemplate(
      id: 'seed-ex-016',
      title: 'Dominadas Supinas',
      series: 4,
      repetitions: 1,
      description: 'Hasta el fallo · chin-ups',
    ),
    ExerciseTemplate(
      id: 'seed-ex-017',
      title: 'Flexiones de pecho',
      series: 4,
      repetitions: 1,
      description: 'Hasta el fallo',
    ),
    ExerciseTemplate(
      id: 'seed-ex-018',
      title: 'Remo Manc. 1 Mano',
      series: 3,
      repetitions: 10,
      description: 'Por brazo',
    ),
    ExerciseTemplate(
      id: 'seed-ex-019',
      title: 'Vuelos Laterales',
      series: 3,
      repetitions: 15,
      description: 'Poco peso',
    ),
    ExerciseTemplate(
      id: 'seed-ex-020',
      title: 'Curl Martillo',
      series: 3,
      repetitions: 12,
      description: 'Por brazo',
    ),
    ExerciseTemplate(
      id: 'seed-ex-021',
      title: 'Press Banca Estrecho',
      series: 3,
      repetitions: 10,
    ),
    ExerciseTemplate(
      id: 'seed-ex-022',
      title: 'Sentadilla Libre / Smith',
      series: 4,
      repetitions: 12,
      description: '10-12 reps',
    ),
    ExerciseTemplate(
      id: 'seed-ex-023',
      title: 'Prensa de Piernas',
      series: 3,
      repetitions: 12,
    ),
    ExerciseTemplate(
      id: 'seed-ex-024',
      title: 'Zancadas (Mancuernas)',
      series: 3,
      repetitions: 10,
      description: 'Por pierna',
    ),
    ExerciseTemplate(
      id: 'seed-ex-025',
      title: 'Extensión de Piernas',
      series: 3,
      repetitions: 15,
    ),
    ExerciseTemplate(
      id: 'seed-ex-026',
      title: 'Elevación de Talones',
      series: 4,
      repetitions: 20,
      description: '15-20 reps',
    ),
    ExerciseTemplate(
      id: 'seed-ex-027',
      title: 'Progresión Push-ups',
      series: 4,
      repetitions: 1,
      description: 'Hasta el fallo · superficie alta',
    ),
    ExerciseTemplate(
      id: 'seed-ex-028',
      title: 'Jalón al Pecho Polea',
      series: 3,
      repetitions: 12,
    ),
    ExerciseTemplate(
      id: 'seed-ex-029',
      title: 'Press Militar Sentada',
      series: 3,
      repetitions: 12,
      description: '10-12 reps',
    ),
    ExerciseTemplate(
      id: 'seed-ex-030',
      title: 'Remo Apoyo Banco',
      series: 3,
      repetitions: 10,
      description: 'Por brazo',
    ),
    ExerciseTemplate(
      id: 'seed-ex-031',
      title: 'Plancha Abdominal',
      series: 3,
      repetitions: 45,
      description: '30-45 seg',
    ),
    ExerciseTemplate(
      id: 'seed-ex-032',
      title: 'Peso Muerto Rumano',
      series: 4,
      repetitions: 12,
      description: '10-12 reps · mancuernas',
    ),
    ExerciseTemplate(
      id: 'seed-ex-033',
      title: 'Hip Thrust',
      series: 4,
      repetitions: 10,
    ),
    ExerciseTemplate(
      id: 'seed-ex-034',
      title: 'Curl Isquios (Máquina)',
      series: 3,
      repetitions: 15,
      description: '12-15 reps',
    ),
    ExerciseTemplate(
      id: 'seed-ex-035',
      title: 'Máquina Abducción',
      series: 3,
      repetitions: 15,
    ),
    ExerciseTemplate(
      id: 'seed-ex-036',
      title: 'Press Pecho Mancuernas',
      series: 4,
      repetitions: 12,
      description: '10-12 reps',
    ),
    ExerciseTemplate(
      id: 'seed-ex-037',
      title: 'Remo Sentado Polea Baja',
      series: 3,
      repetitions: 12,
    ),
    ExerciseTemplate(
      id: 'seed-ex-038',
      title: 'Elevación Lateral',
      series: 3,
      repetitions: 15,
      description: 'Prioriza técnica',
    ),
    ExerciseTemplate(
      id: 'seed-ex-039',
      title: 'Curl Bíceps Mancuernas',
      series: 3,
      repetitions: 12,
    ),
    ExerciseTemplate(
      id: 'seed-ex-040',
      title: 'Extensión Tríceps Polea',
      series: 3,
      repetitions: 12,
    ),
    ExerciseTemplate(
      id: 'seed-ex-041',
      title: 'Crunch / Elevación Piernas',
      series: 3,
      repetitions: 15,
    ),
  ];

  static const List<WarmUpTemplate> warmUpTemplates = [
    WarmUpTemplate(
      id: 'seed-wu-001',
      description: 'Bicicleta',
      minutes: 10,
    ),
    WarmUpTemplate(
      id: 'seed-wu-002',
      description: 'Caminadora',
      minutes: 10,
    ),
    WarmUpTemplate(
      id: 'seed-wu-003',
      description: 'Elíptica',
      minutes: 10,
    ),
  ];

  static const List<StretchingTemplate> stretchingTemplates = [
    StretchingTemplate(
      id: 'seed-st-001',
      description: 'Gato-Camello',
      repetitions: 15,
    ),
    StretchingTemplate(
      id: 'seed-st-002',
      description: 'Bird-Dog',
      repetitions: 10,
    ),
    StretchingTemplate(
      id: 'seed-st-003',
      description: 'Rotaciones de brazos',
      repetitions: 10,
    ),
  ];
}
