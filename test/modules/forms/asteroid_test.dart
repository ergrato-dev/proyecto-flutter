import 'package:cosmos_flutter/modules/forms/models/asteroid.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Asteroid.fromJson', () {
    // JSON mínimo con todos los campos requeridos.
    Map<String, dynamic> buildJson({
      String id = '3542519',
      String name = 'Eros',
      bool isPha = false,
      String closeApproachDate = '2025-04-20',
      String missDistanceKm = '5000000.123456789',
      String velocityKmh = '72000.0',
      double absoluteMagnitude = 19.5,
      double? minDiameterKm = 0.1,
      double? maxDiameterKm = 0.3,
      String? nasaJplUrl = 'https://ssd.jpl.nasa.gov/tools/sbdb_lookup.html',
    }) =>
        {
          'id': id,
          'name': name,
          'is_potentially_hazardous_asteroid': isPha,
          'absolute_magnitude_h': absoluteMagnitude,
          'nasa_jpl_url': nasaJplUrl,
          'estimated_diameter': {
            'kilometers': {
              'estimated_diameter_min': minDiameterKm,
              'estimated_diameter_max': maxDiameterKm,
            },
          },
          'close_approach_data': [
            {
              'close_approach_date': closeApproachDate,
              'relative_velocity': {
                'kilometers_per_hour': velocityKmh,
              },
              'miss_distance': {
                'kilometers': missDistanceKm,
              },
            },
          ],
        };

    test('parsea todos los campos correctamente', () {
      final asteroid = Asteroid.fromJson(buildJson());

      expect(asteroid.id, '3542519');
      expect(asteroid.name, 'Eros'); // sin paréntesis (Eros no los tiene)
      expect(asteroid.isPotentiallyHazardous, isFalse);
      expect(asteroid.closeApproachDate, '2025-04-20');
      expect(asteroid.missDistanceKm, closeTo(5000000.12, 1));
      expect(asteroid.relativeVelocityKmPerH, 72000.0);
      expect(asteroid.absoluteMagnitude, 19.5);
      expect(asteroid.minDiameterKm, 0.1);
      expect(asteroid.maxDiameterKm, 0.3);
      expect(asteroid.nasaJplUrl, isNotNull);
    });

    test('isPotentiallyHazardous = true cuando la NASA lo marca como PHA', () {
      final asteroid = Asteroid.fromJson(buildJson(isPha: true));
      expect(asteroid.isPotentiallyHazardous, isTrue);
    });

    test('nombre sin paréntesis cuando el original los tiene', () {
      final asteroid = Asteroid.fromJson(buildJson(name: '(2011 AG5)'));
      expect(asteroid.name, '2011 AG5');
      expect(asteroid.name.contains('('), isFalse);
      expect(asteroid.name.contains(')'), isFalse);
    });

    test('nombre sin paréntesis cuando el original no los tiene', () {
      final asteroid = Asteroid.fromJson(buildJson(name: 'Apophis'));
      expect(asteroid.name, 'Apophis');
    });

    test('campos opcionales son null cuando faltan en el JSON', () {
      final json = buildJson();
      ((json['estimated_diameter'] as Map<String, dynamic>))
          .remove('kilometers');
      json.remove('nasa_jpl_url');

      final asteroid = Asteroid.fromJson(json);
      expect(asteroid.minDiameterKm, isNull);
      expect(asteroid.maxDiameterKm, isNull);
      expect(asteroid.nasaJplUrl, isNull);
    });

    test('missDistanceKm = 0 cuando miss_distance no está presente', () {
      final json = buildJson();
      ((json['close_approach_data'] as List<dynamic>).first
              as Map<String, dynamic>)
          .remove('miss_distance');
      final asteroid = Asteroid.fromJson(json);
      expect(asteroid.missDistanceKm, 0.0);
    });

    test('relativeVelocityKmPerH = 0 cuando relative_velocity no está', () {
      final json = buildJson();
      ((json['close_approach_data'] as List<dynamic>).first
              as Map<String, dynamic>)
          .remove('relative_velocity');
      final asteroid = Asteroid.fromJson(json);
      expect(asteroid.relativeVelocityKmPerH, 0.0);
    });

    test('id vacío cuando no viene en el JSON', () {
      final json = buildJson();
      json.remove('id');
      final asteroid = Asteroid.fromJson(json);
      expect(asteroid.id, '');
    });

    test('closeApproachDate vacío cuando close_approach_data está vacío', () {
      final json = buildJson();
      json['close_approach_data'] = <dynamic>[];
      final asteroid = Asteroid.fromJson(json);
      expect(asteroid.closeApproachDate, '');
    });

    test('toString contiene id, name y pha', () {
      final asteroid = Asteroid.fromJson(buildJson(isPha: true));
      expect(asteroid.toString(), contains('3542519'));
      expect(asteroid.toString(), contains('Eros'));
      expect(asteroid.toString(), contains('true'));
    });
  });
}
