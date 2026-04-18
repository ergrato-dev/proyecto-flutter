<!--
  ¿Qué? Requisito no funcional que define los estándares de rendimiento y
  fluidez visual de la app CosmosFlutter.
  ¿Para qué? Garantizar una experiencia de usuario fluida a 60 fps en Android
  y Web, con tiempos de respuesta aceptables para operaciones de red.
  ¿Impacto? Afecta a todos los módulos con animaciones, listas y operaciones async.
-->

# RNF-001 — Rendimiento y fluidez

## Identificación

| Campo         | Valor                    |
| ------------- | ------------------------ |
| **ID**        | RNF-001                  |
| **Nombre**    | Rendimiento y fluidez    |
| **Categoría** | Performance              |
| **Prioridad** | Alta                     |
| **Estado**    | Pendiente                |

---

## Requisitos

### RNF-001.1 — Fluidez de animaciones a 60 fps

La app debe mantener 60 fps constantes durante animaciones (`OrbitPainter`,
`StarMapPainter`, transiciones de pantalla). Se mide con Flutter DevTools →
Performance overlay. Un frame no debe superar 16.67 ms en el UI thread ni en
el raster thread.

**Verificación:** `flutter run --profile` + Performance overlay activo. No se
aceptan jank frames (frames > 32 ms) en las pantallas de animación.

### RNF-001.2 — Tiempo de respuesta de listas

El scroll de `BodyListScreen` (catálogo solar) y de `AsteroidSearchScreen` debe
ser fluido con hasta 500 ítems. Se implementa con `ListView.builder` o
`SliverList` + `const` widgets donde sea posible. No se construyen widgets fuera
del viewport.

**Verificación:** Simular 500 ítems en test de widget; el frame time no debe
superar 8 ms durante el scroll.

### RNF-001.3 — Timeout de operaciones de red

Todas las peticiones HTTP configuradas en `Dio` deben tener:
- `connectTimeout`: 10 s
- `receiveTimeout`: 15 s
- `sendTimeout`: 10 s

Ante timeout, el sistema emite `AsyncError` con mensaje localizado en español.

**Verificación:** Test de integración simulando timeout con `MockAdapter` de Dio.

### RNF-001.4 — Tamaño del bundle inicial (Flutter Web)

El bundle Web inicial (sin caché) no debe superar 5 MB. Se activa deferred loading
para los módulos `camera` y `maps` (los de mayor peso).

**Verificación:** `flutter build web --release` + análisis con `dart2js --dump-info`.

### RNF-001.5 — Tiempo de arranque de la app

El tiempo desde el toque del ícono hasta el primer frame de `HomeScreen` no debe
superar:
- **Android**: 2 s (dispositivo mid-range, API 26+).
- **Web**: 3 s (conexión 4G simulada en Chrome DevTools).

**Verificación:** `flutter run --trace-startup` + medición manual en 3 dispositivos.
