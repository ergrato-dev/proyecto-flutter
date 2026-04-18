import 'package:cosmos_flutter/modules/lists/models/celestial_body.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CelestialBody —', () {
    const planetJson = {
      'id': 'terre',
      'name': 'La Terre',
      'englishName': 'Earth',
      'bodyType': 'Planet',
      'isPlanet': true,
      'alternativeName': 'Terra',
      'discoveredBy': '',
      'discoveryDate': '',
      'meanRadius': 6371.0,
      'equaRadius': 6378.1,
      'polarRadius': 6356.8,
      'density': 5.514,
      'gravity': 9.798,
      'escape': 11186.0,
      'avgTemp': 288,
      'semimajorAxis': 149598023,
      'perihelion': 147095000,
      'aphelion': 152100000,
      'eccentricity': 0.01671,
      'inclination': 0.00005,
      'sideralOrbit': 365.25636,
      'sideralRotation': 23.9345,
      'mass': {'massValue': 5.97219, 'massExponent': 24},
      'vol': {'volValue': 1.08321, 'volExponent': 12},
      'aroundPlanet': null,
    };

    const moonJson = {
      'id': 'lune',
      'name': 'La Lune',
      'englishName': 'Moon',
      'bodyType': 'Moon',
      'isPlanet': false,
      'meanRadius': 1737.4,
      'gravity': 1.62,
      'aroundPlanet': {'planet': 'terre', 'rel': 'http://example.com'},
    };

    test('fromJson — planeta con todos los campos', () {
      final body = CelestialBody.fromJson(planetJson);

      expect(body.id, 'terre');
      expect(body.name, 'Earth');
      expect(body.bodyType, 'Planet');
      expect(body.isPlanet, isTrue);
      expect(body.alternativeName, 'Terra');
      expect(body.meanRadius, 6371.0);
      expect(body.gravity, 9.798);
      expect(body.avgTemp, 288.0);
      expect(body.massValue, 5.97219);
      expect(body.massExponent, 24);
      expect(body.volValue, 1.08321);
      expect(body.sideralOrbit, 365.25636);
      expect(body.aroundPlanetId, isNull);
    });

    test('fromJson — satélite con aroundPlanet', () {
      final body = CelestialBody.fromJson(moonJson);

      expect(body.id, 'lune');
      expect(body.name, 'Moon');
      expect(body.bodyType, 'Moon');
      expect(body.isPlanet, isFalse);
      expect(body.aroundPlanetId, 'terre');
    });

    test('fromJson — campos opcionales ausentes devuelven null', () {
      final body = CelestialBody.fromJson({
        'id': 'test',
        'englishName': 'Test Body',
        'bodyType': 'Asteroid',
        'isPlanet': false,
      });

      expect(body.meanRadius, isNull);
      expect(body.gravity, isNull);
      expect(body.massValue, isNull);
      expect(body.massExponent, isNull);
      expect(body.aroundPlanetId, isNull);
      expect(body.discoveredBy, isNull);
    });

    test('fromJson — JSON vacío no lanza excepción y produce id vacío', () {
      final body = CelestialBody.fromJson({});
      expect(body.id, '');
      expect(body.name, '');
      expect(body.isPlanet, isFalse);
    });

    test('toString — incluye id, name y type', () {
      final body = CelestialBody.fromJson(planetJson);
      final str = body.toString();
      expect(str, contains('terre'));
      expect(str, contains('Earth'));
      expect(str, contains('Planet'));
    });
  });
}
