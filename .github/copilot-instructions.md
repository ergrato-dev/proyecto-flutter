# Copilot Instructions — proyecto-flutter

Showcase app de **astronomía básica** en Flutter, para demostrar las capacidades del
framework en un contexto temático concreto. Prioridad de plataformas: **Android → Web → iOS**.

El hilo narrativo de la app es el cosmos: planetas, satélites, eventos astronómicos,
clima espacial y la Estación Espacial Internacional, proyecto Artemis. Cada módulo técnico de
Flutter se justifica con un caso de uso astronómico real.

---

## APIs astronómicas (abiertas / gratuitas)

| API                        | Base URL                                  | Auth             | Uso en la app                         |
| -------------------------- | ----------------------------------------- | ---------------- | ------------------------------------- |
| **NASA APOD**              | `https://api.nasa.gov/planetary/apod`     | API key gratuita | Imagen astronómica del día            |
| **NASA NeoWs**             | `https://api.nasa.gov/neo/rest/v1`        | API key gratuita | Asteroides cercanos a la Tierra       |
| **NASA DONKI**             | `https://api.nasa.gov/DONKI`              | API key gratuita | Clima espacial, tormentas solares     |
| **Solar System OpenData**  | `https://api.le-systeme-solaire.net/rest` | Sin auth         | Datos orbitales y físicos de planetas |
| **Open-Notify ISS**        | `http://api.open-notify.org/iss-now.json` | Sin auth         | Posición en tiempo real de la ISS     |
| **Open-Notify Astronauts** | `http://api.open-notify.org/astros.json`  | Sin auth         | Tripulantes actuales en el espacio    |

### Clave NASA

- Registrar en `https://api.nasa.gov/` (aprobación inmediata, gratuita).
- Guardar en `.env` como `NASA_API_KEY`.
- Usar `DEMO_KEY` solo para desarrollo inicial (límite: 30 req/hora por IP).

---

## Mapa módulo → tema astronómico

| Módulo Flutter   | Caso de uso astronómico                                             |
| ---------------- | ------------------------------------------------------------------- |
| `navigation/`    | Navegación entre secciones: Planetas, ISS, APOD, Eventos            |
| `lists/`         | Catálogo de cuerpos del sistema solar (planetas, lunas, asteroides) |
| `forms/`         | Filtros de búsqueda de asteroides por fecha y distancia             |
| `animations/`    | Órbitas planetarias animadas, rotación de planetas 3D               |
| `camera/`        | AR overlay con constelaciones apuntando al cielo                    |
| `maps/`          | Mapa terrestre con posición en tiempo real de la ISS                |
| `storage/`       | Caché de imágenes APOD y favoritos del usuario                      |
| `notifications/` | Alertas de tormenta solar (DONKI) y paso de la ISS                  |
| `sensors/`       | Giroscopio para mover el cielo estrellado (star map)                |
| `auth/`          | Perfil de observador: diario de observaciones en Supabase           |
| `realtime/`      | Posición ISS en tiempo real (polling + Supabase broadcast)          |
| `platform/`      | Diferencias Android/Web/iOS en permisos de cámara y sensores        |

---

## Stack principal

| Capa                  | Tecnología                            | Versión exacta                     |
| --------------------- | ------------------------------------- | ---------------------------------- |
| SDK                   | Flutter                               | 3.29.3 (stable)                    |
| Lenguaje              | Dart                                  | 3.7.2 (incluido con Flutter)       |
| Navegación            | go_router                             | pinear al instalar                 |
| Animaciones           | AnimationController + flutter_animate | nativo + pinear al instalar        |
| Estado global         | flutter_riverpod                      | pinear al instalar                 |
| Fetching / caché      | flutter_riverpod AsyncNotifier        | nativo (sin paquete extra)         |
| Formularios           | reactive_forms                        | pinear al instalar                 |
| HTTP                  | dio                                   | pinear al instalar                 |
| Backend               | supabase_flutter (free tier)          | pinear al instalar                 |
| Almacenamiento        | shared_preferences + drift            | pinear al instalar                 |
| Almacenamiento seguro | flutter_secure_storage                | pinear al instalar                 |
| Variables de entorno  | flutter_dotenv                        | pinear al instalar                 |
| Package manager       | **pub** (incluido en Flutter)         | `flutter pub get` / `dart pub get` |

