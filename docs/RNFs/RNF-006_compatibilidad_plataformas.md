<!--
  ¿Qué? Requisito no funcional que define los estándares de compatibilidad de la app
  con las plataformas objetivo: Android, Web e iOS.
  ¿Para qué? Garantizar que la app funcione correctamente en las versiones mínimas
  soportadas de cada plataforma y degradar con gracia donde aplique.
  ¿Impacto? Afecta a todos los módulos que usan APIs nativas. Guía las decisiones
  de degradación en los módulos maps/, camera/, sensors/.
-->

# RNF-006 — Compatibilidad de plataformas

## Identificación

| Campo         | Valor                           |
| ------------- | ------------------------------- |
| **ID**        | RNF-006                         |
| **Nombre**    | Compatibilidad de plataformas   |
| **Categoría** | Portability / Compatibility     |
| **Prioridad** | Alta                            |
| **Estado**    | Pendiente                       |

---

## Requisitos

### RNF-006.1 — Versiones mínimas de plataforma

| Plataforma    | Versión mínima soportada     | Notas                                 |
| ------------- | ---------------------------- | ------------------------------------- |
| Android       | API 24 (Android 7.0)         | `minSdkVersion 24` en `build.gradle`  |
| iOS           | iOS 15.1                     | `IPHONEOS_DEPLOYMENT_TARGET = 15.1`   |
| Flutter Web   | Chrome 100+, Firefox 100+, Safari 16+ | `index.html` con metadatos de viewport |
| Flutter SDK   | 3.29.3 (stable)              | `environment.sdk: '>=3.7.2 <4.0.0'`  |

**Verificación:** `flutter build apk --min-sdk-version 24` sin errores; test de UI
en emulador con API 24.

### RNF-006.2 — Degradación de funcionalidades nativas en Web

Las funcionalidades que no están disponibles en Flutter Web deben degradar con
gracia:

| Funcionalidad            | Módulo     | Comportamiento en Web                              |
| ------------------------ | ---------- | -------------------------------------------------- |
| Cámara AR                | camera/    | Fondo negro + overlay SVG estático + aviso         |
| Giroscopio               | sensors/   | Modo gesture (drag) sin sensor                     |
| Mapa en tiempo real ISS  | maps/      | Mapa estático con última posición conocida         |
| Notificaciones locales   | notifications/ | Toggles deshabilitados con tooltip explicativo |
| Biometría                | auth/      | Opción oculta; no se muestra en Web                |
| Almacenamiento drift     | shared/    | En memoria (no persistente entre sesiones Web)     |

**Verificación:** Tests con `kIsWeb = true` simulado verificando el comportamiento
de degradación correcto para cada funcionalidad.

### RNF-006.3 — Pantallas responsivas

La app se adapta a pantallas desde 360 dp (móvil pequeño) hasta 1440 dp (escritorio
web) sin romper layouts. Se usan `LayoutBuilder`, `MediaQuery.of(context).size` y
`AdaptiveScaffold` para layouts de dos columnas en pantallas anchas (≥ 600 dp).

**Verificación:** Tests de widget con `MediaQuery` de diferentes tamaños; revisión
visual en Chrome con DevTools de dispositivos.

### RNF-006.4 — Permisos por plataforma

El archivo `AndroidManifest.xml` y `Info.plist` solo declaran los permisos
realmente utilizados. Los permisos se solicitan en tiempo de ejecución (no al
instalar la app) mediante `permission_handler` con rationale en español.

| Permiso                | Android                  | iOS                   | Web       |
| ---------------------- | ------------------------ | --------------------- | --------- |
| Cámara                 | `CAMERA`                 | `NSCameraUsageDescription` | getUserMedia (HTTPS) |
| Ubicación              | `ACCESS_FINE_LOCATION`   | `NSLocationWhenInUseUsageDescription` | Geolocation API |
| Notificaciones         | `POST_NOTIFICATIONS` (API 33+) | Sin declaración previa | No disponible |
| Almacenamiento (fotos) | `READ_MEDIA_IMAGES` (API 33+) | `NSPhotoLibraryUsageDescription` | File API |

**Verificación:** `aapt dump permissions app-release.apk` para verificar que no hay
permisos extras no declarados en este RF.
