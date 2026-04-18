<!--
  ¿Qué? Requisito funcional que define las alertas locales de tormentas solares
  basadas en la API NASA DONKI.
  ¿Para qué? Documentar el módulo notifications/ con flutter_local_notifications,
  permission_handler y polling de eventos de clima espacial.
  ¿Impacto? Afecta a HU-009 y a RF-011 (configuración de notificaciones).
-->

# RF-010 — Alertas de tormentas solares (DONKI)

## Identificación

| Campo           | Valor                                    |
| --------------- | ---------------------------------------- |
| **ID**          | RF-010                                   |
| **Nombre**      | Alertas de tormentas solares (DONKI)     |
| **Módulo**      | `lib/modules/notifications/`             |
| **Prioridad**   | Media                                    |
| **Estado**      | Pendiente                                |
| **Fecha**       | Abril 2026                               |
| **HU asociada** | HU-009                                   |
| **RF asociado** | RF-011 (configuración de notificaciones) |

---

## Descripción

El módulo `notifications/` consulta periódicamente la API NASA DONKI para detectar
eventos de clima espacial (eyecciones de masa coronal y llamaradas solares clase
M o X). Cuando se detecta un evento nuevo, el sistema muestra una notificación local
con `flutter_local_notifications`. La pantalla `SolarWeatherScreen` lista los
eventos recientes con detalles (tipo, clase, fecha, descripción).

---

## Parámetros de entrada

| Parámetro     | Tipo Dart | Obligatorio | Validaciones / Notas                                          |
| ------------- | --------- | ----------- | ------------------------------------------------------------- |
| `eventClass`  | `String?` | No          | Filtro opcional: `M`, `X`; null muestra todos                 |
| `startDate`   | `DateTime?` | No        | Rango; null usa últimos 7 días                                 |

---

## Flujo

1. Al iniciar la app, `solarWeatherService.schedulePolling()` registra una tarea
   de polling periódico (cada 6 horas) usando `Timer.periodic` con persist en
   `shared_preferences` de la última fecha de polling.
2. Cuando el polling se ejecuta:
   a. `NasaRepository.getDonkiCme(startDate)` y `getDonkiFlr(startDate)` recuperan
      los eventos.
   b. Se comparan con los eventos ya vistos (IDs en `shared_preferences`).
   c. Los eventos nuevos de clase M o X generan una notificación local mediante
      `FlutterLocalNotificationsPlugin.show(...)`.
3. Al tocar la notificación, la app navega a `SolarWeatherScreen`.
4. `SolarWeatherScreen` muestra la lista de eventos recientes ordenados por fecha
   descendente; cada ítem tiene: tipo (CME / Llamarada), clase, fecha ISO y
   descripción corta.
5. El usuario puede filtrar por tipo (toggle chips: CME / Llamarada) y por clase
   (M / X / todas).
6. Botón **Actualizar** fuerza polling inmediato.

---

## Estados y salidas

| Estado    | Condición                      | Widget mostrado                                             |
| --------- | ------------------------------ | ----------------------------------------------------------- |
| `loading` | Petición DONKI en curso        | Skeleton de 3 tarjetas de evento                            |
| `data`    | Eventos recibidos              | `ListView` de `SolarEventCard`                              |
| `error`   | Error de red o API             | Mensaje de error + botón reintentar                         |
| `empty`   | Sin eventos en el período      | "Sin tormentas solares en los últimos 7 días" + ilustración |

---

## Widgets / Providers asociados

| Nombre                        | Tipo                    | Descripción                                               |
| ----------------------------- | ----------------------- | --------------------------------------------------------- |
| `SolarWeatherScreen`          | `ConsumerWidget`        | Pantalla de lista de eventos solares                      |
| `solarEventsProvider`         | `FutureProvider`        | Fetching y merge de CME + Llamaradas                      |
| `SolarEventCard`              | `StatelessWidget`       | Tarjeta con clase, tipo, fecha y descripción              |
| `solarWeatherService`         | `class`                 | Scheduling de polling y emisión de notificaciones locales |
| `NasaRepository`              | `class`                 | `getDonkiCme()` y `getDonkiFlr()` en `nasa_repository.dart` |
| `FlutterLocalNotificationsPlugin` | `class`            | Plugin de notificaciones locales                          |

---

## Reglas de negocio

- **RN-010.1:** En Android 13+ (API 33) se solicita el permiso
  `POST_NOTIFICATIONS` al primer intento de programar una notificación; si se
  deniega, el polling continúa pero no se muestran notificaciones.
- **RN-010.2:** Solo se notifica por eventos de clase M o superior; los eventos de
  clase C y B se listan en pantalla pero no generan notificación.
- **RN-010.3:** El canal de notificaciones de Android se llama `solar_weather` con
  importancia `HIGH` para que aparezca como cabecera emergente.
- **RN-010.4:** Los IDs de eventos ya notificados se persisten en `shared_preferences`
  para no duplicar notificaciones entre sesiones.
- **RN-010.5:** El polling solo se realiza si la configuración (RF-011) tiene
  activadas las alertas de tormentas solares.
