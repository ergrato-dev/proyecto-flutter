<!--
  ¿Qué? Historia de usuario sobre el desbloqueo rápido de la app mediante
  biometría (huella / Face ID).
  ¿Para qué? Justificar el módulo auth/ con local_auth y flutter_secure_storage.
  ¿Impacto? Cubre RF-016. Requiere HU-011 (sesión previa).
-->

# HU-012 — Iniciar sesión con biometría

## Identificación

| Campo           | Valor                            |
| --------------- | -------------------------------- |
| **ID**          | HU-012                           |
| **Título**      | Iniciar sesión con biometría     |
| **Módulo**      | `lib/modules/auth/`              |
| **Prioridad**   | Media                            |
| **Estado**      | Pendiente                        |
| **RF asociados**| RF-016                           |

---

## Historia

**Como** usuario registrado,
**quiero** poder desbloquear la app con mi huella dactilar o Face ID,
**para** acceder a mi cuenta de forma rápida sin tener que escribir mi contraseña
cada vez.

---

## Criterios de aceptación

### CA-012.1 — Activar biometría desde el perfil

**Dado** que el usuario tiene sesión activa y biometría enrollada en el dispositivo,
**cuando** va a Perfil → Seguridad y activa el toggle "Biometría",
**entonces** se solicita una autenticación biométrica de verificación; si es exitosa,
el toggle queda activado y las sesiones futuras usarán biometría.

### CA-012.2 — Desbloqueo al abrir la app

**Dado** que el usuario tiene la biometría activada y reabre la app,
**cuando** tiene una sesión de Supabase válida (< 30 días),
**entonces** se muestra la pantalla de desbloqueo biométrico antes del área protegida.

### CA-012.3 — Fallback a contraseña tras 3 fallos

**Dado** que el usuario falla la biometría 3 veces consecutivas,
**cuando** ocurre el tercer fallo,
**entonces** la app redirige automáticamente a la pantalla de inicio de sesión con
email y contraseña.

### CA-012.4 — Opción de usar contraseña manualmente

**Dado** que el usuario está en la pantalla de desbloqueo biométrico,
**cuando** pulsa "Usar contraseña",
**entonces** navega a la pantalla de inicio de sesión con email y contraseña sin
consumir intentos biométricos.

### CA-012.5 — Hardware no disponible

**Dado** que el dispositivo no tiene sensor biométrico o no tiene huella enrollada,
**cuando** el usuario va a Perfil → Seguridad,
**entonces** el toggle de biometría aparece deshabilitado con el mensaje "Tu
dispositivo no soporta autenticación biométrica".

### CA-012.6 — No disponible en Web

**Dado** que el usuario accede a la app desde Flutter Web,
**cuando** navega a la pantalla de seguridad del perfil,
**entonces** la opción de biometría no se muestra; solo están disponibles las
opciones compatibles con Web.
