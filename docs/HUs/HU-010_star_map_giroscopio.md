<!--
  ¿Qué? Historia de usuario sobre el uso del star map controlado por giroscopio.
  ¿Para qué? Justificar el módulo sensors/ con sensors_plus y CustomPainter.
  ¿Impacto? Cubre RF-012.
-->

# HU-010 — Explorar el cielo estrellado con el dispositivo

## Identificación

| Campo           | Valor                                        |
| --------------- | -------------------------------------------- |
| **ID**          | HU-010                                       |
| **Título**      | Explorar el cielo estrellado con el dispositivo |
| **Módulo**      | `lib/modules/sensors/`                        |
| **Prioridad**   | Media                                         |
| **Estado**      | Pendiente                                     |
| **RF asociados**| RF-012                                        |

---

## Historia

**Como** observador astronómico,
**quiero** apuntar mi teléfono al cielo y ver qué estrellas hay en esa dirección,
**para** identificar constelaciones y estrellas brillantes durante una sesión de
observación nocturna.

---

## Criterios de aceptación

### CA-010.1 — Control del canvas con giroscopio

**Dado** que el usuario está en el Star Map con giroscopio disponible,
**cuando** gira el dispositivo en cualquier dirección,
**entonces** el mapa de estrellas se desplaza de forma fluida siguiendo la
orientación real del dispositivo.

### CA-010.2 — Modo gesture sin giroscopio

**Dado** que el dispositivo no tiene giroscopio (o es Flutter Web),
**cuando** el usuario entra al Star Map,
**entonces** aparece el banner "Giroscopio no disponible — arrastra para explorar"
y el canvas se controla con el dedo sin interrupción.

### CA-010.3 — Identificación de estrellas

**Dado** que el usuario está usando el Star Map,
**cuando** toca sobre una estrella,
**entonces** aparece un tooltip con el nombre de la estrella y su magnitud aparente.

### CA-010.4 — Modo noche

**Dado** que el usuario activa el Modo Noche desde el botón del AppBar,
**cuando** el toggle se activa,
**entonces** toda la interfaz cambia a tonos rojo oscuro sobre negro para preservar
la adaptación de los ojos a la oscuridad.

### CA-010.5 — Calibración al cénit

**Dado** que el mapa no está centrado correctamente,
**cuando** el usuario pulsa el botón Calibrar,
**entonces** el canvas se reposiciona para mostrar el cénit del observador según
los datos del acelerómetro.

### CA-010.6 — Tamaño proporcional a la magnitud

**Dado** que el star map está mostrando estrellas,
**cuando** se comparan Sirio (magnitud -1.46) y una estrella de magnitud 5,
**entonces** el punto de Sirio es visualmente más grande que el de la estrella de
magnitud 5, siendo la diferencia proporcional a la escala de magnitudes.
