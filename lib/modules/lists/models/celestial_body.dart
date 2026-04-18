/// Modelo de datos para un cuerpo celeste del sistema solar.
///
/// @what  Representa un planeta, satélite, asteroide o cometa con sus datos
///        orbitales y físicos tal como los devuelve Solar System OpenData.
/// @why   Centraliza la deserialización del JSON de la API y provee un tipo
///        inmutable para el resto del módulo `lists/`.
/// @impact Cualquier cambio en los campos afecta a [BodiesScreen],
///         [BodyDetailScreen] y los tests de deserialización.
class CelestialBody {
  const CelestialBody({
    required this.id,
    required this.name,
    required this.bodyType,
    required this.isPlanet,
    this.alternativeName,
    this.discoveredBy,
    this.discoveryDate,
    this.meanRadius,
    this.equaRadius,
    this.polarRadius,
    this.density,
    this.gravity,
    this.escape,
    this.avgTemp,
    this.semimajorAxis,
    this.perihelion,
    this.aphelion,
    this.eccentricity,
    this.inclination,
    this.sideralOrbit,
    this.sideralRotation,
    this.massValue,
    this.massExponent,
    this.volValue,
    this.volExponent,
    this.aroundPlanetId,
  });

  final String id;
  final String name;

  /// Tipo de cuerpo: "Planet", "Moon", "Asteroid", "Comet", "Dwarf Planet", etc.
  final String bodyType;
  final bool isPlanet;
  final String? alternativeName;
  final String? discoveredBy;
  final String? discoveryDate;

  // ─── Datos físicos ────────────────────────────────────────────────────────
  /// Radio medio en km.
  final double? meanRadius;

  /// Radio ecuatorial en km.
  final double? equaRadius;

  /// Radio polar en km.
  final double? polarRadius;

  /// Densidad en g/cm³.
  final double? density;

  /// Gravedad superficial en m/s².
  final double? gravity;

  /// Velocidad de escape en m/s.
  final double? escape;

  /// Temperatura media en K.
  final double? avgTemp;

  // ─── Datos orbitales ──────────────────────────────────────────────────────
  /// Semieje mayor en km.
  final double? semimajorAxis;

  /// Perihelio en km.
  final double? perihelion;

  /// Afelio en km.
  final double? aphelion;

  /// Excentricidad orbital (sin unidades).
  final double? eccentricity;

  /// Inclinación orbital en grados.
  final double? inclination;

  /// Período orbital sidéreo en días.
  final double? sideralOrbit;

  /// Período de rotación sidéreo en horas.
  final double? sideralRotation;

  // ─── Masa y volumen ───────────────────────────────────────────────────────
  final double? massValue;
  final int? massExponent;
  final double? volValue;
  final int? volExponent;

  /// ID del planeta anfitrión si es satélite.
  final String? aroundPlanetId;

  /// Construye una instancia a partir del mapa JSON devuelto por la API.
  factory CelestialBody.fromJson(Map<String, dynamic> json) {
    // La API anida masa y volumen en objetos separados.
    final massMap = json['mass'] as Map<String, dynamic>?;
    final volMap = json['vol'] as Map<String, dynamic>?;
    final aroundMap = json['aroundPlanet'] as Map<String, dynamic>?;

    return CelestialBody(
      id: json['id'] as String? ?? '',
      name: json['englishName'] as String? ?? json['name'] as String? ?? '',
      bodyType: json['bodyType'] as String? ?? '',
      isPlanet: json['isPlanet'] as bool? ?? false,
      alternativeName: json['alternativeName'] as String?,
      discoveredBy: json['discoveredBy'] as String?,
      discoveryDate: json['discoveryDate'] as String?,
      meanRadius: (json['meanRadius'] as num?)?.toDouble(),
      equaRadius: (json['equaRadius'] as num?)?.toDouble(),
      polarRadius: (json['polarRadius'] as num?)?.toDouble(),
      density: (json['density'] as num?)?.toDouble(),
      gravity: (json['gravity'] as num?)?.toDouble(),
      escape: (json['escape'] as num?)?.toDouble(),
      avgTemp: (json['avgTemp'] as num?)?.toDouble(),
      semimajorAxis: (json['semimajorAxis'] as num?)?.toDouble(),
      perihelion: (json['perihelion'] as num?)?.toDouble(),
      aphelion: (json['aphelion'] as num?)?.toDouble(),
      eccentricity: (json['eccentricity'] as num?)?.toDouble(),
      inclination: (json['inclination'] as num?)?.toDouble(),
      sideralOrbit: (json['sideralOrbit'] as num?)?.toDouble(),
      sideralRotation: (json['sideralRotation'] as num?)?.toDouble(),
      massValue: (massMap?['massValue'] as num?)?.toDouble(),
      massExponent: massMap?['massExponent'] as int?,
      volValue: (volMap?['volValue'] as num?)?.toDouble(),
      volExponent: volMap?['volExponent'] as int?,
      aroundPlanetId: aroundMap?['planet'] as String?,
    );
  }

  @override
  String toString() => 'CelestialBody(id: $id, name: $name, type: $bodyType)';
}
