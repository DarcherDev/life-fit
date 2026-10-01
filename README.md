# Life Fit

App personal para gestionar rutinas de gimnasio: mantén bibliotecas reutilizables de ejercicios, estiramientos y calentamientos; compón rutinas por referencia; asígnalas en un calendario y marca tu progreso día a día.

**Versión actual:** `3.10.0+29`  
**Repositorio:** [github.com/DarcherDev/life-fit](https://github.com/DarcherDev/life-fit)

## Para qué sirve

Life Fit te ayuda a organizar tus entrenamientos sin depender de hojas de cálculo ni notas sueltas. Defines ítems una vez en bibliotecas, los combinas en rutinas, las programas en el planificador y cada día entras a tu sesión con una checklist interactiva.

## Funciones principales

### Home
- Anillo de progreso de la rutina de hoy (ítems completados / total) con acceso al día de gym.
- Acceso inteligente al día de gym según el estado del día (rutina asignada, selector o creación).
- **Reordenar** las tarjetas del menú por arrastre largo (el anillo de progreso permanece fijo).

### Día de gym
- Acceso inteligente desde Home según el estado del día:
  - Si ya hay rutina asignada → abre la sesión directamente.
  - Si hay rutinas pero hoy no está asignada → selector para elegir y asignar.
  - Si no hay rutinas creadas → formulario para crear una y asignarla al instante.
- Checklist por ejercicio, estiramiento y calentamiento (datos resueltos desde bibliotecas).
- Marcar ítem tocando toda la fila del checklist.
- **Reordenar** ejercicios y estiramientos por arrastre largo; el orden se guarda en la rutina.
- Editar series, repeticiones y peso del ejercicio en la sesión.
- Editar los **minutos del calentamiento** y las **repeticiones de cada estiramiento** en la sesión (se guarda en la biblioteca).
- Reemplazar ejercicio, estiramiento o calentamiento por otro de la biblioteca.
- El peso de ejercicios se muestra **redondeado al disco más cercano** al cambiar kg/lb (2,5 kg o 5 lb).
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
- Cada rutina incluye nombre, descripción opcional, calentamientos, estiramientos y ejercicios; basta con tener al menos uno de ellos (sirve para rutinas solo de cardio).
- Hasta dos calentamientos: **al inicio** (antes de los estiramientos) y **al final** (después de los ejercicios), ej. 10 min de bici al inicio y 10 de caminadora al final.
- En el formulario los calentamientos aparecen juntos en una sola sección; al elegir uno, un cuadro pregunta si va al inicio o al final (si esa posición ya está ocupada, avisa a cuál reemplaza).
- Botón de editar en calentamiento y estiramientos para ajustar minutos o repeticiones sin salir del formulario.
- Vista previa resuelta antes de guardar.

### Planificador
- Calendario mensual para asignar una rutina por día.
- Tocar un día solo lo selecciona; si no tiene rutina, la lista con buscador aparece **debajo de la fecha** para asignar una.
- En un día con rutina, el botón de editar abre el bottom sheet para cambiarla o quitarla.

### Ajustes (drawer)
- Header con el **logo** de Life Fit.
- **Ajustes** en diálogo modal: tema claro, oscuro o seguir el sistema; idioma español / inglés; unidad de peso kg/lb.
- **Mi proceso:** edad, altura y peso corporal persistentes en el dispositivo.
- **Exportar rutinas:** JSON (perfil + rutinas) para compartir o analizar. Sin rutinas, muestra un **JSON de ejemplo** con la biblioteca base para adaptarlo e importarlo.
- **Importar rutinas:** pegar JSON y reemplazar las rutinas locales (upsert de plantillas).
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
| `routine_cards` | Rutinas con slots (`RoutineExerciseSlot`, `RoutineStretchingSlot`, `startWarmUpId`, `endWarmUpId`) |
| `day_assignments` | Rutina asignada por fecha |
| `day_progress` | Ítems completados por `slotId` |
| `personal_profile` | Edad, altura y peso corporal del usuario |
| `home_menu_order` | Orden de las tarjetas del menú Home |

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
    ├── flows/             # LibraryQuickEditActions (edición rápida de plantillas)
    ├── models/            # RoutineCard, slots, ResolvedRoutine
    ├── utils/             # routine_resolver, búsqueda
    └── widgets/           # LibraryPickerSheet, RoutineAssignSheet, RoutinePickerList, NumberEditDialog
```

## Versionado

El número de versión vive en `pubspec.yaml`:

```yaml
version: 3.10.0+29
#        │     └── build number (versionCode Android, debe subir en cada APK)
#        └── versión visible (versionName)
```

Convención:
- **MAJOR** (`2.0.0`) — cambios grandes o incompatibles.
- **MINOR** (`1.1.0`) — nuevas funciones.
- **PATCH** (`1.1.1`) — correcciones.
- **+N** — número de build; siempre incrementar al generar un APK instalable.

Historial detallado en [CHANGELOG.md](CHANGELOG.md).

## Novedades de la release 3.10.0

Respecto a la `3.8.0+26`:

- **Calentamiento al inicio y al final** en la misma rutina (ej. 10 min de bici antes y 10 de caminadora después).
- Al elegir un calentamiento, un cuadro pregunta si va **al inicio o al final**.
- **Rutinas solo de cardio:** ya no es obligatorio tener ejercicios.
- **Editar ejercicio** muestra su nombre y descripción.
- **Buscador** de bibliotecas sin el desplegable de sugerencias que tapaba la lista.

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
