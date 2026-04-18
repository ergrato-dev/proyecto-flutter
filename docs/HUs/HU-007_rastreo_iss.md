<!--
  ¿Qué? Historia de usuario sobre el rastreo en tiempo real de la ISS en un mapa.
  ¿Para qué? Justificar el módulo maps/ con google_maps_flutter, polling y Polyline.
  ¿Impacto? Cubre RF-007. Base para RF-009 (realtime) y HU-008 (tripulación).
-->

# HU-007 — Ver la posición actual de la ISS

## Identificación

| Campo           | Valor                                |
| --------------- | ------------------------------------ |
| **ID**          | HU-007                               |
| **Título**      | Ver la posición actual de la ISS     |
| **Módulo**      | `lib/modules/maps/`                  |
| **Prioridad**   | Alta                                 |
| **Estado**      | Pendiente                            |
| **RF asociados**| RF-007, RF-009                       |

---

## Historia

**Como** entusiasta del espacio,
**quiero** ver en un mapa terrestre dónde se encuentra ahora mismo la Estación
Espacial Internacional y su trayectoria reciente,
**para** saber sobre qué país está pasando en este momento.

---

## Criterios de aceptación

### CA-007.1 — Visualización del marcador ISS

**Dado** que el usuario abre la sección ISS,
**cuando** la app recibe la primera posición de la API Open-Notify,
**entonces** se muestra un marcador de la ISS sobre un mapa terrestre en la posición
correcta (latitud y longitud verificadas contra la API).

### CA-007.2 — Actualización automática cada 5 segundos

**Dado** que el usuario está en la pantalla ISS,
**cuando** pasan 5 segundos desde la última actualización,
**entonces** el marcador de la ISS se mueve a la nueva posición; el panel de
coordenadas muestra los valores actualizados.

### CA-007.3 — Trayectoria de los últimos 10 minutos

**Dado** que el usuario lleva más de 10 minutos en la pantalla ISS,
**cuando** observa el mapa,
**entonces** se dibuja una `Polyline` que muestra la trayectoria de las últimas 120
posiciones (10 minutos a 1 posición cada 5 segundos).

### CA-007.4 — Botón centrar en ISS

**Dado** que el usuario ha desplazado el mapa lejos de la ISS,
**cuando** pulsa el FAB "Centrar en ISS",
**entonces** el mapa se anima suavemente para centrar la cámara en la posición
actual de la ISS.

### CA-007.5 — Pausa al pasar la app a segundo plano

**Dado** que el usuario minimiza la app con la pantalla ISS activa,
**cuando** vuelve a abrir la app,
**entonces** el polling se había detenido mientras la app estaba en segundo plano
y se reanuda automáticamente.

### CA-007.6 — Modo offline con última posición

**Dado** que el usuario pierde conexión estando en la pantalla ISS,
**cuando** el polling falla,
**entonces** el mapa muestra la última posición conocida con un badge amarillo
"Última posición conocida" y la marca de tiempo de la última actualización exitosa.

### CA-007.7 — Activar modo Realtime (Supabase)

**Dado** que el usuario está en la pantalla ISS,
**cuando** activa el toggle "Modo Realtime",
**entonces** el sistema cambia del polling de Open-Notify al canal de broadcast de
Supabase y el indicador de estado del canal se vuelve verde cuando está suscrito.
