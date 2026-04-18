<!--
  ¿Qué? Historia de usuario sobre la exploración de las diferencias de comportamiento
  de la app entre plataformas.
  ¿Para qué? Justificar el módulo platform/ como demostración académica de las
  capacidades y limitaciones de cada plataforma Flutter.
  ¿Impacto? Cubre RF-020.
-->

# HU-014 — Explorar las diferencias entre plataformas

## Identificación

| Campo           | Valor                                       |
| --------------- | ------------------------------------------- |
| **ID**          | HU-014                                      |
| **Título**      | Explorar las diferencias entre plataformas  |
| **Módulo**      | `lib/modules/platform/`                     |
| **Prioridad**   | Baja                                        |
| **Estado**      | Pendiente                                   |
| **RF asociados**| RF-020                                      |

---

## Historia

**Como** desarrollador Flutter en formación,
**quiero** ver cómo se comporta la misma app en Android, iOS y Web con las diferencias
de componentes visuales, permisos y APIs nativas,
**para** entender cuándo usar componentes adaptativos y cómo gestionar la degradación
por plataforma.

---

## Criterios de aceptación

### CA-014.1 — Identificación de plataforma

**Dado** que el usuario abre la pantalla de Comparativa de Plataformas en Android,
**cuando** la pantalla carga,
**entonces** se muestra el banner "Android {versión}" en la parte superior y los
componentes demostrados son los de Material 3.

### CA-014.2 — Demo de diálogos nativos

**Dado** que el usuario está en la sección de diálogos en iOS,
**cuando** pulsa el botón Demo,
**entonces** aparece un `CupertinoAlertDialog` nativo de iOS; en Android aparece
un `AlertDialog` de Material; en Web aparece un `AlertDialog` de Material.

### CA-014.3 — Demo de bottom sheets adaptativos

**Dado** que el usuario está en la sección de bottom sheets en iOS,
**cuando** pulsa el botón Demo,
**entonces** aparece un `CupertinoActionSheet`; en Android y Web aparece un
`showModalBottomSheet` de Material.

### CA-014.4 — Tabla de permisos en tiempo real

**Dado** que el usuario está en la sección de permisos,
**cuando** la pantalla carga,
**entonces** la tabla muestra el estado real de los permisos del dispositivo en
esa sesión (concedido / denegado / no disponible en esta plataforma).

### CA-014.5 — Demo de Switch adaptativo

**Dado** que el usuario interactúa con el `Switch.adaptive` en la demo,
**cuando** lo activa en iOS,
**entonces** se muestra el toggle estilo Cupertino; en Android se muestra el toggle
estilo Material.
