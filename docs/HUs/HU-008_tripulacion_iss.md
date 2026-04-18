<!--
  ¿Qué? Historia de usuario sobre la consulta de la tripulación actual de la ISS.
  ¿Para qué? Justificar la sub-pantalla de tripulación del módulo maps/.
  ¿Impacto? Cubre RF-008. Complementa HU-007.
-->

# HU-008 — Conocer la tripulación actual de la ISS

## Identificación

| Campo           | Valor                                   |
| --------------- | --------------------------------------- |
| **ID**          | HU-008                                  |
| **Título**      | Conocer la tripulación actual de la ISS |
| **Módulo**      | `lib/modules/maps/`                     |
| **Prioridad**   | Media                                   |
| **Estado**      | Pendiente                               |
| **RF asociados**| RF-008                                  |

---

## Historia

**Como** entusiasta del espacio,
**quiero** saber quiénes están actualmente a bordo de la ISS y de qué país son,
**para** poner nombre y cara a las personas que orbitan la Tierra en este momento.

---

## Criterios de aceptación

### CA-008.1 — Lista de tripulantes

**Dado** que el usuario accede a la pestaña Tripulación dentro de la pantalla ISS,
**cuando** la app carga los datos de Open-Notify,
**entonces** se muestra la lista de todos los astronautas actualmente en el espacio
con nombre y nave asignada.

### CA-008.2 — Avatar de astronauta

**Dado** que la lista de tripulantes se muestra,
**cuando** la Wikipedia API devuelve una imagen para un astronauta,
**entonces** su avatar muestra la foto real; si no hay foto disponible, se muestra
un avatar con sus iniciales en lugar de una imagen rota.

### CA-008.3 — Caché de 1 hora

**Dado** que el usuario ya cargó la tripulación hace 30 minutos y cierra la app,
**cuando** vuelve a abrir la app y navega a la tripulación,
**entonces** la lista se muestra inmediatamente desde la caché sin petición de red.

### CA-008.4 — Actualización manual

**Dado** que el usuario está en la lista de tripulación,
**cuando** pulsa el botón Actualizar,
**entonces** la caché se invalida, se hace una nueva petición a Open-Notify y la
lista se actualiza con los datos más recientes.

### CA-008.5 — Estado de carga con skeleton

**Dado** que la app está obteniendo la tripulación por primera vez,
**cuando** la petición está en curso,
**entonces** se muestran 4 ítems skeleton con la forma del avatar + texto, no una
pantalla en blanco.
