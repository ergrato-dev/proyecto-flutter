import 'package:cosmos_flutter/modules/lists/models/celestial_body.dart';
import 'package:flutter/material.dart';

/// Tipo de cuerpo celeste para filtrado y agrupación.
enum BodyFilterType { all, planet, moon, asteroid, comet, other }

/// Etiqueta legible para cada filtro.
extension BodyFilterTypeLabel on BodyFilterType {
  String get label => switch (this) {
        BodyFilterType.all => 'Todos',
        BodyFilterType.planet => 'Planetas',
        BodyFilterType.moon => 'Satélites',
        BodyFilterType.asteroid => 'Asteroides',
        BodyFilterType.comet => 'Cometas',
        BodyFilterType.other => 'Otros',
      };
}

/// Devuelve true si [body] coincide con el [filter] activo.
///
/// @what  Filtra un cuerpo por su tipo de cuerpo (bodyType).
/// @why   Permite a [BodiesScreen] agrupar la lista sin duplicar lógica.
/// @impact Cambiar las cadenas debe coordinarse con la API.
bool matchesFilter(CelestialBody body, BodyFilterType filter) {
  if (filter == BodyFilterType.all) return true;
  final type = body.bodyType.toLowerCase();
  return switch (filter) {
    BodyFilterType.planet =>
      type == 'planet' || type == 'dwarf planet' || body.isPlanet,
    BodyFilterType.moon => type == 'moon',
    BodyFilterType.asteroid => type == 'asteroid',
    BodyFilterType.comet => type == 'comet',
    BodyFilterType.other => !['planet', 'dwarf planet', 'moon', 'asteroid', 'comet']
        .contains(type),
    BodyFilterType.all => true,
  };
}

/// Icono asociado al tipo de cuerpo celeste.
///
/// @what  Devuelve un [IconData] según el [bodyType].
/// @why   Reutilizado en [BodiesScreen] y [BodyDetailScreen].
/// @impact Sin impacto externo (visual únicamente).
IconData iconForBodyType(String bodyType) {
  return switch (bodyType.toLowerCase()) {
    'planet' || 'dwarf planet' => Icons.public_outlined,
    'moon' => Icons.nightlight_round_outlined,
    'asteroid' => Icons.scatter_plot_outlined,
    'comet' => Icons.blur_on_outlined,
    _ => Icons.circle_outlined,
  };
}
