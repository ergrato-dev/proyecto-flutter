<!--
  ¿Qué? Historia de usuario que describe la necesidad de ver las órbitas planetarias
  animadas con velocidades proporcionales a la realidad.
  ¿Para qué? Justificar el módulo animations/ con AnimationController + CustomPainter.
  ¿Impacto? Cubre RF-013.
-->

# HU-003 — Ver animación de órbitas planetarias

## Identificación

| Campo           | Valor                             |
| --------------- | --------------------------------- |
| **ID**          | HU-003                            |
| **Título**      | Ver animación de órbitas planetarias |
| **Módulo**      | `lib/modules/animations/`         |
| **Prioridad**   | Media                             |
| **Estado**      | Pendiente                         |
| **RF asociados**| RF-013                            |

---

## Historia

**Como** estudiante de astronomía,
**quiero** ver una visualización animada de las órbitas de los planetas interiores
con velocidades proporcionales a los períodos orbitales reales,
**para** entender intuitivamente las diferencias de velocidad entre planetas y el
concepto de año terrestre.

---

## Criterios de aceptación

### CA-003.1 — Animación con períodos reales

**Dado** que el usuario abre la pantalla de Órbitas,
**cuando** la animación está en marcha,
**entonces** Mercurio completa su órbita aproximadamente 4 veces más rápido que la
Tierra, reflejando los períodos orbitales reales.

### CA-003.2 — Pausa y reanudación

**Dado** que la animación está en marcha,
**cuando** el usuario toca el botón Pausar,
**entonces** la animación se detiene en el fotograma actual; al tocar Reanudar,
continúa desde el mismo punto.

### CA-003.3 — Control de velocidad

**Dado** que el usuario está en la pantalla de Órbitas,
**cuando** mueve el slider de velocidad al valor 5x,
**entonces** las órbitas se animan 5 veces más rápido que en tiempo real.

### CA-003.4 — Rotación 3D del plano orbital

**Dado** que el usuario está viendo las órbitas en vista cenital,
**cuando** arrastra el canvas con un dedo,
**entonces** el plano orbital se inclina simulando una perspectiva 3D.

### CA-003.5 — Identificación de planetas

**Dado** que la animación está corriendo,
**cuando** el usuario toca un planeta,
**entonces** aparece una etiqueta animada con el nombre del planeta y su período
orbital en días.

### CA-003.6 — Fluidez a 60 fps

**Dado** que la animación está en marcha en un dispositivo Android mid-range,
**cuando** el usuario observa el Performance overlay,
**entonces** no se detectan jank frames (frames > 32 ms) durante al menos 30 segundos
de animación continua.
