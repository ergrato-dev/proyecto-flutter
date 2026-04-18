<!--
  ¿Qué? Requisito funcional que define la pantalla de configuración de preferencias
  de notificaciones del usuario.
  ¿Para qué? Documentar el control granular de notificaciones locales persistido en
  shared_preferences, con gestión de permisos por plataforma.
  ¿Impacto? Controla el comportamiento de RF-010 (tormentas) y APOD diario.
-->

# RF-011 — Configuración de notificaciones

## Identificación

| Campo           | Valor                                 |
| --------------- | ------------------------------------- |
| **ID**          | RF-011                                |
| **Nombre**      | Configuración de notificaciones       |
| **Módulo**      | `lib/modules/notifications/`          |
| **Prioridad**   | Media                                 |
| **Estado**      | Pendiente                             |
| **Fecha**       | Abril 2026                            |
| **HU asociada** | HU-009                                |
| **RF asociado** | RF-010 (alertas solares)              |

---

## Descripción

La pantalla `NotificationSettingsScreen` ofrece tres toggles de configuración: alertas
de tormentas solares, recordatorio APOD diario a una hora elegida por el usuario, y
aviso de paso de la ISS sobre una ubicación. Las preferencias se persisten en
`shared_preferences`. En Android 13+ y iOS 10+ se gestiona el permiso de
notificaciones con `permission_handler` mostrando la rationale antes de solicitarlo.

---

## Parámetros de entrada

| Parámetro           | Tipo Dart  | Obligatorio | Validaciones / Notas                                 |
| ------------------- | ---------- | ----------- | ---------------------------------------------------- |
| `solarAlertsEnabled`| `bool`     | No          | Persiste en `shared_preferences`; default: `true`    |
| `apodReminderEnabled` | `bool`   | No          | Persiste en `shared_preferences`; default: `false`   |
| `apodReminderTime`  | `TimeOfDay`| No          | Solo relevante si `apodReminderEnabled == true`      |
| `issPassEnabled`    | `bool`     | No          | Persiste en `shared_preferences`; default: `false`   |

---

## Flujo

1. El usuario navega a **Configuración → Notificaciones**.
2. `NotificationSettingsScreen` lee las preferencias actuales de `shared_preferences`
   con `notificationSettingsProvider`.
3. La pantalla muestra tres secciones con `SwitchListTile`:
   - **Tormentas solares**: toggle `solarAlertsEnabled`.
   - **APOD diario**: toggle + `TextButton` para elegir hora (abre `showTimePicker`).
   - **Paso de la ISS**: toggle (solo Android e iOS; en Web aparece deshabilitado con
     tooltip "No disponible en Web").
4. Al activar cualquier toggle:
   a. `permission_handler` verifica el estado del permiso de notificaciones.
   b. Si `PermissionStatus.denied`: muestra un `AlertDialog` con rationale y botón
      **Conceder permiso** que llama a `Permission.notification.request()`.
   c. Si el usuario deniega el permiso: el toggle vuelve a `false` y se muestra
      `SnackBar` con "Activa las notificaciones en los ajustes del sistema".
5. Al activar el recordatorio APOD: programa una notificación local diaria a la hora
   elegida con `FlutterLocalNotificationsPlugin.zonedSchedule(...)`.
6. Al desactivar el recordatorio APOD: cancela la notificación programada.
7. Los cambios se guardan inmediatamente en `shared_preferences`.

---

## Estados y salidas

| Estado         | Condición                          | Widget mostrado                                      |
| -------------- | ---------------------------------- | ---------------------------------------------------- |
| `permissionOk` | Permiso concedido                  | Toggles habilitados y funcionales                    |
| `permissionDenied` | Permiso denegado              | Toggles deshabilitados + SnackBar con enlace ajustes |
| `loading`      | Leyendo preferencias               | Skeleton de tres `SwitchListTile`                    |

---

## Widgets / Providers asociados

| Nombre                         | Tipo                    | Descripción                                              |
| ------------------------------ | ----------------------- | -------------------------------------------------------- |
| `NotificationSettingsScreen`   | `ConsumerWidget`        | Pantalla de configuración con tres secciones             |
| `notificationSettingsProvider` | `StateNotifierProvider` | Lee/escribe preferencias en `shared_preferences`         |
| `FlutterLocalNotificationsPlugin` | `class`             | Programa y cancela notificaciones locales                |
| `Permission`                   | `class` (permission_handler) | Solicita y verifica permisos por plataforma         |

---

## Reglas de negocio

- **RN-011.1:** En Flutter Web, las secciones de ISS pass y APOD diario se muestran
  pero con el toggle deshabilitado y tooltip explicativo.
- **RN-011.2:** El recordatorio APOD usa `TZDateTime` con la zona horaria local del
  dispositivo para que siempre suene a la hora correcta.
- **RN-011.3:** Si se desinstala y reinstala la app, los canales de notificación de
  Android se recrean automáticamente al iniciar la app.
