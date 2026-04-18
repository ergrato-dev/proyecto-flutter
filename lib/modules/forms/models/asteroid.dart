/// Modelo que representa un asteroide (Near Earth Object) de la API NASA NeoWs.
///
/// @what  Deserializa la respuesta de `/neo/rest/v1/feed` de la NASA para
///        un solo asteroide con sus datos orbitales y de riesgo.
/// @why   Centralizar la deserialización garantiza un único punto de cambio
///        si la API NASA modifica su esquema JSON.
/// @impact Usado por [AsteroidResultsScreen] y los tests del módulo `forms/`.
class Asteroid {
  const Asteroid({
    required this.id,
    required this.name,
    required this.isPotentiallyHazardous,
    required this.closeApproachDate,
    required this.missDistanceKm,
    required this.relativeVelocityKmPerH,
    required this.absoluteMagnitude,
    this.minDiameterKm,
    this.maxDiameterKm,
    this.nasaJplUrl,
  });

  final String id;
  final String name;

  /// Si la NASA lo clasifica como Potentially Hazardous Asteroid (PHA).
  final bool isPotentiallyHazardous;

  /// Fecha del acercamiento más próximo en el rango consultado (yyyy-MM-dd).
  final String closeApproachDate;

  /// Distancia de máximo acercamiento en km.
  final double missDistanceKm;

  /// Velocidad relativa al acercamiento en km/h.
  final double relativeVelocityKmPerH;

  /// Magnitud absoluta (H) — indicador indirecto del tamaño.
  final double absoluteMagnitude;

  /// Diámetro mínimo estimado en km.
  final double? minDiameterKm;

  /// Diámetro máximo estimado en km.
  final double? maxDiameterKm;

  /// URL en el catálogo JPL de la NASA.
  final String? nasaJplUrl;

  /// Construye un [Asteroid] desde el JSON de un elemento de NeoWs feed.
  ///
  /// @what  Extrae los campos del primer `close_approach_data` del JSON.
  /// @why   NeoWs devuelve un array de acercamientos; tomamos el primero
  ///        porque ya filtramos por rango de fechas al hacer la petición.
  /// @impact Si NASA añade campos nuevos, actualizar aquí y en los tests.
  factory Asteroid.fromJson(Map<String, dynamic> json) {
    final diameter = json['estimated_diameter'] as Map<String, dynamic>?;
    final kmDiameter = diameter?['kilometers'] as Map<String, dynamic>?;

    final approachList =
        json['close_approach_data'] as List<dynamic>?;
    final approach = (approachList?.isNotEmpty ?? false)
        ? approachList!.first as Map<String, dynamic>
        : <String, dynamic>{};

    final velocity = approach['relative_velocity'] as Map<String, dynamic>?;
    final missDistance =
        approach['miss_distance'] as Map<String, dynamic>?;

    return Asteroid(
      id: json['id'] as String? ?? '',
      name: (json['name'] as String? ?? '').replaceAll(RegExp(r'[()]'), '').trim(),
      isPotentiallyHazardous:
          json['is_potentially_hazardous_asteroid'] as bool? ?? false,
      closeApproachDate:
          approach['close_approach_date'] as String? ?? '',
      missDistanceKm: double.tryParse(
            missDistance?['kilometers'] as String? ?? '0',
          ) ??
          0,
      relativeVelocityKmPerH: double.tryParse(
            velocity?['kilometers_per_hour'] as String? ?? '0',
          ) ??
          0,
      absoluteMagnitude:
          (json['absolute_magnitude_h'] as num?)?.toDouble() ?? 0,
      minDiameterKm:
          (kmDiameter?['estimated_diameter_min'] as num?)?.toDouble(),
      maxDiameterKm:
          (kmDiameter?['estimated_diameter_max'] as num?)?.toDouble(),
      nasaJplUrl: json['nasa_jpl_url'] as String?,
    );
  }

  @override
  String toString() =>
      'Asteroid(id: $id, name: $name, pha: $isPotentiallyHazardous)';
}
