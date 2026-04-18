<!--
  ¿Qué? Historia de usuario que describe la necesidad de explorar el catálogo
  completo del sistema solar con filtros.
  ¿Para qué? Justificar el desarrollo del módulo lists/ (RF-001 y RF-002) desde
  la perspectiva del usuario del showcase.
  ¿Impacto? Cubre los requisitos funcionales de mayor prioridad del módulo lists/.
-->

# HU-001 — Explorar el catálogo de planetas y cuerpos celestes

## Identificación

| Campo           | Valor                                 |
| --------------- | ------------------------------------- |
| **ID**          | HU-001                                |
| **Título**      | Explorar el catálogo de cuerpos celestes |
| **Módulo**      | `lib/modules/lists/`                  |
| **Prioridad**   | Alta                                  |
| **Estado**      | Pendiente                             |
| **RF asociados**| RF-001, RF-002                        |

---

## Historia

**Como** estudiante de astronomía,
**quiero** explorar una lista completa de planetas, lunas, asteroides y cometas del
sistema solar con posibilidad de filtrar por tipo,
**para** aprender las características de cada cuerpo celeste de forma visual e interactiva.

---

## Criterios de aceptación

### CA-001.1 — Visualización del catálogo completo

**Dado** que el usuario abre la sección Planetas,
**cuando** la app carga los datos de la API Solar System OpenData,
**entonces** se muestra una lista de todos los cuerpos celestes disponibles agrupados
por tipo (planetas, lunas, asteroides, cometas).

### CA-001.2 — Filtrado por tipo de cuerpo

**Dado** que el usuario está en el catálogo con todos los cuerpos visibles,
**cuando** selecciona el filtro "Planetas" en el selector de tipo,
**entonces** la lista se actualiza inmediatamente mostrando solo los 8 planetas del
sistema solar, sin recargar datos de red.

### CA-001.3 — Búsqueda por nombre

**Dado** que el usuario está en el catálogo,
**cuando** escribe "marte" en la barra de búsqueda,
**entonces** la lista se filtra mostrando solo los cuerpos cuyo nombre contiene
"marte" (insensible a mayúsculas y acentos).

### CA-001.4 — Estado de carga con skeleton

**Dado** que el usuario abre el catálogo por primera vez sin datos en caché,
**cuando** la petición a la API está en curso,
**entonces** se muestra una lista de esqueletos animados en lugar de una pantalla en blanco.

### CA-001.5 — Modo offline con caché

**Dado** que el usuario ya visitó el catálogo (datos en caché),
**cuando** pierde la conexión a internet y abre el catálogo,
**entonces** la app muestra los datos de caché con un badge "Datos desactualizados"
y la fecha de la última actualización.

### CA-001.6 — Navegación al detalle

**Dado** que el usuario está en el catálogo,
**cuando** toca cualquier cuerpo celeste de la lista,
**entonces** la app navega a la pantalla de detalle de ese cuerpo (HU-002).
