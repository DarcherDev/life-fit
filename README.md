# Life Fit

App personal para gestionar rutinas de gimnasio: crea tarjetas de ejercicios reutilizables, asígnalas en un calendario y marca tu progreso día a día.

**Versión actual:** `1.1.0+2`  
**Repositorio:** [github.com/DarcherDev/life-fit](https://github.com/DarcherDev/life-fit)

## Para qué sirve

Life Fit te ayuda a organizar tus entrenamientos sin depender de hojas de cálculo ni notas sueltas. Defines rutinas una vez, las programas en el planificador y cada día entras a tu sesión con una checklist interactiva.

## Funciones principales

### Día de gym
- Acceso inteligente desde Home según el estado del día:
  - Si ya hay rutina asignada → abre la sesión directamente.
  - Si hay rutinas pero hoy no está asignada → selector para elegir y asignar.
  - Si no hay rutinas creadas → formulario para crear una y asignarla al instante.
- Checklist por ejercicio con series y repeticiones.
- Confetti al completar la rutina o pulsar **Terminar rutina**.

### Rutina
- Crear, editar y eliminar tarjetas de rutina.
- Cada rutina incluye nombre, descripción opcional y lista de ejercicios.
- Formato de ejercicios: `N series x M repeticiones`.

### Planificador
- Calendario mensual para asignar una rutina por día.
- Bottom sheet compartido con búsqueda y scroll para elegir rutina.
- Opción de quitar la asignación de un día.

### Almacenamiento
- Datos guardados localmente en el dispositivo (`shared_preferences`).
- Sin cuenta ni conexión a internet requerida.

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
├── flows/           # Coordinadores de flujo (ej. Día de gym)
├── models/          # RoutineCard, ChecklistItem, DayAssignment, DayProgress
├── navigation/      # Navegación centralizada
├── screens/         # Home, Rutinas, Planificador, Día de gym
├── services/        # LocalStorageService
├── utils/           # Fechas, búsqueda de rutinas
└── widgets/         # Componentes reutilizables (sheet de asignación, preview)
```

## Versionado

El número de versión vive en `pubspec.yaml`:

```yaml
version: 1.1.0+2
#        │     └── build number (versionCode Android, debe subir en cada APK)
#        └── versión visible (versionName)
```

Convención:
- **MAJOR** (`2.0.0`) — cambios grandes o incompatibles.
- **MINOR** (`1.1.0`) — nuevas funciones.
- **PATCH** (`1.1.1`) — correcciones.
- **+N** — número de build; siempre incrementar al generar un APK instalable.

Historial detallado en [CHANGELOG.md](CHANGELOG.md).

## Novedades de la release 1.1.0

Respecto a la `1.0.0+1`:

- **Flujo inteligente Día de gym:** el coordinador decide si abrir la sesión, mostrar el selector o crear una rutina nueva.
- **Bottom sheet de asignación mejorado:** media pantalla, lista con scroll y buscador por título/descripción.
- **Componente único compartido** entre Planificador, Día de gym y cambio de rutina en sesión.
- **Formulario con auto-asignación** al crear rutina desde el flujo de Día de gym.
- **Tests** para la lógica de entrada (`today_gym_entry`) y filtrado de búsqueda (`routine_search`).

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
