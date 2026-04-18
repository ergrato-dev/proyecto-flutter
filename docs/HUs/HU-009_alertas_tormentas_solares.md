<!--
  ¿Qué? Historia de usuario sobre las alertas de tormentas solares y la configuración
  de notificaciones astronómicas.
  ¿Para qué? Justificar el módulo notifications/ con DONKI API y flutter_local_notifications.
  ¿Impacto? Cubre RF-010 y RF-011.
-->

# HU-009 — Recibir alertas de tormentas solares

## Identificación

| Campo           | Valor                                     |
| --------------- | ----------------------------------------- |
| **ID**          | HU-009                                    |
| **Título**      | Recibir alertas de tormentas solares      |
| **Módulo**      | `lib/modules/notifications/`              |
| **Prioridad**   | Media                                     |
| **Estado**      | Pendiente                                 |
| **RF asociados**| RF-010, RF-011                            |

---

## Historia

**Como** aficionado al clima espacial,
**quiero** recibir notificaciones cuando la NASA detecte tormentas solares de clase
M o superior,
**para** estar al tanto de los eventos de clima espacial que pueden afectar a las
comunicaciones y a la aurora boreal.

---

## Criterios de aceptación

### CA-009.1 — Notificación local de tormenta solar

**Dado** que la app detecta un nuevo evento DONKI de clase M o superior en el polling,
**cuando** el evento no había sido notificado antes,
**entonces** aparece una notificación local con el texto "☀️ Tormenta solar clase {X}
detectada — {fecha}"; al tocar la notificación, se abre `SolarWeatherScreen`.

### CA-009.2 — Lista de eventos recientes

**Dado** que el usuario abre la sección Clima Espacial,
**cuando** la pantalla carga,
**entonces** se muestra la lista de eventos DONKI de los últimos 7 días ordenados
por fecha descendente.

### CA-009.3 — Filtro por tipo de evento

**Dado** que el usuario está en la pantalla de clima espacial,
**cuando** activa el filtro "Solo llamaradas",
**entonces** la lista muestra solo eventos de tipo `FLR` (llamaradas solares).

### CA-009.4 — Activación de alertas con permiso

**Dado** que el usuario activa las alertas de tormentas solares por primera vez,
**cuando** el dispositivo es Android 13+,
**entonces** se muestra el diálogo de permiso `POST_NOTIFICATIONS` con el texto
"Activa las notificaciones para recibir alertas de tormentas solares"; si se deniega,
el toggle vuelve a desactivado.

### CA-009.5 — Desactivar alertas

**Dado** que el usuario tiene activas las alertas solares,
**cuando** desactiva el toggle en la pantalla de configuración de notificaciones,
**entonces** el polling continúa ejecutándose pero no se emiten notificaciones;
la lista de eventos sigue siendo accesible.

### CA-009.6 — No duplicar notificaciones

**Dado** que el usuario cierra y reabre la app tras recibir una notificación de
tormenta solar,
**cuando** el polling se ejecuta de nuevo,
**entonces** no se re-envía la notificación del evento ya notificado.
