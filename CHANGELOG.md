# Changelog

Todos los cambios notables de Life Fit se documentan en este archivo.

El formato sigue [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/) y el proyecto usa [Semantic Versioning](https://semver.org/lang/es/).

## [3.4.0] - 2026-08-07

**Build:** `3.4.0+21`

### Añadido
- **Importar / exportar rutinas** en JSON desde el drawer (perfil + rutinas denormalizadas; plantillas de biblioteca con upsert).
- **Reordenar por arrastre** ejercicios y estiramientos en Día de gym (orden persistido en la rutina).
- **Reordenar opciones del menú Home** por arrastre largo (orden en `home_menu_order`).
- **Icono de marca** Life Fit (calendario + mancuerna) en launcher (Android adaptativo, iOS, web, Windows, macOS) y en el header del drawer.

### Cambiado
- Seed de tema a verde menta alineado con el icono (`#7CB894`).
- Header del drawer: logo centrado (90 % del alto) sobre el color del menú, con divisor gris.
- Iconos launcher regenerados con margen seguro para evitar recorte en máscaras circulares.
- Tachado suave al completar un ítem antes de moverlo al final de la lista.

### Corregido
- El anillo de progreso de Home se actualiza al volver del Día de gym (navegación con `await`).

### Tests
- Cobertura de export/import JSON y del orden del menú Home.

---

## [2.6.2] - 2026-07-02

**Build:** `2.6.2+14`

### Cambiado
- **README:** una sola sección `Novedades de la release` (actualmente 2.6.0); historial completo solo en CHANGELOG.
- Regla **`/push`** actualizada: sustituir la sección de novedades en lugar de acumular bloques por versión.

---

## [2.6.1] - 2026-07-02

**Build:** `2.6.1+13`

### Añadido
- `release-notes-v2.0.0.md` versionado en el repositorio (notas de la release 2.0.0).

### Cambiado
- Regla Cursor **`/push`** actualizada: exige commitear `release-notes-vX.Y.Z.md`, recuperar archivos `release-notes-*.md` olvidados y usarlos en `gh release create`.

---

## [2.6.0] - 2026-07-02

**Build:** `2.6.0+12`

### Añadido
- **Biblioteca base al instalar:** catálogo inicial de ejercicios, estiramientos y calentamientos (`default_library_catalog`, `default_library_seed`).
- **Día de gym:** editar series, repeticiones y peso del ejercicio desde la sesión; reemplazar ejercicio, estiramiento o calentamiento con picker de biblioteca.
- **Checklist:** marcar ítem completado tocando toda la fila (no solo el checkbox).
- **Ajustes y Mi proceso:** tema, idioma y unidad de peso en diálogo modal; registro de edad, altura y peso corporal (`PersonalProfileService`).
- **Búsqueda en bibliotecas:** widget reutilizable `LibrarySearchableList` con filtrado y creación desde búsqueda sin coincidencias.
- **Home:** anillo de progreso de la rutina de hoy con enlace directo al día de gym.
- **Licencia:** archivo `LICENSE` (source-available), diálogo Acerca de con versión (`package_info_plus`) y pantalla de licencia.

### Cambiado
- Drawer simplificado: accesos a Ajustes, Mi proceso y Acerca de en lugar de controles inline.
- Mejoras de UX en preview de rutina y compositor (alineadas con flujos del día de gym).

### Tests
- Cobertura para seed de biblioteca, búsqueda en bibliotecas, perfil personal y progreso de rutina.

---

## [2.0.0] - 2026-07-02

**Build:** `2.0.0+6`

### Cambiado
- **Persistencia SOLID:** `LocalStorageService` sustituido por capa de repositorios (`AppRepositories`) con interfaces por dominio (ejercicios, estiramientos, calentamiento, rutinas, asignaciones, progreso).
- Pantallas y flujos migrados a dependencias tipadas; `RoutineAssignSheet` recibe la lista de rutinas como parámetro.
- `resolveTodayGymEntry` acepta repositorios de asignación y rutinas en lugar del singleton monolítico.
- Regla Cursor **`diseno-reutilizable`** ampliada con principios SOLID (SRP, OCP, LSP, ISP, DIP).
- Regla Cursor **`/push`** actualizada: versionamiento en `/commit`; release con APK compilado adjunto.

### Eliminado
- Código muerto: `template_search.dart`, `checklist_l10n.dart`, `warm_up_form_section.dart`, constante `routineDayModuleOrder` sin uso.

---

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

[2.6.2]: https://github.com/DarcherDev/life-fit/releases/tag/v2.6.2
[2.6.1]: https://github.com/DarcherDev/life-fit/releases/tag/v2.6.1
[2.6.0]: https://github.com/DarcherDev/life-fit/releases/tag/v2.6.0
[2.0.0]: https://github.com/DarcherDev/life-fit/releases/tag/v2.0.0
[1.3.0]: https://github.com/DarcherDev/life-fit/releases/tag/v1.3.0
[1.2.0]: https://github.com/DarcherDev/life-fit/releases/tag/v1.2.0
[1.1.0]: https://github.com/DarcherDev/life-fit/releases/tag/v1.1.0
