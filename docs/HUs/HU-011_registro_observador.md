<!--
  ¿Qué? Historia de usuario sobre el registro de una nueva cuenta de observador.
  ¿Para qué? Justificar el módulo auth/ con Supabase Auth y reactive_forms.
  ¿Impacto? Cubre RF-015. Habilita HU-012 y HU-013.
-->

# HU-011 — Registrarse como observador astronómico

## Identificación

| Campo           | Valor                                     |
| --------------- | ----------------------------------------- |
| **ID**          | HU-011                                    |
| **Título**      | Registrarse como observador astronómico   |
| **Módulo**      | `lib/modules/auth/`                       |
| **Prioridad**   | Alta                                      |
| **Estado**      | Pendiente                                 |
| **RF asociados**| RF-015                                    |

---

## Historia

**Como** aficionado a la astronomía,
**quiero** crear una cuenta en la app con mi email y contraseña,
**para** acceder al diario de observaciones personal y guardar mis registros en la nube.

---

## Criterios de aceptación

### CA-011.1 — Formulario de registro válido

**Dado** que el usuario abre la pantalla de registro,
**cuando** introduce un email válido, una contraseña de al menos 8 caracteres con
una mayúscula y un dígito, y un nombre de 2 a 50 caracteres,
**entonces** el botón Registrarse se habilita.

### CA-011.2 — Validación en tiempo real de contraseña

**Dado** que el usuario está escribiendo la contraseña,
**cuando** la contraseña no cumple los requisitos mínimos,
**entonces** aparece el mensaje "La contraseña debe tener al menos 8 caracteres,
una mayúscula y un dígito" bajo el campo, en tiempo real.

### CA-011.3 — Registro exitoso y email de confirmación

**Dado** que el usuario completa el formulario correctamente,
**cuando** pulsa Registrarse,
**entonces** Supabase envía el email de confirmación y la app navega a una pantalla
que indica "Revisa tu correo para confirmar la cuenta".

### CA-011.4 — Email ya registrado

**Dado** que el usuario intenta registrarse con un email ya existente,
**cuando** la API devuelve el error correspondiente,
**entonces** aparece el mensaje "Este email ya está registrado" bajo el campo de
email; el formulario no se bloquea para que pueda corregirlo.

### CA-011.5 — Visibilidad de la contraseña

**Dado** que el usuario está completando el formulario,
**cuando** toca el ícono de ojo en el campo de contraseña,
**entonces** el texto de la contraseña se hace visible; al tocar de nuevo, vuelve
a estar oculto.

### CA-011.6 — Inicio de sesión tras registro

**Dado** que el usuario confirma su email,
**cuando** abre la app e introduce sus credenciales correctamente,
**entonces** accede al área protegida y puede usar el diario de observaciones.
