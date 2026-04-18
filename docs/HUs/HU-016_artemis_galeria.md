<!--
  ¿Qué? Historia de usuario sobre la exploración del programa Artemis y la galería
  de imágenes de la NASA.
  ¿Para qué? Justificar el módulo artemis/ con la NASA Images API y PageView de misiones.
  ¿Impacto? Cubre RF-018. Módulo independiente de otros.
-->

# HU-016 — Explorar las misiones Artemis y la galería NASA

## Identificación

| Campo           | Valor                                          |
| --------------- | ---------------------------------------------- |
| **ID**          | HU-016                                         |
| **Título**      | Explorar las misiones Artemis y la galería NASA |
| **Módulo**      | `lib/modules/artemis/`                         |
| **Prioridad**   | Baja                                           |
| **Estado**      | Pendiente                                      |
| **RF asociados**| RF-018                                         |

---

## Historia

**Como** entusiasta de la exploración espacial,
**quiero** conocer los detalles de las misiones del programa Artemis y ver fotografías
oficiales de la NASA relacionadas,
**para** seguir el programa de regreso a la Luna y descubrir las imágenes más
impresionantes del archivo de la NASA.

---

## Criterios de aceptación

### CA-016.1 — Tarjetas de misiones Artemis

**Dado** que el usuario navega a la sección Artemis,
**cuando** la pantalla carga,
**entonces** se muestra un `PageView` horizontal con las misiones Artemis I, II y III,
cada una con objetivo, tripulación (si aplica) y estado (completada / planificada).

### CA-016.2 — Galería de imágenes NASA

**Dado** que el usuario desplaza hacia abajo en la pantalla Artemis,
**cuando** la galería carga,
**entonces** se muestra una cuadrícula de 2 columnas con imágenes oficiales de la
NASA relacionadas con Artemis.

### CA-016.3 — Visualización de imagen a pantalla completa

**Dado** que el usuario toca una imagen de la galería,
**cuando** se abre el visor,
**entonces** la imagen se muestra a pantalla completa con `InteractiveViewer` que
permite hacer zoom y desplazarse; se muestra el título y descripción de la imagen.

### CA-016.4 — Búsqueda en la galería

**Dado** que el usuario escribe "moon" en el SearchBar de la galería,
**cuando** el resultado carga,
**entonces** la cuadrícula muestra imágenes cuyos metadatos contienen "moon".

### CA-016.5 — Paginación infinita

**Dado** que el usuario llega al final de la galería (20 imágenes),
**cuando** el scroll alcanza el último ítem,
**entonces** la app carga automáticamente las siguientes 20 imágenes de la NASA
Images API sin interrumpir el scroll.

### CA-016.6 — Caché de imágenes

**Dado** que el usuario ya visitó la galería Artemis hace 2 horas,
**cuando** vuelve a abrir la sección sin conexión,
**entonces** las imágenes ya visitadas se muestran desde `CachedNetworkImage` sin
error; el caché de la galería tiene TTL de 6 horas.
