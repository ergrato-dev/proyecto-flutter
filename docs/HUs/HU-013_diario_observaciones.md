<!--
  ¿Qué? Historia de usuario sobre el registro y gestión del diario personal de
  observaciones astronómicas.
  ¿Para qué? Justificar el CRUD del módulo auth/ con Supabase y RLS.
  ¿Impacto? Cubre RF-017. Requiere sesión activa (HU-011).
-->

# HU-013 — Registrar observaciones astronómicas en el diario

## Identificación

| Campo           | Valor                                         |
| --------------- | --------------------------------------------- |
| **ID**          | HU-013                                        |
| **Título**      | Registrar observaciones astronómicas en el diario |
| **Módulo**      | `lib/modules/auth/`                           |
| **Prioridad**   | Media                                         |
| **Estado**      | Pendiente                                     |
| **RF asociados**| RF-017                                        |

---

## Historia

**Como** observador astronómico registrado,
**quiero** llevar un diario de mis observaciones con fecha, objeto observado,
condiciones del cielo y fotos,
**para** recordar mis sesiones de observación y seguir mi progreso como astrónomo aficionado.

---

## Criterios de aceptación

### CA-013.1 — Crear nueva observación

**Dado** que el usuario está en el diario y pulsa el botón +,
**cuando** completa el formulario con fecha, nombre del objeto, seeing (1-5 estrellas)
y notas opcionales,
**entonces** al guardar la nueva entrada aparece al inicio de la lista con todos
sus datos.

### CA-013.2 — Adjuntar foto a la observación

**Dado** que el usuario está creando una observación,
**cuando** toca el botón de cámara/galería en el formulario,
**entonces** puede seleccionar una foto de la galería o tomar una nueva con la
cámara; la foto se muestra como miniatura en el formulario.

### CA-013.3 — Lista de observaciones ordenada por fecha

**Dado** que el usuario tiene múltiples observaciones registradas,
**cuando** abre el diario,
**entonces** las observaciones aparecen ordenadas por fecha descendente (la más
reciente primero).

### CA-013.4 — Editar observación existente

**Dado** que el usuario toca una entrada en el diario,
**cuando** el formulario se abre con los datos pre-rellenos y hace cambios,
**entonces** al guardar la entrada se actualiza con los nuevos valores en la lista.

### CA-013.5 — Eliminar observación con confirmación

**Dado** que el usuario desliza una entrada del diario hacia la izquierda,
**cuando** confirma la eliminación en el AlertDialog,
**entonces** la entrada desaparece de la lista y si tenía foto asociada, también
se elimina del almacenamiento de Supabase.

### CA-013.6 — Privacidad de las observaciones

**Dado** que dos usuarios diferentes están registrados en la app,
**cuando** el usuario A consulta su diario,
**entonces** solo ve sus propias observaciones; nunca las del usuario B (RLS garantiza
el aislamiento).

### CA-013.7 — Sin acceso sin sesión

**Dado** que un usuario no autenticado intenta acceder directamente a la ruta
`/profile/diary`,
**cuando** go_router evalúa el guard de autenticación,
**entonces** el usuario es redirigido a la pantalla de inicio de sesión.
