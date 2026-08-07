# Life Fit

App personal para gestionar rutinas de gimnasio: mantén bibliotecas reutilizables de ejercicios, estiramientos y calentamientos; compón rutinas por referencia; asígnalas en un calendario y marca tu progreso día a día.

**Versión actual:** `3.0.2+17`  
**Repositorio:** [github.com/DarcherDev/life-fit](https://github.com/DarcherDev/life-fit)

## Para qué sirve

Life Fit te ayuda a organizar tus entrenamientos sin depender de hojas de cálculo ni notas sueltas. Defines ítems una vez en bibliotecas, los combinas en rutinas, las programas en el planificador y cada día entras a tu sesión con una checklist interactiva.

## Funciones principales

### Home
- Anillo de progreso de la rutina de hoy (ítems completados / total) con acceso al día de gym.
- Acceso inteligente al día de gym según el estado del día (rutina asignada, selector o creación).

### Día de gym
- Acceso inteligente desde Home según el estado del día:
  - Si ya hay rutina asignada → abre la sesión directamente.
  - Si hay rutinas pero hoy no está asignada → selector para elegir y asignar.
  - Si no hay rutinas creadas → formulario para crear una y asignarla al instante.
- Checklist por ejercicio, estiramiento y calentamiento (datos resueltos desde bibliotecas).
- Marcar ítem tocando toda la fila del checklist.
- Editar series, repeticiones y peso del ejercicio en la sesión.
- Reemplazar ejercicio, estiramiento o calentamiento por otro de la biblioteca.
- Confetti al completar la rutina o pulsar **Terminar rutina**.

### Bibliotecas (Ejercicios, Estiramientos, Calentamiento)
- CRUD independiente para cada tipo de ítem reutilizable.
- **Catálogo inicial** al instalar la app por primera vez.
- **Buscador** con filtrado en tiempo real y botón para crear ítem desde la búsqueda.
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
- **Ajustes** en diálogo modal: tema claro, oscuro o seguir el sistema; idioma español / inglés; unidad de peso kg/lb.
- **Mi proceso:** edad, altura y peso corporal persistentes en el dispositivo.
- **Acerca de:** versión de la app y enlace a la licencia.

### Almacenamiento
- Datos guardados localmente en el dispositivo (`shared_preferences`).
- Capa de repositorios (`AppRepositories`) con interfaces por dominio; implementaciones en `lib/core/repositories/local/`.
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
| `personal_profile` | Edad, altura y peso corporal del usuario |

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
| `package_info_plus` | Versión de la app en Acerca de |

## Estructura del proyecto

```
lib/
├── core/
│   ├── about/             # Licencia y diálogo Acerca de
│   ├── home/              # Home con anillo de progreso y 6 opciones
│   ├── navigation/        # Navegación centralizada
│   ├── profile/           # Mi proceso (perfil personal)
│   ├── repositories/      # Interfaces y persistencia local (SOLID)
│   ├── services/          # Migración, tema, locale, peso, perfil
│   ├── settings/          # Panel de ajustes (diálogo)
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
    └── widgets/           # LibraryPickerSheet, LibrarySearchableList, RoutineAssignSheet
```

## Versionado

El número de versión vive en `pubspec.yaml`:

```yaml
version: 3.0.2+17
#        │     └── build number (versionCode Android, debe subir en cada APK)
#        └── versión visible (versionName)
```

Convención:
- **MAJOR** (`2.0.0`) — cambios grandes o incompatibles.
- **MINOR** (`1.1.0`) — nuevas funciones.
- **PATCH** (`1.1.1`) — correcciones.
- **+N** — número de build; siempre incrementar al generar un APK instalable.

Historial detallado en [CHANGELOG.md](CHANGELOG.md).

## Novedades de la release 2.6.0

Respecto a la `2.0.0+6`:

- **Biblioteca base** al instalar con ejercicios, estiramientos y calentamientos de ejemplo.
- **Día de gym ampliado:** editar series/reps/peso, reemplazar ítems y marcar completado tocando toda la fila.
- **Búsqueda en bibliotecas** con creación desde búsqueda sin coincidencias.
- **Ajustes y Mi proceso** en diálogos modales; anillo de progreso en Home.
- **Licencia** source-available y diálogo Acerca de con versión de la app.

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

Copyright © 2026 Daniel Aristizabal (DarcherDev). Ver [LICENSE](LICENSE).

El código es **público y modificable** (puedes estudiarlo, usarlo, compartirlo y crear derivados), con estas condiciones:

- **Gratuito siempre:** no se permite cobrar, suscripciones, compras in-app ni publicidad.
- **Sin tiendas de apps por terceros:** nadie excepto el autor puede publicar el proyecto (o un fork) en App Store, Google Play u otras tiendas similares.
- **Atribución y aviso de cambios** en cualquier redistribución.
- **Sin uso del nombre o marca "Life Fit"** para sugerir que un fork es oficial.
- **Sin garantía:** el software se ofrece «tal cual»; el autor no responde por daños derivados del uso, incluido código alterado por terceros con fines ilícitos.

> **Nota:** Esta licencia es *source-available* con restricciones de uso no comercial. No es una licencia «open source» según la [Open Source Initiative](https://opensource.org/) (MIT, Apache, GPL, etc.), porque prohíbe monetización y publicación en tiendas por terceros. El autor conserva plenos derechos para publicar la app oficial de forma gratuita y sin anuncios.
