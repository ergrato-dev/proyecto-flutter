<!--
  ¿Qué? Requisito funcional que define el mapa de estrellas interactivo controlado
  por el giroscopio del dispositivo.
  ¿Para qué? Documentar el módulo sensors/ que demuestra sensors_plus con
  CustomPainter y coordenadas esféricas reales.
  ¿Impacto? Afecta a HU-010. Módulo sensible a disponibilidad de hardware.
-->

# RF-012 — Star map con giroscopio

## Identificación

| Campo           | Valor                              |
| --------------- | ---------------------------------- |
| **ID**          | RF-012                             |
| **Nombre**      | Star map con giroscopio            |
| **Módulo**      | `lib/modules/sensors/`             |
| **Prioridad**   | Media                              |
| **Estado**      | Pendiente                          |
| **Fecha**       | Abril 2026                         |
| **HU asociada** | HU-010                             |

---

## Descripción

La pantalla `StarMapScreen` renderiza un mapa de estrellas usando `CustomPainter`.
Cuando el dispositivo dispone de giroscopio, el canvas gira según la orientación
real del dispositivo (datos de `sensors_plus`). Si no hay giroscopio, el usuario
puede desplazar el mapa con `GestureDetector` (drag). Se incluyen 120 estrellas de
la catálogo Hipparcos con sus coordenadas RA/Dec reales y magnitud aparente.

---

## Parámetros de entrada

| Parámetro        | Tipo Dart | Obligatorio | Validaciones / Notas                                          |
| ---------------- | --------- | ----------- | ------------------------------------------------------------- |
| `initialLat`     | `double?` | No          | Latitud del observador; si nula, centro de la pantalla        |
| `initialLon`     | `double?` | No          | Longitud del observador; si nula, se usa [0,0]                |
| `observationDate`| `DateTime`| No          | Para calcular el tiempo sidéreo local; default: ahora         |

---

## Flujo

1. El usuario navega a **Star Map** desde el menú principal.
2. `StarMapScreen` inicializa `StarMapPainter` con la lista de 120 estrellas
   estáticas (RA, Dec, magnitud, nombre).
3. El provider `gyroscopeAvailabilityProvider` verifica si el dispositivo tiene
   giroscopio (intento de suscripción + timeout de 500 ms).
4. **Con giroscopio:**
   a. `gyroscopeProvider` (`StreamProvider`) suscribe al stream de
      `gyroscopeEventStream()` de `sensors_plus`.
   b. Cada evento actualiza `azimuth` y `altitude` que se pasan a `StarMapPainter`.
   c. El canvas redibuja en cada frame del `AnimationController` (60 fps).
5. **Sin giroscopio:**
   a. Se muestra un banner "Giroscopio no disponible — arrastra para explorar".
   b. `GestureDetector.onPanUpdate` actualiza la misma propiedad `azimuth`/`altitude`.
6. Tapping en una estrella muestra un `Tooltip` con su nombre y magnitud.
7. El botón **Calibrar** centra la vista en el cénit del observador.
8. Botón **Modo noche** (toggle): cambia la paleta a rojo oscuro sobre negro para
   preservar la visión nocturna del observador.

---

## Estados y salidas

| Estado           | Condición                          | Widget mostrado                                           |
| ---------------- | ---------------------------------- | --------------------------------------------------------- |
| `gyroActive`     | Giroscopio disponible y activo     | Canvas girando suavemente con orientación real            |
| `gestureMode`    | Sin giroscopio                     | Banner informativo + canvas movible por drag              |
| `loading`        | Verificando disponibilidad         | CircularProgressIndicator superpuesto 500 ms              |
| `nightMode`      | Modo noche activo                  | Paleta roja; todas las UI en tonos rojo oscuro            |

---

## Widgets / Providers asociados

| Nombre                           | Tipo                  | Descripción                                              |
| -------------------------------- | --------------------- | -------------------------------------------------------- |
| `StarMapScreen`                  | `ConsumerStatefulWidget` | Pantalla principal con canvas y controles             |
| `gyroscopeProvider`              | `StreamProvider`      | Stream de eventos del giroscopio                         |
| `gyroscopeAvailabilityProvider`  | `FutureProvider`      | Detecta si el hardware giroscopio está presente          |
| `StarMapPainter`                 | `CustomPainter`       | Dibuja estrellas proyectadas según orientación           |
| `starCatalogProvider`            | `Provider`            | Lista estática de 120 estrellas (RA, Dec, magnitud)      |

---

## Reglas de negocio

- **RN-012.1:** En Flutter Web no hay acceso al giroscopio; siempre se activa el
  modo gesture y no se muestra el intento de acceso al sensor.
- **RN-012.2:** El tamaño del punto de cada estrella en el canvas es inversamente
  proporcional a su magnitud aparente: mag 1 → radio 4 dp, mag 6 → radio 1 dp.
- **RN-012.3:** El canvas no redibuja si el cambio de ángulo es menor a 0.01 rad
  para reducir el trabajo del GPU thread.
- **RN-012.4:** El stream del giroscopio se cancela en `ref.onDispose` para no
  agotar la batería del dispositivo.
