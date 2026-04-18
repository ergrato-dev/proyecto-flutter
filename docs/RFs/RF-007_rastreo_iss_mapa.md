<!--
  ¿Qué? Requisito funcional que define el rastreo en tiempo real de la ISS sobre
  un mapa terrestre con trayectoria orbital.
  ¿Para qué? Documentar el módulo maps/ que demuestra google_maps_flutter, polling
  periódico con Riverpod y renderizado de Polyline.
  ¿Impacto? Base para el módulo realtime/ (RF-008). Afecta a HU-007.
-->

# RF-007 — Rastreo ISS en mapa

## Identificación

| Campo           | Valor                         |
| --------------- | ----------------------------- |
| **ID**          | RF-007                        |
| **Nombre**      | Rastreo ISS en mapa           |
| **Módulo**      | `lib/modules/maps/`           |
| **Prioridad**   | Alta                          |
| **Estado**      | Pendiente                     |
| **Fecha**       | Abril 2026                    |
| **HU asociada** | HU-007                        |
| **RF asociado** | RF-008 (Realtime), RF-009 (Tripulación) |

---

## Descripción

La pantalla `IssMapScreen` muestra la posición actual de la Estación Espacial
Internacional sobre un mapa terrestre usando `google_maps_flutter`. La posición
se actualiza cada 5 segundos mediante polling a la API Open-Notify
(`http://api.open-notify.org/iss-now.json`). El sistema dibuja la trayectoria de
los últimos 10 minutos (120 puntos) como `Polyline`. Un panel flotante muestra las
coordenadas actuales (latitud, longitud).

---

## Parámetros de entrada

| Parámetro        | Tipo Dart     | Obligatorio | Validaciones / Notas                               |
| ---------------- | ------------- | ----------- | -------------------------------------------------- |
| —                | —             | —           | No hay parámetros de usuario; la posición se obtiene automáticamente |

---

## Flujo

1. El usuario navega a la sección **ISS** (tab inferior).
2. `IssMapScreen` monta un `GoogleMap` centrado en las últimas coordenadas
   cacheadas, o en [0, 0] si no hay datos previos.
3. `issPositionProvider` (Riverpod `StreamProvider`) inicia polling con
   `Stream.periodic(Duration(seconds: 5))` que llama a `IssRepository.getPosition()`.
4. Cada tick del stream:
   a. Actualiza el `Marker` de la ISS en el mapa.
   b. Agrega el punto al buffer circular de 120 posiciones.
   c. Redibuja la `Polyline` de trayectoria.
   d. Actualiza el panel de coordenadas (`lat`, `lon` formateados a 4 decimales).
5. El botón **Centrar en ISS** (`FloatingActionButton`) llama a
   `mapController.animateCamera(CameraUpdate.newLatLng(issPosition))`.
6. Al perder conectividad, el polling falla silenciosamente y el panel muestra la
   última posición conocida con timestamp.
7. Al recuperar conectividad, el polling se reanuda automáticamente.

---

## Estados y salidas

| Estado     | Condición                           | Widget mostrado                                                    |
| ---------- | ----------------------------------- | ------------------------------------------------------------------ |
| `loading`  | Primer tick aún sin datos           | Mapa centrado en [0,0] con ProgressIndicator superpuesto           |
| `data`     | Posición recibida                   | Mapa con marcador ISS, Polyline y panel de coordenadas             |
| `error`    | Error HTTP persistente (>3 fallos)  | Banner "Sin datos de posición — comprueba tu conexión"             |
| `offline`  | Sin conexión                        | Última posición conocida + badge amarillo "Última posición conocida |

---

## Widgets / Providers asociados

| Nombre                  | Tipo                  | Descripción                                                    |
| ----------------------- | --------------------- | -------------------------------------------------------------- |
| `IssMapScreen`          | `ConsumerStatefulWidget` | Pantalla con `GoogleMap` y panel flotante                    |
| `issPositionProvider`   | `StreamProvider`      | Stream de polling cada 5 s                                     |
| `issTrajectoryProvider` | `StateNotifierProvider` | Buffer circular de últimas 120 posiciones                     |
| `IssCoordinatesPanel`   | `StatelessWidget`     | Panel flotante con lat/lon formateados                         |
| `IssRepository`         | `class`               | `getPosition()` en `lib/shared/repositories/iss_repository.dart` |

---

## Reglas de negocio

- **RN-007.1:** La API Open-Notify usa HTTP (no HTTPS); en Android ≥ 9 se debe
  configurar `android:usesCleartextTraffic="true"` en el `AndroidManifest.xml` o
  usar un proxy HTTPS.
- **RN-007.2:** El buffer de trayectoria es circular: cuando llega al punto 120,
  descarta el punto más antiguo e inserta el nuevo.
- **RN-007.3:** El polling se detiene automáticamente cuando la pantalla queda en
  segundo plano (`AppLifecycleState.paused`) y se reanuda al volver al frente
  (`AppLifecycleState.resumed`).
- **RN-007.4:** El módulo `maps/` solo es funcional en Android e iOS; en Flutter
  Web se muestra un mapa estático con la última posición y un mensaje indicando que
  el rastreo en tiempo real no está disponible en Web.
