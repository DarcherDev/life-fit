# Changelog

Todos los cambios notables de Life Fit se documentan en este archivo.

El formato sigue [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/) y el proyecto usa [Semantic Versioning](https://semver.org/lang/es/).

## [1.3.0] - 2026-06-29

**Build:** `1.3.0+5`

### Añadido
- Reglas Cursor **`/pull`** (fetch, pull y merge de `origin/develop` sin push) y **`/push`** (auditoría, CHANGELOG, tag y release en GitHub).

### Cambiado
- Regla **`/commit`** ampliada: mensaje en una línea (≤ 72 caracteres), análisis previo obligatorio y bump de versión en cada commit local.

---

## [1.2.0] - 2026-06-27

**Build:** `1.2.0+3`

### Añadido
- Localización **español / inglés** con `flutter gen-l10n` y selector persistente en el drawer.
- Reorganización en **módulos** (`ejercicios`, `estiramientos`, `calentamiento`, `rutinas`, `planificador`, `dia_gym`).
- **Modo oscuro** y selector de tema (claro / oscuro / sistema) persistente.
- **Bibliotecas reutilizables** de ejercicios, estiramientos y calentamientos con CRUD independiente.
- **Compositor de rutina** por referencias (`RoutineExerciseSlot`, `RoutineStretchingSlot`, `warmUpId`).
- Helper `resolveRoutine` para unir rutina + bibliotecas en preview y día de gym.
- **Migración automática** one-shot desde rutinas con ítems embebidos al modelo por referencias.
- **Drawer de ajustes** centralizado (tema, idioma, unidad de peso kg/lb).
- **Peso opcional** por ejercicio (`weightKg`), editable desde biblioteca, compositor y día de gym.
- Flujo **crear desde biblioteca vacía** al asignar ítems en el compositor (`creationMode`).
- Botón **crear ítem** en `LibraryPickerSheet` cuando la búsqueda no tiene coincidencias.
- Tests: migración, resolver, peso, flujo de creación en biblioteca vacía, picker sin coincidencias.

### Cambiado
- **Home** ampliado a 6 opciones; Planificador como tercera opción (tras Rutina).
- Las rutinas guardan referencias por ID; editar un ítem en biblioteca actualiza todas las rutinas que lo usan.
- No se puede borrar un ítem de biblioteca si alguna rutina lo referencia.
- Calentamiento opcional por rutina con ubicación inicio/final (no por plantilla).

### Corregido
- Crash al editar peso desde rutina o día de gym (`_dependents.isEmpty`); diálogo como `StatefulWidget`.
- Flujo bloqueado al asignar desde biblioteca vacía (solo SnackBar → apertura automática del formulario).
- Visibilidad del FAB en biblioteca vacía con `creationMode`.

---

## [1.1.0] - 2026-06-27

**Build:** `1.1.0+2`

### Añadido
- Flujo inteligente **Día de gym** (`TodayGymCoordinator`):
  - Rutina ya asignada → abre la sesión del día.
  - Rutinas existentes sin asignar hoy → bottom sheet para elegir y asignar.
  - Sin rutinas → formulario de creación con auto-asignación al guardar.
- Enum y función pura `resolveTodayGymEntry` para decidir la intención de entrada.
- Bottom sheet de asignación reutilizable (`RoutineAssignSheet`) usado desde Planificador, Día de gym y cambio de rutina en sesión.
- Buscador con filtrado en tiempo real por título y descripción de rutina.
- Lista scrolleable en el sheet (altura fija al 50% de pantalla).
- Utilidad `filterRoutineCards` en `lib/utils/routine_search.dart`.
- Tests unitarios: `today_gym_entry_test.dart`, `routine_search_test.dart`.

### Cambiado
- `AppNavigation.openTodayGym` delega al coordinador en lugar de navegar siempre a pantalla vacía.
- `RoutineFormScreen` acepta `autoAssignDateKey` para asignar al guardar y reemplazar el stack por `DayRoutineScreen`.
- `DayRoutineScreen`: eliminado el estado vacío orientado a “ir al planificador” para hoy (el coordinador lo resuelve antes).
- `PlannerScreen` usa el sheet compartido en lugar de lógica duplicada.

### Corregido
- Avisos de linter por uso de `BuildContext` tras gaps asíncronos en el coordinador.

---

## [1.0.0] - 2026-06-27

**Build:** `1.0.0+1`

### Añadido
- App nativa Flutter para gestión de rutinas de gimnasio.
- **Home** con tres accesos: Día de gym, Rutina y Planificador.
- **Rutina:** CRUD de tarjetas con ejercicios (series × repeticiones).
- **Planificador:** calendario mensual con asignación de una rutina por día.
- **Día de gym:** checklist interactiva, progreso por día y confetti al completar.
- Persistencia local con `shared_preferences`.
- Modelos: `RoutineCard`, `ChecklistItem`, `DayAssignment`, `DayProgress`.
- Localización en español para fechas (`intl`, `flutter_localizations`).
- Tests iniciales de almacenamiento y widget de Home.

[1.3.0]: https://github.com/DarcherDev/life-fit/releases/tag/v1.3.0
[1.2.0]: https://github.com/DarcherDev/life-fit/releases/tag/v1.2.0
[1.1.0]: https://github.com/DarcherDev/life-fit/releases/tag/v1.1.0
