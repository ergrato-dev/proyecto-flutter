/// Módulo `forms/`: búsqueda de asteroides con formulario reactivo.
///
/// @what  Demuestra `reactive_forms` con validadores personalizados (orden de
///        fechas, rango máximo 7 días) y consume NASA NeoWs para mostrar
///        asteroides cercanos a la Tierra con badge PHA.
/// @why   Flutter no tiene gestión de formularios con validación tipada de serie;
///        `reactive_forms` ofrece un patrón reactivo similar a Angular Reactive Forms.
/// @impact Depende de [NasaRepository] (NASA NeoWs API, caché 1h) y
///         [nasaNeoWsProvider] (Riverpod FutureProvider.family).
///         No requiere permisos especiales de plataforma.
library;

export 'models/asteroid.dart';
export 'models/date_range.dart';
export 'providers/forms_providers.dart';
export 'screens/asteroid_search_form_screen.dart';
export 'utils/asteroid_validators.dart';
