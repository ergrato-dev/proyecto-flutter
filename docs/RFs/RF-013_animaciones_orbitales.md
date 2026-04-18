<!--
  ¿Qué? Requisito funcional que define las animaciones orbitales de planetas con
  AnimationController y CustomPainter.
  ¿Para qué? Documentar el módulo animations/ que demuestra el pipeline de animación
  Flutter con velocidades proporcionales a períodos orbitales reales.
  ¿Impacto? Afecta a HU-003. Módulo puramente visual, sin dependencias de red.
-->

# RF-013 — Animaciones orbitales

## Identificación

| Campo           | Valor                           |
| --------------- | ------------------------------- |
| **ID**          | RF-013                          |
| **Nombre**      | Animaciones orbitales           |
| **Módulo**      | `lib/modules/animations/`       |
| **Prioridad**   | Media                           |
| **Estado**      | Pendiente                       |
| **Fecha**       | Abril 2026                      |
| **HU asociada** | HU-003                          |

---

## Descripción

La pantalla `OrbitAnimationScreen` muestra cuatro planetas (Mercurio, Venus, Tierra,
Marte) orbitando al Sol mediante `AnimationController` + `CustomPainter`. Las
velocidades angulares son proporcionales a los períodos orbitales reales. El usuario
puede pausar/reanudar, acelerar la simulación y rotar el plano orbital en 3D
arrastrando el canvas. Al pulsar sobre un planeta se muestra su nombre con
`AnimatedScale` + spring curve.

---

## Parámetros de entrada

| Parámetro        | Tipo Dart | Obligatorio | Validaciones / Notas                                     |
| ---------------- | --------- | ----------- | -------------------------------------------------------- |
| `speedMultiplier`| `double`  | No          | Factor de velocidad; rango 0.5 – 10; default 1.0         |
| `showLabels`     | `bool`    | No          | Muestra nombres de planetas; default `true`              |

---

## Flujo

1. El usuario navega a **Órbitas** desde el catálogo de módulos.
2. `OrbitAnimationScreen` crea un `AnimationController` con `vsync: this` y
   `duration: Duration(seconds: 365)` (representa 1 año terrestre).
3. `OrbitPainter` extiende `CustomPainter` y dibuja en cada tick:
   - Sol en el centro.
   - Cuatro elipses de órbita (líneas punteadas).
   - Cuatro discos de planeta en su posición angular actual.
4. El `AnimationController` avanza con `controller.repeat()`.
5. Las velocidades angulares se calculan:
   `ω = 2π / (periodDays × speedMultiplier × kDaysPerSecond)`.
6. Botón **Pausar / Reanudar**: llama a `controller.stop()` / `controller.forward()`.
7. Slider **Velocidad**: modifica `speedMultiplier`; el cambio es inmediato.
8. `GestureDetector.onPanUpdate`: acumula `tiltX` y `tiltY` para aplicar una
   transformación de perspectiva (`Matrix4`) al canvas, simulando rotación 3D.
9. Tocar un planeta muestra un `Tooltip` animado con su nombre y período orbital.

---

## Estados y salidas

| Estado    | Condición                  | Widget mostrado                                                 |
| --------- | -------------------------- | --------------------------------------------------------------- |
| `playing` | Animación en curso         | Canvas con planetas girando, botón Pausar activo               |
| `paused`  | Animación detenida         | Canvas estático, botón Reanudar activo                         |

---

## Widgets / Providers asociados

| Nombre                  | Tipo                    | Descripción                                               |
| ----------------------- | ----------------------- | --------------------------------------------------------- |
| `OrbitAnimationScreen`  | `StatefulWidget`        | Pantalla con `AnimationController` y controles            |
| `OrbitPainter`          | `CustomPainter`         | Dibuja Sol, órbitas y planetas en cada frame              |
| `planetDataProvider`    | `Provider`              | Lista estática de 4 planetas con radio, color y período   |
| `PlanetTooltip`         | `StatelessWidget`       | Tooltip animado con `AnimatedScale` + spring              |

---

## Reglas de negocio

- **RN-013.1:** La animación usa datos astronómicos reales de período orbital:
  Mercurio 87.97 días, Venus 224.70, Tierra 365.25, Marte 686.97.
- **RN-013.2:** `OrbitPainter` hereda de `CustomPainter` y sobreescribe
  `shouldRepaint` devolviendo `true` solo si cambió `animationValue` o `tilt`.
- **RN-013.3:** El `AnimationController` se hace `dispose()` en `State.dispose()`
  siempre, sin excepción, para liberar el `vsync` ticker.
- **RN-013.4:** En dispositivos con menos de 60 fps (detectados por `SchedulerBinding`),
  el painter puede reducir la complejidad visual (sin elipses punteadas) para
  mantener fluidez.
