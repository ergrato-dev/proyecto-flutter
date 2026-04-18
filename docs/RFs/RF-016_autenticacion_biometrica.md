<!--
  ¿Qué? Requisito funcional que define la autenticación biométrica (huella/face)
  como método rápido de desbloqueo de una sesión existente.
  ¿Para qué? Documentar el uso de local_auth con fallback a contraseña y gestión
  de disponibilidad de hardware biométrico.
  ¿Impacto? Afecta a HU-012. Requiere sesión previa de RF-015.
-->

# RF-016 — Autenticación biométrica

## Identificación

| Campo           | Valor                                 |
| --------------- | ------------------------------------- |
| **ID**          | RF-016                                |
| **Nombre**      | Autenticación biométrica              |
| **Módulo**      | `lib/modules/auth/`                   |
| **Prioridad**   | Media                                 |
| **Estado**      | Pendiente                             |
| **Fecha**       | Abril 2026                            |
| **HU asociada** | HU-012                                |
| **RF previo**   | RF-015                                |

---

## Descripción

Una vez que el usuario tiene una sesión activa (RF-015), puede activar la
autenticación biométrica para sesiones futuras desde la pantalla de perfil.
Al reabrir la app con una sesión existente, `local_auth` solicita la biometría
disponible (huella dactilar o Face ID). Tras 3 fallos consecutivos, la app cae
automáticamente al formulario de contraseña.

---

## Parámetros de entrada

| Parámetro            | Tipo Dart | Obligatorio | Validaciones / Notas                                         |
| -------------------- | --------- | ----------- | ------------------------------------------------------------ |
| `biometricEnabled`   | `bool`    | No          | Persiste en `flutter_secure_storage`; default `false`        |

---

## Flujo

### Activar biometría
1. El usuario accede a **Perfil → Seguridad → Activar biometría**.
2. `BiometricService.isAvailable()` verifica si el hardware está disponible y
   tiene biometría enrollada.
3. Si no disponible: muestra "Tu dispositivo no soporta biometría" (botón
   deshabilitado).
4. Si disponible: se solicita una autenticación biométrica inicial de verificación
   con `LocalAuthentication.authenticate(localizedReason: ...)`.
5. Si éxito: se guarda `biometric_enabled: true` en `flutter_secure_storage`.

### Desbloqueo biométrico al abrir la app
1. En `main.dart`, `authSessionProvider` detecta una sesión Supabase persistida.
2. Si `biometric_enabled == true` y la sesión es < 30 días: `BiometricScreen` se
   muestra antes de acceder al área protegida.
3. `LocalAuthentication.authenticate(...)` presenta el diálogo nativo del sistema.
4. Si éxito: se navega al área protegida.
5. Si fallo: contador de intentos incrementa; al tercer fallo, se cancela y se
   muestra `SignInScreen` para autenticación por contraseña.
6. El usuario puede pulsar **Usar contraseña** en cualquier momento para saltar
   la biometría.

---

## Estados y salidas

| Estado            | Condición                          | Widget mostrado                                           |
| ----------------- | ---------------------------------- | --------------------------------------------------------- |
| `unavailable`     | Hardware sin biometría             | Botón deshabilitado + mensaje explicativo                 |
| `authenticating`  | Diálogo nativo visible             | `BiometricScreen` con ícono de huella animado             |
| `success`         | Biometría verificada               | Navegación automática al área protegida                   |
| `failed`          | Fallo biométrico (< 3 intentos)    | Mensaje "Intento fallido" + botón Reintentar              |
| `locked`          | 3 fallos consecutivos              | Redirección automática a `SignInScreen`                   |

---

## Widgets / Providers asociados

| Nombre                  | Tipo                    | Descripción                                               |
| ----------------------- | ----------------------- | --------------------------------------------------------- |
| `BiometricScreen`       | `ConsumerWidget`        | Pantalla de desbloqueo biométrico al abrir la app         |
| `biometricProvider`     | `StateNotifierProvider` | Estado de autenticación biométrica y contador de fallos   |
| `BiometricService`      | `class`                 | Encapsula `local_auth`: disponibilidad y autenticación    |
| `LocalAuthentication`   | `class` (local_auth)    | API nativa de biometría                                   |

---

## Reglas de negocio

- **RN-016.1:** La preferencia `biometric_enabled` se guarda en `flutter_secure_storage`
  (cifrado por el SO), no en `shared_preferences`.
- **RN-016.2:** La biometría solo autentica contra el SO local; Supabase no participa
  en este flujo; el token de sesión ya está guardado de la sesión previa.
- **RN-016.3:** En Flutter Web no hay `local_auth`; la opción de activar biometría
  no se muestra en Web.
- **RN-016.4:** Tras 3 fallos biométricos, el contador se resetea al iniciar sesión
  correctamente por contraseña.
