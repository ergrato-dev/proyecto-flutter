<!--
  ¿Qué? Historia de usuario sobre la búsqueda de asteroides cercanos a la Tierra
  por rango de fechas usando la API NASA NeoWs.
  ¿Para qué? Justificar el módulo forms/ con reactive_forms y validadores personalizados.
  ¿Impacto? Cubre RF-003 y RF-006 (historial de búsquedas).
-->

# HU-006 — Buscar asteroides por rango de fechas

## Identificación

| Campo           | Valor                                   |
| --------------- | --------------------------------------- |
| **ID**          | HU-006                                  |
| **Título**      | Buscar asteroides por rango de fechas   |
| **Módulo**      | `lib/modules/forms/`                    |
| **Prioridad**   | Alta                                    |
| **Estado**      | Pendiente                               |
| **RF asociados**| RF-003, RF-006                          |

---

## Historia

**Como** estudiante de astronomía,
**quiero** buscar qué asteroides pasarán cerca de la Tierra en un período de fechas
determinado,
**para** identificar objetos potencialmente peligrosos y entender la frecuencia de
aproximaciones de asteroides.

---

## Criterios de aceptación

### CA-006.1 — Formulario con validación en tiempo real

**Dado** que el usuario abre el formulario de búsqueda de asteroides,
**cuando** establece una fecha de fin anterior a la fecha de inicio,
**entonces** aparece inmediatamente bajo el campo de fecha fin el mensaje "La fecha
fin debe ser posterior a la fecha inicio"; el botón Buscar permanece deshabilitado.

### CA-006.2 — Límite de 7 días en el rango

**Dado** que el usuario selecciona un rango de fechas de 10 días,
**cuando** el formulario valida los campos,
**entonces** se muestra el error "El rango no puede superar 7 días" y el botón Buscar
queda deshabilitado.

### CA-006.3 — Resultados con badge PHA

**Dado** que la búsqueda devuelve resultados con asteroides potencialmente peligrosos,
**cuando** la lista se muestra,
**entonces** los asteroides PHA aparecen al inicio de la lista con un badge rojo "PHA".

### CA-006.4 — Filtro de distancia local

**Dado** que el usuario define una distancia máxima de 0.05 UA,
**cuando** los resultados se muestran,
**entonces** solo se ven los asteroides cuya distancia mínima es ≤ 0.05 UA; el
filtro se aplica localmente sin nueva petición.

### CA-006.5 — Búsqueda recuperable desde historial

**Dado** que el usuario ya realizó una búsqueda exitosa,
**cuando** vuelve al formulario de búsqueda,
**entonces** la búsqueda anterior aparece como chip en el historial; al tocarlo,
los campos se rellenan automáticamente.

### CA-006.6 — Error de límite de API

**Dado** que el usuario ha alcanzado el límite de peticiones de la API NASA,
**cuando** intenta una nueva búsqueda,
**entonces** aparece el mensaje "Límite de peticiones alcanzado — intenta de nuevo
en una hora" y se puede reintentar con el botón correspondiente.