---

## Reglas de dependencias — OBLIGATORIAS

- **Versiones exactas siempre** en `pubspec.yaml`: `go_router: 14.8.1`, nunca `^`, `~`, `>=`, `any`.
- Al agregar cualquier paquete: `flutter pub add paquete:X.Y.Z` con versión explícita,
  o editar `pubspec.yaml` directamente con versión exacta.
- Antes de instalar una dependencia nueva:
  1. Consultar la versión estable actual en [pub.dev](https://pub.dev).
  2. Ejecutar `dart pub audit` antes de cada commit.
  3. Si hay CVEs reportados → **no instalar** o buscar alternativa.
- El archivo `pubspec.lock` debe commitearse siempre (garantiza builds reproducibles).
- No usar `flutter pub upgrade` sin revisar el resultado en `pubspec.yaml` y `pubspec.lock`.

---

## Arquitectura de módulos

Cada módulo es una carpeta autónoma en `lib/modules/<nombre>/`:

```
lib/
  modules/
    navigation/        → go_router: ShellRoute, GoRoute, Drawer
    lists/             → ListView.builder / SliverList alto rendimiento
    forms/             → reactive_forms, validadores personalizados
    animations/        → AnimationController, CustomPainter, TweenSequence
    camera/            → camera plugin, AR overlay SVG
    maps/              → google_maps_flutter + geolocator
    storage/           → shared_preferences + drift (SQLite)
    notifications/     → flutter_local_notifications + FCM (Android primero)
    sensors/           → sensors_plus: acelerómetro, giroscopio
    auth/              → supabase_flutter auth + local_auth biometría
    realtime/          → supabase_flutter Realtime subscriptions
    platform/          → diferencias Android / Web / iOS
    artemis/           → misiones lunares + galería NASA
  shared/
    widgets/           → widgets reutilizables
    providers/         → providers Riverpod transversales
    repositories/      → clientes HTTP y data layer
    theme/             → ThemeData, colores, tipografía, dark/light mode
test/
  modules/             → tests espejo de lib/modules/
  shared/              → tests de repositories y providers
```

Pantalla raíz: catálogo (Home) que lista los módulos disponibles con estado de
plataforma (Android ✓ / Web ✓ / iOS pendiente).

---

## Backend: Supabase (free tier)

- Credenciales en `.env` local (nunca commitear).
- Variables de entorno: `SUPABASE_URL` y `SUPABASE_ANON_KEY`.
- Cargadas con `flutter_dotenv` en `main.dart` antes de `runApp()`.
- Usar Row Level Security (RLS) en todas las tablas desde el inicio.
- No exponer la `service_role` key en el cliente.

---

## Filosofía de calidad — INNEGOCIABLE

> "No hay errores pequeños. Hay errores, y se corrigen — sin importar su origen,
> su tamaño, ni si los introdujo el desarrollador, una librería o el propio Copilot."

- Todo error detectado (análisis estático, test, runtime, CVE) se corrige antes de continuar.
- No se postergan correcciones con `// TODO` sin issue asociado.
- No se usa `// ignore:` ni `// ignore_for_file:` sin comentario que explique el porqué
  y un issue abierto para resolverlo.
- Las mejores prácticas se aplican siempre, no solo cuando hay tiempo.

---

## Documentación académica del código

Cada función, provider, widget y módulo debe documentarse siguiendo el esquema:
**¿Qué hace? → ¿Para qué existe? → ¿Qué impacta?**

### Widgets y providers (Dartdoc)

```dart
/// Provider que gestiona el ciclo de vida de la sesión de autenticación con Supabase.
///
/// @what Escucha `onAuthStateChange` y expone el usuario y estado de carga.
/// @why Centraliza la lógica de sesión para evitar escuchas duplicadas en
///   múltiples pantallas y garantizar un único punto de verdad.
/// @impact Cualquier cambio en este provider afecta a todas las rutas protegidas
///   por el guard de autenticación. Requiere test unitario actualizado.
@riverpod
class AuthSessionNotifier extends _$AuthSessionNotifier { ... }
```

### Funciones utilitarias

```dart
/// Formatea una distancia en metros a texto legible.
///
/// @what Convierte [meters] a String con unidad apropiada (m / km).
/// @why El módulo de mapas necesita mostrar distancias sin acoplar la lógica de
///   presentación al widget de mapa.
/// @impact Usado en MapScreen y NotificationCard; cambios rompen el test unitario.
///
/// Lanza [ArgumentError] si [meters] es negativo.
String formatDistance(double meters) { ... }
```

### Módulos (`index.dart` o `README` dentro del módulo)

Cada módulo en `lib/modules/<nombre>/` debe incluir un comentario de bloque al inicio
de su archivo principal con:

- **Qué demuestra** este módulo en el contexto del showcase.
- **Por qué** se eligió esta librería/enfoque.
- **Impacto** en el resto de la app (dependencias cruzadas, permisos requeridos).

---

## Testing — cobertura mínima ≥ 80 %

- Framework: **flutter_test** (nativo) + **mocktail** para mocks.
- Cobertura mínima obligatoria: **80 %** de líneas y ramas por módulo.
- Ejecutar antes de cada commit: `flutter test --coverage`.
- Si la cobertura baja del umbral, el commit queda bloqueado.

### Qué testear por tipo

| Tipo         | Qué cubrir                                                                               |
| ------------ | ---------------------------------------------------------------------------------------- |
| Provider     | estados iniciales, transiciones loading/data/error, efectos secundarios                  |
| Widget       | render por parámetros, interacciones de usuario, accesibilidad (`find.bySemanticsLabel`) |
| Función util | casos normales, límites (0, null), errores esperados                                     |
| Integración  | flujo completo de pantalla con mocks de Supabase / sensores                              |

### Convenciones de archivos de test

```
test/modules/auth/
  auth_session_notifier_test.dart   ← test unitario del provider
  auth_screen_test.dart             ← test de widget/pantalla
```

---

## Convenciones de código

- Dart con sound null safety: sin `late` innecesario, sin `!` sin justificación.
- Widgets: PascalCase. Providers: camelCase con sufijo `Provider` o `Notifier`.
- Archivos: `snake_case.dart`. Directorios: `snake_case/`.
- Sin `dynamic` implícito. Tipar siempre los parámetros de widgets y funciones.
- Platform-specific code: usar `Platform.isAndroid`, `Platform.isIOS`, `kIsWeb`.
- No usar `// ignore:` sin comentario justificativo.

### Idioma del código

| Elemento                                             | Idioma      |
| ---------------------------------------------------- | ----------- |
| Nombres de variables, funciones, clases, tipos       | **inglés**  |
| Nombres de archivos y carpetas                       | **inglés**  |
| Parámetros, eventos, constantes, enums               | **inglés**  |
| Commits, branch names, PR titles                     | **inglés**  |
| Comentarios en código (`//`, `/* */`, dartdoc `///`) | **español** |
| Mensajes de error visibles al usuario (UI)           | **español** |
| Documentación en `copilot-instructions.md`           | **español** |

```dart
// ✅ Correcto
final userSession = await getAuthSession(); // obtiene la sesión activa del usuario

// ❌ Incorrecto — comentario en inglés
final userSession = await getAuthSession(); // gets the active user session

// ❌ Incorrecto — variable en español
final sesionUsuario = await getAuthSession();
```

---

## Commits

Formato Conventional Commits con cuerpo pedagógico:

```
type(scope): short description

For: reason this change was needed
Impact: what this affects/enables
```

Tipos: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `style`, `ci`.
Idioma del commit: **inglés**.

---

## Prioridad de plataformas

1. **Android**: funcionalidades nativas completas, testing primero en Android.
2. **Web** (`flutter run -d chrome`): responsivo, hover states, accesibilidad semántica.
3. **iOS**: last — ajustes de safe area, haptics avanzados, CupertinoActionSheet.

Al implementar una feature que usa API nativa, comprobar disponibilidad con
`Platform.isAndroid`, `Platform.isIOS` o `kIsWeb` antes de renderizar.
