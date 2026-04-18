/// Repositorio que centraliza el acceso a las APIs públicas de la NASA.
///
/// @what Provee métodos para APOD, NeoWs (asteroides) y DONKI (clima espacial).
/// @why Desacopla los módulos del detalle de HTTP y gestión de la API key,
///   garantizando un único punto de configuración y caché.
/// @impact Usado por los módulos `lists/`, `notifications/` y `artemis/`.
///   Cualquier cambio en la base URL o autenticación se aplica aquí.
library;

// TODO(fase-2): implementar con Dio + flutter_dotenv para NASA_API_KEY.
class NasaRepository {
  // Stub — se implementa en la Fase 2 (módulo lists/).
}
