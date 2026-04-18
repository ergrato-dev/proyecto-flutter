<!--
  ¿Qué? Historia de usuario que describe la necesidad de consultar información
  detallada de un cuerpo celeste específico.
  ¿Para qué? Justificar el desarrollo de BodyDetailScreen con secciones de datos
  físicos, orbitales y lista de cuerpos relacionados.
  ¿Impacto? Cubre RF-002. Depende de HU-001 para la navegación.
-->

# HU-002 — Consultar el detalle de un cuerpo celeste

## Identificación

| Campo           | Valor                              |
| --------------- | ---------------------------------- |
| **ID**          | HU-002                             |
| **Título**      | Consultar el detalle de un cuerpo celeste |
| **Módulo**      | `lib/modules/lists/`               |
| **Prioridad**   | Alta                               |
| **Estado**      | Pendiente                          |
| **RF asociados**| RF-002, RF-005                     |

---

## Historia

**Como** estudiante de astronomía,
**quiero** ver información física y orbital detallada de un cuerpo celeste específico,
**para** entender sus propiedades y compararlas con otros cuerpos del sistema solar.

---

## Criterios de aceptación

### CA-002.1 — Visualización de datos físicos

**Dado** que el usuario navega al detalle de la Tierra,
**cuando** la pantalla carga,
**entonces** se muestran: masa (kg), radio (km), densidad (g/cm³), gravedad (m/s²),
velocidad de escape (km/s) y temperatura media (K).

### CA-002.2 — Visualización de datos orbitales

**Dado** que el usuario navega al detalle de Marte,
**cuando** la pantalla muestra la sección orbital,
**entonces** se muestran: período orbital (días), distancia al Sol (UA), excentricidad
e inclinación (grados).

### CA-002.3 — Sección de atmósfera siempre visible

**Dado** que el usuario navega al detalle de un cuerpo sin atmósfera (ej. Luna),
**cuando** la pantalla carga la sección de atmósfera,
**entonces** se muestra la sección con el texto "Sin atmósfera conocida" en lugar
de omitir la sección.

### CA-002.4 — Valores nulos formateados

**Dado** que el usuario navega al detalle de un asteroide con masa desconocida,
**cuando** la pantalla muestra los datos físicos,
**entonces** los campos con valor nulo muestran "—" y no un error ni texto vacío.

### CA-002.5 — Agregar y quitar favorito

**Dado** que el usuario está en el detalle de Júpiter,
**cuando** toca el ícono de corazón en la cabecera,
**entonces** el ícono cambia a relleno con animación y el cuerpo queda en la lista
de favoritos (RF-005); al tocar de nuevo, se elimina de favoritos.

### CA-002.6 — Deep link desde fuera de la app

**Dado** que un usuario recibe el enlace `cosmos://bodies/terre`,
**cuando** abre el enlace desde el sistema operativo,
**entonces** la app abre directamente la pantalla de detalle de la Tierra.

### CA-002.7 — Cuerpos relacionados

**Dado** que el usuario está en el detalle de Saturno,
**cuando** la pantalla carga,
**entonces** la sección "Cuerpos relacionados" muestra la lista de sus lunas principales
con posibilidad de navegar a cada una.
