/// Módulo `lists/`: catálogo del sistema solar.
///
/// @what  Demuestra [ListView.builder] de alto rendimiento con virtualización
///        para ~2000 cuerpos celestes obtenidos de Solar System OpenData.
/// @why   Flutter ofrece virtualización nativa con `itemBuilder`; este módulo
///        evidencia cómo manejar colecciones grandes sin degradar el rendimiento.
/// @impact Depende de [SolarSystemRepository] (HTTP, caché 24h) y
///         [solarSystemBodiesProvider] / [solarSystemBodyProvider] (Riverpod).
///         No requiere permisos especiales de plataforma.
library;

export 'models/celestial_body.dart';
export 'providers/lists_providers.dart';
export 'screens/bodies_screen.dart';
export 'screens/body_detail_screen.dart';
export 'utils/body_filter.dart';
