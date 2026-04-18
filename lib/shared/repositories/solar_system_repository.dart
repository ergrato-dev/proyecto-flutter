import 'package:cosmos_flutter/modules/lists/models/celestial_body.dart';
import 'package:dio/dio.dart';

/// Repositorio que accede a la API Solar System OpenData.
///
/// @what  Descarga la lista completa de cuerpos celestes y el detalle de
///        uno concreto desde https://api.le-systeme-solaire.net/rest.
/// @why   Sin autenticación; centraliza la lógica HTTP y la caché de 24h
///        para evitar llamadas redundantes en el módulo `lists/`.
/// @impact Usado por [solarSystemBodiesProvider] y [solarSystemBodyProvider].
///         Cambiar la base URL o la estructura del JSON requiere actualizar
///         [CelestialBody.fromJson] y los tests asociados.
class SolarSystemRepository {
  SolarSystemRepository({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: 'https://api.le-systeme-solaire.net/rest',
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 30),
            ));

  final Dio _dio;

  // Caché en memoria con expiración de 24h para la lista completa.
  List<CelestialBody>? _cachedBodies;
  DateTime? _cacheTime;
  static const _cacheDuration = Duration(hours: 24);

  /// Devuelve todos los cuerpos del sistema solar, usando caché si está vigente.
  ///
  /// @what  GET /bodies y deserializa la lista completa (~2000 cuerpos).
  /// @why   La lista cambia raramente; 24h de caché reduce las llamadas a la API.
  /// @impact Si la respuesta no contiene "bodies", lanza [Exception].
  Future<List<CelestialBody>> getBodies() async {
    // Servir desde caché si no ha expirado.
    if (_cachedBodies != null &&
        _cacheTime != null &&
        DateTime.now().difference(_cacheTime!) < _cacheDuration) {
      return _cachedBodies!;
    }

    final response = await _dio.get<Map<String, dynamic>>('/bodies');

    if (response.statusCode != 200) {
      throw Exception(
        'Error al obtener cuerpos celestes: ${response.statusCode}',
      );
    }

    final data = response.data;
    if (data == null || data['bodies'] == null) {
      throw Exception('Respuesta inválida de Solar System OpenData');
    }

    final bodies = (data['bodies'] as List<dynamic>)
        .map((e) => CelestialBody.fromJson(e as Map<String, dynamic>))
        .where((b) => b.id.isNotEmpty && b.name.isNotEmpty)
        .toList();

    _cachedBodies = bodies;
    _cacheTime = DateTime.now();
    return bodies;
  }

  /// Devuelve un cuerpo celeste por su ID.
  ///
  /// @what  GET /bodies/{id} y deserializa el cuerpo individual.
  /// @why   La pantalla de detalle necesita todos los campos de un cuerpo.
  /// @impact Lanza [Exception] si el ID no existe o la red falla.
  Future<CelestialBody> getBodyById(String id) async {
    final response = await _dio.get<Map<String, dynamic>>('/bodies/$id');

    if (response.statusCode != 200) {
      throw Exception(
        'Error al obtener el cuerpo "$id": ${response.statusCode}',
      );
    }

    final data = response.data;
    if (data == null) {
      throw Exception('Respuesta vacía para el cuerpo "$id"');
    }

    return CelestialBody.fromJson(data);
  }
}
