<!--
  ¿Qué? Historia de usuario sobre la navegación por el historial de APODs anteriores
  y la gestión del almacenamiento local.
  ¿Para qué? Justificar el selector de fecha del módulo storage/ y la pantalla
  de gestión de caché.
  ¿Impacto? Cubre RF-004 (selector de fecha) y RF-006 (gestión de caché).
-->

# HU-005 — Explorar APODs anteriores y gestionar almacenamiento

## Identificación

| Campo           | Valor                                         |
| --------------- | --------------------------------------------- |
| **ID**          | HU-005                                        |
| **Título**      | Explorar APODs anteriores y gestionar almacenamiento |
| **Módulo**      | `lib/modules/storage/`                        |
| **Prioridad**   | Media                                         |
| **Estado**      | Pendiente                                     |
| **RF asociados**| RF-004, RF-005, RF-006                        |

---

## Historia

**Como** aficionado a la astronomía,
**quiero** navegar por las imágenes astronómicas de días anteriores y gestionar el
espacio que ocupa la caché de la app,
**para** explorar el archivo de la NASA y mantener la app sin ocupar demasiado
espacio en mi dispositivo.

---

## Criterios de aceptación

### CA-005.1 — Navegación a la fecha anterior

**Dado** que el usuario está viendo la APOD del día,
**cuando** pulsa el botón de flecha izquierda,
**entonces** la pantalla carga la APOD del día anterior; si ya fue visitada, los
datos se sirven desde el caché Riverpod sin petición de red.

### CA-005.2 — Selector de fecha con rango válido

**Dado** que el usuario pulsa el botón de fecha en la APOD,
**cuando** se abre el selector de fecha,
**entonces** el rango permitido abarca desde 1995-06-16 (primera APOD) hasta hoy;
las fechas futuras están deshabilitadas.

### CA-005.3 — Ver lista de cuerpos favoritos

**Dado** que el usuario guardó varios planetas como favoritos,
**cuando** navega a la sección Favoritos desde el Drawer,
**entonces** ve la lista completa de cuerpos guardados con nombre, tipo e icono.

### CA-005.4 — Eliminar favorito individual por swipe

**Dado** que el usuario está en la lista de favoritos,
**cuando** desliza una entrada hacia la izquierda,
**entonces** aparece la acción Eliminar roja; al confirmar, el ítem desaparece con
animación y aparece un SnackBar con opción Deshacer.

### CA-005.5 — Ver espacio de caché

**Dado** que el usuario accede a Ajustes → Caché,
**cuando** la pantalla carga,
**entonces** se muestran tres tarjetas con el espacio aproximado ocupado por la caché
APOD, la base de datos drift y el historial de búsquedas.

### CA-005.6 — Borrar caché con confirmación

**Dado** que el usuario pulsa Borrar todo en la pantalla de caché,
**cuando** confirma en el AlertDialog,
**entonces** se vacían los almacenamientos seleccionados y los contadores de espacio
vuelven a 0; los favoritos no se eliminan en ningún caso.
