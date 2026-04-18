<!--
  ¿Qué? Historia de usuario sobre la navegación por el catálogo de módulos del
  showcase desde la pantalla Home.
  ¿Para qué? Justificar la pantalla raíz HomeScreen y el módulo navigation/ con
  go_router, deep linking y NavigationBar.
  ¿Impacto? Cubre RF-019 y RF-021.
-->

# HU-015 — Explorar el catálogo de módulos del showcase

## Identificación

| Campo           | Valor                                         |
| --------------- | --------------------------------------------- |
| **ID**          | HU-015                                        |
| **Título**      | Explorar el catálogo de módulos del showcase  |
| **Módulo**      | `lib/modules/navigation/`                     |
| **Prioridad**   | Alta                                          |
| **Estado**      | Pendiente                                     |
| **RF asociados**| RF-019, RF-021                                |

---

## Historia

**Como** desarrollador Flutter en formación,
**quiero** ver desde la pantalla principal todos los módulos disponibles del showcase
con la tecnología que demuestran y el soporte de plataforma de cada uno,
**para** navegar directamente al módulo que me interesa aprender.

---

## Criterios de aceptación

### CA-015.1 — Cuadrícula de módulos en Home

**Dado** que el usuario abre la app por primera vez,
**cuando** la pantalla Home carga,
**entonces** se muestra una cuadrícula con una tarjeta por cada módulo disponible;
cada tarjeta tiene el icono, nombre y tecnología Flutter demostrada.

### CA-015.2 — Indicadores de soporte de plataforma

**Dado** que el usuario observa la tarjeta del módulo "Cámara AR",
**cuando** está usando la app en Android,
**entonces** la tarjeta muestra ✓ Android, ✗ Web (con tooltip explicativo), ⏳ iOS.

### CA-015.3 — Búsqueda de módulos

**Dado** que el usuario escribe "animac" en el SearchBar del AppBar,
**cuando** el filtro se aplica,
**entonces** la cuadrícula muestra solo las tarjetas de módulos cuyo nombre o
tecnología contenga "animac" (sin distinguir mayúsculas ni acentos).

### CA-015.4 — Navegación al módulo

**Dado** que el usuario toca la tarjeta de "Rastreo ISS",
**cuando** la navegación se completa,
**entonces** la pantalla `IssMapScreen` está activa y el tab de NavigationBar
correspondiente queda seleccionado.

### CA-015.5 — Deep link a un módulo específico

**Dado** que un usuario recibe el link `cosmos://animations`,
**cuando** abre el link desde fuera de la app,
**entonces** la app se abre directamente en la pantalla `OrbitAnimationScreen`.

### CA-015.6 — NavigationBar persistente

**Dado** que el usuario navega entre secciones usando los tabs del NavigationBar,
**cuando** cambia de tab,
**entonces** el NavigationBar permanece visible en la parte inferior en todas las
pantallas principales; desaparece solo al entrar a pantallas de detalle.
