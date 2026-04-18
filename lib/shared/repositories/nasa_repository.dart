import 'package:cosmos_flutter/modules/forms/models/asteroid.dart';
import 'package:cosmos_flutter/modules/forms/models/date_range.dart';
import 'package:dio/dio.dart';

/// Repositorio que centraliza el acceso a las APIs públicas de la NASA.
///
/// @what  Provee métodos para APOD, NeoWs (asteroides) y DONKI (clima espacial).
/// @why   Desacopla los módulos del detalle de HTTP y gestión de la API key,
///        garantizando un único punto de configuración y caché.
/// @impact Usado por los módulos `forms/`, `notifications/` y futuras fases.
///         Cualquier cambio en la base URL o autenticación se aplica aquí.
class NasaRepository {
  NasaRepository({Dio? dio, String? apiKey})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: 'https://api.nasa.gov',
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 30),
            )),
        // Usar DEMO_KEY si no se configura la clave personal.
        _apiKey = apiKey ?? 'DEMO_KEY';

  final Dio _dio;
  final String _apiKey;

  // ─── Caché en memoria para NeoWs (7 días) ─────────────────────────────────
  final Map<String, List<Asteroid>> _neowsCache = {};
  final Map<String, DateTime> _neowsCacheTime = {};
  static const _neowsCacheDuration = Duration(hours: 1);

  // ─── NeoWs — Asteroides cercanos a la Tierra ──────────────────────────────

  /// Devuelve los asteroides que se acercan a la Tierra en el [range] dado.
  ///
  /// @what  GET /neo/rest/v1/feed con start_date y end_date.
  ///        Aplana los resultados (agrupados por fecha) en una lista plana.
  /// @why   La API NeoWs tiene límite de 7 días por consulta; el validador del
  ///        formulario garantiza que [range] cumple esa restricción antes de
  ///        llamar a este método.
  /// @impact Lanza [ArgumentError] si el rango supera 7 días.
  ///         Lanza [Exception] si la respuesta HTTP no es 200.
  Future<List<Asteroid>> getAsteroids(DateRange range) async {
    if (!range.isValid) {
      throw ArgumentError(
        'El rango de fechas no es válido o supera los 7 días permitidos.',
      );
    }

    final start = _formatDate(range.startDate);
    final end = _formatDate(range.endDate);
    final cacheKey = '$start→$end';

    // Servir desde caché si no ha expirado.
    if (_neowsCache.containsKey(cacheKey) &&
        DateTime.now().difference(_neowsCacheTime[cacheKey]!) <
            _neowsCacheDuration) {
      return _neowsCache[cacheKey]!;
    }

    final response = await _dio.get<Map<String, dynamic>>(
      '/neo/rest/v1/feed',
      queryParameters: {
        'start_date': start,
        'end_date': end,
        'api_key': _apiKey,
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Error al obtener asteroides de NASA: ${response.statusCode}',
      );
    }

    final data = response.data;
    if (data == null || data['near_earth_objects'] == null) {
      throw Exception('Respuesta inválida de NASA NeoWs');
    }

    // near_earth_objects es un Map<String, List<dynamic>> donde la clave es la fecha.
    final nearEarthObjects =
        data['near_earth_objects'] as Map<String, dynamic>;

    final asteroids = nearEarthObjects.values
        .expand((list) => list as List<dynamic>)
        .map((e) => Asteroid.fromJson(e as Map<String, dynamic>))
        .where((a) => a.id.isNotEmpty)
        .toList()
      ..sort((a, b) => a.closeApproachDate.compareTo(b.closeApproachDate));

    _neowsCache[cacheKey] = asteroids;
    _neowsCacheTime[cacheKey] = DateTime.now();
    return asteroids;
  }

  // ─── Utilidades ───────────────────────────────────────────────────────────

  /// Formatea una fecha como 'yyyy-MM-dd' para la API NASA.
  String _formatDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}

