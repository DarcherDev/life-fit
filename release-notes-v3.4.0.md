## Resumen

- **Importar / exportar rutinas** en JSON desde el drawer (perfil + rutinas; upsert de plantillas).
- **Reordenar por arrastre** ejercicios y estiramientos en Día de gym, y opciones del menú Home.
- **Icono de marca** Life Fit en launcher (con margen seguro) y en el header del drawer; tema verde menta.
- **Corregido:** el anillo de progreso de Home se actualiza al volver del Día de gym.
- Tachado suave al completar un ítem antes de bajarlo en la lista.

## Instalación

1. Descargar `app-release.apk` (o `life-fit-v3.4.0.apk`) de los assets de esta release.
2. Instalar en Android (permitir orígenes desconocidos si aplica).

## Test plan

- [ ] Exportar rutinas, copiar JSON e importar en un dispositivo/emulador limpio
- [ ] Reordenar ejercicios en Día de gym y confirmar que el orden se mantiene al salir
- [ ] Reordenar tarjetas del Home y reiniciar la app
- [ ] Completar un ítem y ver tachado + movimiento al final; progreso en Home al volver
- [ ] Abrir drawer: logo centrado sin fondo de color; icono del launcher sin recorte
