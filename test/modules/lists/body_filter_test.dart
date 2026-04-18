import 'package:cosmos_flutter/modules/lists/models/celestial_body.dart';
import 'package:cosmos_flutter/modules/lists/utils/body_filter.dart';
import 'package:flutter_test/flutter_test.dart';

/// Crea un [CelestialBody] mínimo para los tests de filtrado.
CelestialBody _makeBody({
  required String bodyType,
  bool isPlanet = false,
}) =>
    CelestialBody(
      id: bodyType.toLowerCase(),
      name: bodyType,
      bodyType: bodyType,
      isPlanet: isPlanet,
    );

void main() {
  group('matchesFilter —', () {
    final planet = _makeBody(bodyType: 'Planet', isPlanet: true);
    final dwarfPlanet = _makeBody(bodyType: 'Dwarf Planet');
    final moon = _makeBody(bodyType: 'Moon');
    final asteroid = _makeBody(bodyType: 'Asteroid');
    final comet = _makeBody(bodyType: 'Comet');
    final star = _makeBody(bodyType: 'Star');

    test('filtro all acepta todos los tipos', () {
      for (final body in [planet, moon, asteroid, comet, star]) {
        expect(matchesFilter(body, BodyFilterType.all), isTrue);
      }
    });

    test('filtro planet — Planet e isPlanet=true', () {
      expect(matchesFilter(planet, BodyFilterType.planet), isTrue);
      expect(matchesFilter(dwarfPlanet, BodyFilterType.planet), isTrue);
      expect(matchesFilter(moon, BodyFilterType.planet), isFalse);
    });

    test('filtro moon — solo Moon', () {
      expect(matchesFilter(moon, BodyFilterType.moon), isTrue);
      expect(matchesFilter(planet, BodyFilterType.moon), isFalse);
    });

    test('filtro asteroid — solo Asteroid', () {
      expect(matchesFilter(asteroid, BodyFilterType.asteroid), isTrue);
      expect(matchesFilter(comet, BodyFilterType.asteroid), isFalse);
    });

    test('filtro comet — solo Comet', () {
      expect(matchesFilter(comet, BodyFilterType.comet), isTrue);
      expect(matchesFilter(asteroid, BodyFilterType.comet), isFalse);
    });

    test('filtro other — tipos no reconocidos', () {
      expect(matchesFilter(star, BodyFilterType.other), isTrue);
      expect(matchesFilter(planet, BodyFilterType.other), isFalse);
    });
  });

  group('iconForBodyType —', () {
    test('planet devuelve public_outlined', () {
      final icon = iconForBodyType('Planet');
      expect(icon.codePoint, isNonZero);
    });

    test('moon devuelve nightlight', () {
      final icon = iconForBodyType('Moon');
      expect(icon.codePoint, isNonZero);
    });

    test('tipo desconocido devuelve circle_outlined', () {
      final icon = iconForBodyType('Unknown');
      expect(icon.codePoint, isNonZero);
    });
  });

  group('BodyFilterTypeLabel —', () {
    test('todos los filtros tienen label no vacío', () {
      for (final filter in BodyFilterType.values) {
        expect(filter.label, isNotEmpty);
      }
    });

    test('filtro all tiene label "Todos"', () {
      expect(BodyFilterType.all.label, 'Todos');
    });
  });
}
