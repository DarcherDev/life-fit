## Resumen
- **Planificador** menos intrusivo: tocar un día solo lo selecciona; si no tiene rutina, la lista con buscador aparece debajo de la fecha. El menú para cambiar o quitar la rutina se abre solo con el botón de editar.
- **Editar calentamiento y estiramientos:** cambia los minutos del calentamiento y las repeticiones de cada estiramiento desde Día de gym o desde el formulario de rutina.
- **JSON de ejemplo** en Exportar rutinas cuando aún no tienes rutinas, listo para adaptar con IA e importar.
- **Peso redondeado** al disco más cercano (2,5 kg / 5 lb) al cambiar entre kg y lb.
- **Nueva paleta** azul/naranja, icono nuevo, tarjetas de Home unificadas y menú lateral sin subtítulos.

## Instalación
1. Descargar `life-fit-v3.8.0.apk` de los assets de esta release.
2. Instalar en Android (permitir orígenes desconocidos si aplica).

## Test plan
- [ ] Planificador: tocar un día vacío y asignar una rutina desde la lista bajo la fecha.
- [ ] Planificador: tocar un día con rutina no abre ningún menú; el botón de editar permite cambiarla o quitarla.
- [ ] Día de gym: editar los minutos del calentamiento y las repeticiones de un estiramiento.
- [ ] Formulario de rutina: editar calentamiento y estiramiento desde sus tarjetas.
- [ ] Exportar rutinas sin rutinas muestra el JSON de ejemplo; importarlo crea "Rutina de ejemplo".
- [ ] Cambiar kg/lb muestra pesos redondeados al disco más cercano.
