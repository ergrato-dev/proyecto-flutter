<!--
  ¿Qué? Requisito funcional que define el overlay AR de constelaciones sobre la
  imagen de la cámara del dispositivo.
  ¿Para qué? Documentar el módulo camera/ con el plugin camera, flutter_svg y
  sensors_plus para alineación del overlay.
  ¿Impacto? Afecta al módulo platform/ por diferencias de permisos. Requiere hardware real.
-->

# RF-014 — Cámara AR con overlay de constelaciones

## Identificación

| Campo           | Valor                                       |
| --------------- | ------------------------------------------- |
| **ID**          | RF-014                                      |
| **Nombre**      | Cámara AR con overlay de constelaciones     |
| **Módulo**      | `lib/modules/camera/`                       |
| **Prioridad**   | Baja                                        |
| **Estado**      | Pendiente                                   |
| **Fecha**       | Abril 2026                                  |
| **HU asociada** | —                                           |

---

## Descripción

La pantalla `ConstellationCameraScreen` superpone un overlay SVG de constelaciones
sobre la imagen en tiempo real de la cámara trasera del dispositivo. El overlay se
alinea con la orientación real del cielo usando el giroscopio y acelerómetro. En
Flutter Web, la cámara se sustituye por un fondo negro estático con el overlay, ya
que el plugin `camera` no está soportado en Web.

---

## Parámetros de entrada

| Parámetro          | Tipo Dart | Obligatorio | Validaciones / Notas                                        |
| ------------------ | --------- | ----------- | ----------------------------------------------------------- |
| `constellationSet` | `String`  | No          | `'IAU88'` o `'custom'`; default `'IAU88'` (88 constelaciones) |

---

## Flujo

1. El usuario navega a **AR Constelaciones** desde el menú principal.
2. `permission_handler` solicita permiso de cámara:
   - Si denegado: muestra `CameraPermissionDeniedWidget` con botón a ajustes.
3. Si permitido: `CameraController` inicializa la cámara trasera en resolución
   `medium` para optimizar el rendimiento.
4. `CameraPreview` llena la pantalla completa (modo landscape).
5. Un `Stack` superpone `ConstellationOverlay` (widget SVG con `flutter_svg`)
   sobre el `CameraPreview`.
6. El gyroscopio de `sensors_plus` actualiza el `Transform.rotate` del overlay para
   que las constelaciones sigan la orientación real del dispositivo.
7. Botón **Constelación activa** (lista desplegable): filtra qué constelaciones se
   muestran (todas / zodiacales / visibles en la latitud del usuario).
8. Tapping en una constelación muestra `BottomSheet` con su nombre, mitos y estrellas
   principales.
9. Botón **Captura** (ícono cámara): toma foto con el overlay incluido usando
   `CameraController.takePicture()` y comparte con `Share.shareXFiles`.

---

## Estados y salidas

| Estado              | Condición                          | Widget mostrado                                         |
| ------------------- | ---------------------------------- | ------------------------------------------------------- |
| `permissionDenied`  | Permiso cámara denegado            | `CameraPermissionDeniedWidget` con botón a ajustes      |
| `initializing`      | Cámara inicializando               | `CircularProgressIndicator` centrado en negro           |
| `active`            | Cámara activa con overlay          | `CameraPreview` + `ConstellationOverlay` superpuesto    |
| `webFallback`       | Flutter Web detectado              | Fondo negro + overlay SVG + aviso "Cámara no disponible en Web" |

---

## Widgets / Providers asociados

| Nombre                         | Tipo                     | Descripción                                               |
| ------------------------------ | ------------------------ | --------------------------------------------------------- |
| `ConstellationCameraScreen`    | `ConsumerStatefulWidget` | Pantalla principal con cámara y overlay                   |
| `ConstellationOverlay`         | `StatelessWidget`        | SVG de constelaciones con `flutter_svg`                   |
| `cameraControllerProvider`     | `StateNotifierProvider`  | Ciclo de vida del `CameraController`                      |
| `constellationDataProvider`    | `Provider`               | Lista de constelaciones con polígonos de estrellas        |

---

## Reglas de negocio

- **RN-014.1:** En Flutter Web se detecta con `kIsWeb`; el `CameraController` nunca
  se inicializa y el módulo muestra el overlay estático.
- **RN-014.2:** La cámara se inicializa con `ResolutionPreset.medium` para mantener
  el rendimiento del overlay; no se usa `high` o `max`.
- **RN-014.3:** `CameraController.dispose()` se llama siempre en `State.dispose()`
  para liberar los recursos de la cámara.
- **RN-014.4:** La captura de foto incluye el overlay SVG fusionado sobre la imagen;
  esto se implementa con `RenderRepaintBoundary.toImage()` antes de compartir.
