---
applyTo: "lib/shared/repositories/nasa_repository.dart,lib/shared/repositories/solar_system_repository.dart,lib/modules/**"
---

# Instructions — APIs astronómicas

## Repositorios HTTP

Usar siempre los repositorios centralizados de `lib/shared/repositories/`:

| Repositorio             | Archivo                        | API                               |
| ----------------------- | ------------------------------ | --------------------------------- |
| `NasaRepository`        | `nasa_repository.dart`         | api.nasa.gov (APOD, NeoWs, DONKI) |
| `SolarSystemRepository` | `solar_system_repository.dart` | api.le-systeme-solaire.net        |
| `IssRepository`         | `iss_repository.dart`          | api.open-notify.org               |

## NASA API Key

```dart
// correcto — usar variable de entorno con fallback a DEMO_KEY
final apiKey = dotenv.env['NASA_API_KEY'] ?? 'DEMO_KEY';

// incorrecto — key hardcodeada
const apiKey = 'abc123mykey';
```

## Cache duration por tipo de dato

```dart
// posición ISS — cambia cada segundos
static const issPositionCacheDuration = Duration(seconds: 5);

// clima espacial DONKI — actualización diaria
static const donkiCacheDuration = Duration(minutes: 30);

// APOD — una imagen por día
static const apodCacheDuration = Duration(hours: 1);

// datos de planetas / cuerpos — cambios mínimos
static const bodiesCacheDuration = Duration(hours: 24);
```

## Convención de providers Riverpod

Seguir la convención `<dominio><Recurso>Provider`:

```dart
final nasaApodProvider = FutureProvider.family<Apod, String>((ref, date) => ...);
final nasaNeoWsProvider = FutureProvider.family<List<Asteroid>, DateRange>(...);
final nasaDonkiProvider = FutureProvider<List<SolarFlare>>(...);
final solarSystemBodiesProvider = FutureProvider<List<CelestialBody>>(...);
final solarSystemBodyProvider = FutureProvider.family<CelestialBody, String>(...);
final issPositionProvider = StreamProvider<IssPosition>(...);
final issAstronautsProvider = FutureProvider<List<Astronaut>>(...);
```

## Manejo de errores de red

```dart
/// @what  envuelve el error HTTP en un mensaje legible para el usuario
/// @why   el usuario debe ver un mensaje en español, no un stack trace
/// @impact afecta al estado de error que muestra el widget consumidor
if (response.statusCode != 200) {
  throw Exception(
    'Error al obtener datos de NASA: ${response.statusCode} ${response.reasonPhrase}',
  );
}
```

## Límites de rate

- `DEMO_KEY`: 30 req/hora por IP — solo para desarrollo.
- Key personal: 1.000 req/hora — para testing y producción.
- Implementar caché agresiva (Riverpod `keepAlive` + lógica de expiración en repositorio) para minimizar llamadas.
