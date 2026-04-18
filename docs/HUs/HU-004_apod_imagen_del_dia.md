<!--
  ¿Qué? Historia de usuario sobre la visualización de la imagen astronómica del
  día de la NASA con opciones de compartir.
  ¿Para qué? Justificar el módulo storage/ con APOD API, CachedNetworkImage y Share.
  ¿Impacto? Cubre RF-004.
-->

# HU-004 — Ver la imagen astronómica del día

## Identificación

| Campo           | Valor                               |
| --------------- | ----------------------------------- |
| **ID**          | HU-004                              |
| **Título**      | Ver la imagen astronómica del día   |
| **Módulo**      | `lib/modules/storage/`              |
| **Prioridad**   | Alta                                |
| **Estado**      | Pendiente                           |
| **RF asociados**| RF-004                              |

---

## Historia

**Como** aficionado a la astronomía,
**quiero** ver la imagen astronómica del día publicada por la NASA con su descripción,
**para** descubrir fotografías espectaculares del cosmos y aprender sobre los
fenómenos representados.

---

## Criterios de aceptación

### CA-004.1 — Carga de la APOD del día

**Dado** que el usuario navega a la sección APOD,
**cuando** la app carga los datos de la API NASA APOD,
**entonces** se muestra la imagen del día actual con su título, fecha, descripción
completa y créditos del autor.

### CA-004.2 — Placeholder durante la carga

**Dado** que el usuario abre APOD por primera vez,
**cuando** la imagen aún no ha terminado de cargar,
**entonces** se muestra un placeholder animado del tamaño de la imagen; no hay
salto de layout al cargar la imagen real.

### CA-004.3 — APOD de tipo vídeo

**Dado** que la APOD del día es un vídeo de YouTube,
**cuando** la pantalla carga,
**entonces** se muestra un thumbnail con el ícono de play; al tocar, el vídeo se
abre en el navegador externo.

### CA-004.4 — Compartir imagen

**Dado** que el usuario está viendo la APOD,
**cuando** pulsa el botón Compartir,
**entonces** se abre el diálogo nativo de compartir con la imagen y el texto
"🌌 {título} — NASA APOD {fecha}"; en Web, el link se copia al portapapeles
con aviso de confirmación.

### CA-004.5 — Acceso offline

**Dado** que el usuario ya visitó la APOD hoy con conexión,
**cuando** abre la app sin conexión,
**entonces** se muestra la APOD cacheada del día con normalidad sin mensaje de error.

### CA-004.6 — Imagen en alta resolución

**Dado** que el usuario está viendo la APOD,
**cuando** toca la imagen,
**entonces** se abre en pantalla completa con `InteractiveViewer` que permite hacer
zoom y desplazarse.
