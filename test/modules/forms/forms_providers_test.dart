import 'package:cosmos_flutter/modules/forms/models/asteroid.dart';
import 'package:cosmos_flutter/modules/forms/models/date_range.dart';
import 'package:cosmos_flutter/modules/forms/providers/forms_providers.dart';
import 'package:cosmos_flutter/shared/repositories/nasa_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock del repositorio NASA.
class MockNasaRepository extends Mock implements NasaRepository {}

// Asteroide de prueba.
Asteroid buildAsteroid({String id = '99', bool isPha = false}) => Asteroid(
      id: id,
      name: 'Test Asteroid $id',
      isPotentiallyHazardous: isPha,
      closeApproachDate: '2025-04-20',
      missDistanceKm: 1000000,
      relativeVelocityKmPerH: 50000,
      absoluteMagnitude: 20.0,
    );

void main() {
  late MockNasaRepository mockRepo;
  final range = DateRange(
    startDate: DateTime(2025, 4, 13),
    endDate: DateTime(2025, 4, 20),
  );

  setUp(() {
    mockRepo = MockNasaRepository();
    registerFallbackValue(range);
  });

  ProviderContainer buildContainer() => ProviderContainer(
        overrides: [
          nasaRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );

  group('nasaNeoWsProvider', () {
    test('estado inicial es loading', () async {
      when(() => mockRepo.getAsteroids(any())).thenAnswer(
        (_) async => [buildAsteroid()],
      );

      final container = buildContainer();
      addTearDown(container.dispose);

      // El primer frame el provider está en loading.
      expect(
        container.read(nasaNeoWsProvider(range)),
        isA<AsyncLoading<List<Asteroid>>>(),
      );
    });

    test('retorna lista de asteroides cuando el repositorio responde', () async {
      final expected = [buildAsteroid(id: '1'), buildAsteroid(id: '2', isPha: true)];
      when(() => mockRepo.getAsteroids(any())).thenAnswer((_) async => expected);

      final container = buildContainer();
      addTearDown(container.dispose);

      final result = await container.read(nasaNeoWsProvider(range).future);

      expect(result, hasLength(2));
      expect(result.first.id, '1');
      expect(result.last.isPotentiallyHazardous, isTrue);
    });

    test('expone AsyncError cuando el repositorio lanza excepción', () async {
      when(() => mockRepo.getAsteroids(any()))
          .thenThrow(Exception('Error de red'));

      final container = buildContainer();
      addTearDown(container.dispose);

      await expectLater(
        container.read(nasaNeoWsProvider(range).future),
        throwsA(isA<Exception>()),
      );
    });

    test('retorna lista vacía cuando no hay asteroides', () async {
      when(() => mockRepo.getAsteroids(any())).thenAnswer((_) async => []);

      final container = buildContainer();
      addTearDown(container.dispose);

      final result = await container.read(nasaNeoWsProvider(range).future);
      expect(result, isEmpty);
    });

    test('provider family diferencia resultados por rango de fechas', () async {
      final range2 = DateRange(
        startDate: DateTime(2025, 5, 2),
        endDate: DateTime(2025, 5, 5),
      );

      when(
        () => mockRepo.getAsteroids(
          DateRange(
            startDate: DateTime(2025, 4, 13),
            endDate: DateTime(2025, 4, 20),
          ),
        ),
      ).thenAnswer((_) async => [buildAsteroid(id: 'A')]);

      when(
        () => mockRepo.getAsteroids(
          DateRange(
            startDate: DateTime(2025, 5, 2),
            endDate: DateTime(2025, 5, 5),
          ),
        ),
      ).thenAnswer((_) async => [buildAsteroid(id: 'B')]);

      // Fallback para cualquier otro rango
      when(() => mockRepo.getAsteroids(any()))
          .thenAnswer((_) async => [buildAsteroid(id: 'B')]);

      final container = buildContainer();
      addTearDown(container.dispose);

      final result2 = await container.read(nasaNeoWsProvider(range2).future);
      expect(result2.first.id, 'B');
    });
  });
}
