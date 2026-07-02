## Resumen

- **Persistencia SOLID:** `LocalStorageService` sustituido por `AppRepositories` con interfaces por dominio.
- Pantallas y flujos migrados a repositorios tipados; `RoutineAssignSheet` recibe rutinas como parámetro.
- Reglas Cursor actualizadas (`diseno-reutilizable` con SOLID, `/push` con APK en release).
- Eliminado código muerto sin uso.

## Instalación

1. Descargar `app-release.apk` de los assets de esta release.
2. Instalar en Android (permitir orígenes desconocidos si aplica).

## Test plan

- [ ] Abrir app y verificar Home con 6 opciones
- [ ] CRUD en bibliotecas (ejercicios, estiramientos, calentamiento)
- [ ] Crear/editar rutina con pickers y preview
- [ ] Asignar rutina en planificador y completar checklist en Día de gym
- [ ] Verificar que datos existentes migran y persisten tras actualizar
