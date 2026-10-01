## Resumen
- **Dos calentamientos por rutina:** uno al inicio (antes de los estiramientos) y otro al final (después de los ejercicios). En Día de gym cada uno se marca, cambia y edita por separado y ambos cuentan en el progreso.
- **Cuadro "¿Cuándo hacerlo?"** al elegir un calentamiento en el formulario de rutina, con aviso de cuál reemplaza si la posición ya está ocupada.
- **Rutinas solo de cardio:** basta con al menos un calentamiento, estiramiento o ejercicio.
- **Editar ejercicio** muestra el nombre y la descripción (3 líneas con "Ver más").
- **Corregido:** el buscador de las bibliotecas ya no muestra el desplegable de sugerencias que tapaba la lista.
- Las rutinas existentes y los JSON anteriores conservan su calentamiento en la misma posición.

## Instalación
1. Descargar `life-fit-v3.10.0.apk` de los assets de esta release.
2. Instalar en Android (permitir orígenes desconocidos si aplica).

## Test plan
- [ ] Rutinas existentes mantienen su calentamiento en la misma posición.
- [ ] Formulario de rutina: elegir bici "Al inicio" y caminadora "Al final"; el cuadro avisa "Reemplaza a ..." si la posición está ocupada.
- [ ] Día de gym: ambos calentamientos se ven, se marcan, se cambian y se editan por separado.
- [ ] Guardar una rutina solo con calentamientos y completarla en Día de gym.
- [ ] El anillo de Home cuenta ambos calentamientos.
- [ ] Exportar e importar conserva los dos calentamientos.
- [ ] Editar ejercicio muestra nombre y descripción.
- [ ] Buscar en una biblioteca: la lista filtra sin desplegable encima.
