import 'package:cosmos_flutter/modules/lists/models/celestial_body.dart';
import 'package:cosmos_flutter/modules/lists/providers/lists_providers.dart';
import 'package:cosmos_flutter/shared/repositories/solar_system_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// Mock del repositorio para aislar los providers de la red.
class MockSolarSystemRepository extends Mock implements SolarSystemRepository {}

/// Cuerpo de prueba reutilizable.
CelestialBody _makePlanet(String id) => CelestialBody(
      id: id,
      name: 'Planet $id',
      bodyType: 'Planet',
      isPlanet: true,
    );

void main() {
  group('solarSystemBodiesProvider —', () {
    late MockSolarSystemRepository mockRepo;
    late ProviderContainer container;

    setUp(() {
      mockRepo = MockSolarSystemRepository();
      container = ProviderContainer(
        overrides: [
          solarSystemRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('estado inicial es loading', () {
      when(() => mockRepo.getBodies()).thenAnswer(
        (_) async => [_makePlanet('terre')],
      );

      final state = container.read(solarSystemBodiesProvider);
      expect(state, isA<AsyncLoading<List<CelestialBody>>>());
    });

    test('expone data cuando el repositorio devuelve cuerpos', () async {
      final planets = [_makePlanet('terre'), _makePlanet('mars')];
      when(() => mockRepo.getBodies()).thenAnswer((_) async => planets);

      final result = await container.read(solarSystemBodiesProvider.future);
      expect(result, hasLength(2));
      expect(result.first.id, 'terre');
    });

    test('expone AsyncError cuando el repositorio lanza excepción', () async {
      when(() => mockRepo.getBodies())
          .thenThrow(Exception('Sin conexión'));

      await expectLater(
        container.read(solarSystemBodiesProvider.future),
        throwsA(isA<Exception>()),
      );

      final state = container.read(solarSystemBodiesProvider);
      expect(state, isA<AsyncError<List<CelestialBody>>>());
    });
  });

  group('solarSystemBodyProvider —', () {
    late MockSolarSystemRepository mockRepo;
    late ProviderContainer container;

    setUp(() {
      mockRepo = MockSolarSystemRepository();
      container = ProviderContainer(
        overrides: [
          solarSystemRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('devuelve el cuerpo correcto para un id dado', () async {
      final earth = _makePlanet('terre');
      when(() => mockRepo.getBodyById('terre'))
          .thenAnswer((_) async => earth);

      final result = await container.read(solarSystemBodyProvider('terre').future);
      expect(result.id, 'terre');
      expect(result.name, 'Planet terre');
    });

    test('propaga error si el id no existe', () async {
      when(() => mockRepo.getBodyById('unknown'))
          .thenThrow(Exception('No encontrado'));

      await expectLater(
        container.read(solarSystemBodyProvider('unknown').future),
        throwsA(isA<Exception>()),
      );
    });

    test('distintos IDs producen providers independientes', () async {
      final earth = _makePlanet('terre');
      final mars = _makePlanet('mars');
      when(() => mockRepo.getBodyById('terre')).thenAnswer((_) async => earth);
      when(() => mockRepo.getBodyById('mars')).thenAnswer((_) async => mars);

      final earthResult =
          await container.read(solarSystemBodyProvider('terre').future);
      final marsResult =
          await container.read(solarSystemBodyProvider('mars').future);

      expect(earthResult.id, 'terre');
      expect(marsResult.id, 'mars');
    });
  });
}
