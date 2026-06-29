# Life Fit

App personal para gestionar rutinas de gimnasio: mantén bibliotecas reutilizables de ejercicios, estiramientos y calentamientos; compón rutinas por referencia; asígnalas en un calendario y marca tu progreso día a día.

**Versión actual:** `1.3.0+4`  
**Repositorio:** [github.com/DarcherDev/life-fit](https://github.com/DarcherDev/life-fit)

## Para qué sirve

Life Fit te ayuda a organizar tus entrenamientos sin depender de hojas de cálculo ni notas sueltas. Defines ítems una vez en bibliotecas, los combinas en rutinas, las programas en el planificador y cada día entras a tu sesión con una checklist interactiva.

## Funciones principales

### Día de gym
- Acceso inteligente desde Home según el estado del día:
  - Si ya hay rutina asignada → abre la sesión directamente.
  - Si hay rutinas pero hoy no está asignada → selector para elegir y asignar.
  - Si no hay rutinas creadas → formulario para crear una y asignarla al instante.
- Checklist por ejercicio, estiramiento y calentamiento (datos resueltos desde bibliotecas).
- Confetti al completar la rutina o pulsar **Terminar rutina**.

### Bibliotecas (Ejercicios, Estiramientos, Calentamiento)
- CRUD independiente para cada tipo de ítem reutilizable.
- **Ejercicio:** título, series, repeticiones, descripción opcional, **peso opcional** (kg/lb según ajustes).
- **Estiramiento:** descripción y repeticiones.
- **Calentamiento:** descripción y minutos.
- Editar un ítem en biblioteca actualiza todas las rutinas que lo referencian.
- No se puede borrar un ítem si alguna rutina lo usa.
- Desde el compositor: si la biblioteca está vacía o la búsqueda no tiene resultados, abre creación y asigna el ítem nuevo al volver.

### Rutina (compositor)
- Crear, editar y eliminar rutinas armadas desde las bibliotecas.
- Cada rutina incluye nombre, descripción opcional, ejercicios asignados, estiramientos y calentamiento opcional.
- La ubicación del calentamiento (inicio o final) es por rutina, no por plantilla.
- Vista previa resuelta antes de guardar.

### Planificador
- Calendario mensual para asignar una rutina por día.
- Bottom sheet compartido con búsqueda y scroll para elegir rutina.
- Opción de quitar la asignación de un día.

### Ajustes (drawer)
- Tema claro, oscuro o seguir el sistema.
- Idioma español / inglés.
- Unidad de peso: kilogramos o libras (los datos se guardan siempre en kg).

### Almacenamiento
- Datos guardados localmente en el dispositivo (`shared_preferences`).
- Migración automática one-shot desde el formato antiguo (ítems embebidos en rutinas).
- Sin cuenta ni conexión a internet requerida.

## Modelo de datos

Las rutinas guardan **referencias por ID**, no copias de los ítems.

| Clave | Contenido |
|-------|-----------|
| `exercise_templates` | Biblioteca de ejercicios (`ExerciseTemplate`) |
| `stretching_templates` | Biblioteca de estiramientos (`StretchingTemplate`) |
| `warm_up_templates` | Biblioteca de calentamientos (`WarmUpTemplate`) |
| `routine_cards` | Rutinas con slots (`RoutineExerciseSlot`, `RoutineStretchingSlot`, `warmUpId`) |
| `day_assignments` | Rutina asignada por fecha |
| `day_progress` | Ítems completados por `slotId` |

El helper `resolveRoutine` une rutina + bibliotecas en runtime para preview y día de gym.

## Tecnologías

| Tecnología | Versión / detalle |
|------------|-------------------|
| **Flutter** | 3.7.7 (stable) |
| **Dart** | >= 2.19.4 < 3.0.0 |
| **Android minSdk** | 19 |
| **Android targetSdk** | 33 (vía Flutter SDK) |
| **JDK (build)** | 17 |

### Dependencias principales

| Paquete | Uso |
|---------|-----|
| `shared_preferences` | Persistencia local (rutinas, asignaciones, progreso) |
| `table_calendar` | Calendario del planificador |
| `intl` + `flutter_localizations` | Fechas y textos en español |
| `confetti` | Animación al completar rutina |
| `uuid` | Identificadores únicos |

## Estructura del proyecto

```
lib/
├── core/
│   ├── home/              # Home con 6 opciones
│   ├── navigation/        # Navegación centralizada
│   ├── services/          # LocalStorage, migración, tema, locale, peso
│   └── widgets/           # AppDrawer, AppScaffold
├── modules/
│   ├── calentamiento/     # Biblioteca de calentamientos
│   ├── dia_gym/           # Día de gym y coordinadores
│   ├── ejercicios/        # Biblioteca de ejercicios
│   ├── estiramiento/      # Biblioteca de estiramientos
│   ├── planificador/      # Calendario de asignaciones
│   └── rutinas/           # Compositor de rutinas + preview
└── shared/
    ├── models/            # RoutineCard, slots, ResolvedRoutine
    ├── utils/             # routine_resolver, búsqueda
    └── widgets/           # LibraryPickerSheet, RoutineAssignSheet
```

## Versionado

El número de versión vive en `pubspec.yaml`:

```yaml
version: 1.3.0+4
#        │     └── build number (versionCode Android, debe subir en cada APK)
#        └── versión visible (versionName)
```

Convención:
- **MAJOR** (`2.0.0`) — cambios grandes o incompatibles.
- **MINOR** (`1.1.0`) — nuevas funciones.
- **PATCH** (`1.1.1`) — correcciones.
- **+N** — número de build; siempre incrementar al generar un APK instalable.

Historial detallado en [CHANGELOG.md](CHANGELOG.md).

## Novedades de la release 1.2.0

Respecto a la `1.1.0+2`:

- **Localización** español e inglés con selector en el drawer.
- **Modo oscuro** y tema persistente (claro / oscuro / sistema).
- **Bibliotecas reutilizables** y compositor de rutina por referencias, con migración automática.
- **Drawer de ajustes:** tema, idioma y unidad de peso (kg/lb).
- **Peso opcional** por ejercicio, editable en biblioteca, compositor y día de gym.
- **Flujos sin datos:** crear desde biblioteca vacía o desde búsqueda sin coincidencias en el picker.
- **Correcciones:** crash al editar peso; FAB y navegación en bibliotecas vacías.

## Novedades de la release 1.1.0

Respecto a la `1.0.0+1`:

- **Bibliotecas reutilizables:** ejercicios, estiramientos y calentamientos con CRUD independiente.
- **Compositor de rutina:** arma rutinas por referencia (sin reescribir series/reps en cada rutina).
- **Home ampliado:** Día de gym, Rutina, Planificador, Ejercicios, Estiramientos y Calentamiento.
- **Migración automática** desde rutinas con ítems embebidos al nuevo modelo por referencias.
- **Flujo inteligente Día de gym:** el coordinador decide si abrir la sesión, mostrar el selector o crear una rutina nueva.
- **Bottom sheet de asignación mejorado:** media pantalla, lista con scroll y buscador por título/descripción.
- **Tests** para migración, resolver, borrado en uso, entrada de día de gym y filtrado de búsqueda.

## Cómo compilar

Requisitos: Flutter 3.7.7, JDK 17.

```bash
flutter pub get
flutter test
flutter build apk --release
```

El APK queda en `build/app/outputs/flutter-apk/app-release.apk`.

En Windows con JDK 17 explícito:

```powershell
$env:JAVA_HOME="C:\Program Files\Microsoft\jdk-17.0.19.10-hotspot"
flutter build apk --release
```

## Licencia

Proyecto personal. Uso libre dentro del repositorio del autor.
