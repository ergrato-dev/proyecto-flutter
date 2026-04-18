import 'package:cosmos_flutter/modules/forms/models/asteroid.dart';
import 'package:cosmos_flutter/modules/forms/models/date_range.dart';
import 'package:cosmos_flutter/modules/forms/providers/forms_providers.dart';
import 'package:cosmos_flutter/modules/forms/screens/asteroid_search_form_screen.dart';
import 'package:cosmos_flutter/shared/repositories/nasa_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNasaRepository extends Mock implements NasaRepository {}

Widget _buildApp({NasaRepository? repo}) => ProviderScope(
      overrides: [
        if (repo != null)
          nasaRepositoryProvider.overrideWithValue(repo),
      ],
      child: const MaterialApp(
        home: AsteroidSearchFormScreen(),
      ),
    );

void main() {
  setUpAll(() {
    // Registrar valor fallback para DateRange (requerido por mocktail any()).
    registerFallbackValue(
      DateRange(
        startDate: DateTime(2025, 4, 13),
        endDate: DateTime(2025, 4, 20),
      ),
    );
  });
  testWidgets('muestra el formulario con los dos selectores de fecha',
      (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    // Título de la pantalla.
    expect(find.text('Búsqueda de asteroides'), findsOneWidget);

    // Etiquetas de los campos.
    expect(find.text('Fecha de inicio'), findsOneWidget);
    expect(find.text('Fecha de fin'), findsOneWidget);

    // Botón de búsqueda.
    expect(find.text('Buscar asteroides'), findsOneWidget);
  });

  testWidgets('muestra el card informativo de límite 7 días',
      (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    expect(
      find.textContaining('7 días'),
      findsOneWidget,
    );
  });

  testWidgets('botón de búsqueda está presente y es tappable',
      (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    final searchButton = find.text('Buscar asteroides');
    expect(searchButton, findsOneWidget);

    // Tap no lanza excepción — el formulario ya tiene fechas válidas por defecto.
    await tester.tap(searchButton);
    await tester.pumpAndSettle();
  });

  testWidgets('AsteroidResultsScreen muestra lista de asteroides',
      (tester) async {
    final mockRepo = MockNasaRepository();
    final range = DateRange(
      startDate: DateTime(2025, 4, 13),
      endDate: DateTime(2025, 4, 20),
    );

    when(() => mockRepo.getAsteroids(any())).thenAnswer(
      (_) async => [
        const Asteroid(
          id: '1',
          name: 'Apophis',
          isPotentiallyHazardous: true,
          closeApproachDate: '2025-04-17',
          missDistanceKm: 1500000,
          relativeVelocityKmPerH: 72000,
          absoluteMagnitude: 19.7,
        ),
        const Asteroid(
          id: '2',
          name: '2011 AG5',
          isPotentiallyHazardous: false,
          closeApproachDate: '2025-04-18',
          missDistanceKm: 8000000,
          relativeVelocityKmPerH: 45000,
          absoluteMagnitude: 21.2,
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          nasaRepositoryProvider.overrideWithValue(mockRepo),
        ],
        child: MaterialApp(
          home: AsteroidResultsScreen(range: range),
        ),
      ),
    );

    // Estado loading.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    // Los nombres deben aparecer.
    expect(find.text('Apophis'), findsOneWidget);
    expect(find.text('2011 AG5'), findsOneWidget);
  });

  testWidgets('AsteroidResultsScreen muestra badge PHA en asteroides peligrosos',
      (tester) async {
    final mockRepo = MockNasaRepository();
    final range = DateRange(
      startDate: DateTime(2025, 4, 13),
      endDate: DateTime(2025, 4, 20),
    );

    when(() => mockRepo.getAsteroids(any())).thenAnswer(
      (_) async => [
        const Asteroid(
          id: '1',
          name: 'Dangerous Rock',
          isPotentiallyHazardous: true,
          closeApproachDate: '2025-04-17',
          missDistanceKm: 1000000,
          relativeVelocityKmPerH: 80000,
          absoluteMagnitude: 18.0,
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          nasaRepositoryProvider.overrideWithValue(mockRepo),
        ],
        child: MaterialApp(
          home: AsteroidResultsScreen(range: range),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Chip de PHA visible.
    expect(find.text('PHA'), findsOneWidget);
  });

  testWidgets('AsteroidResultsScreen muestra estado vacío sin asteroides',
      (tester) async {
    final mockRepo = MockNasaRepository();
    final range = DateRange(
      startDate: DateTime(2025, 4, 13),
      endDate: DateTime(2025, 4, 20),
    );

    when(() => mockRepo.getAsteroids(any())).thenAnswer((_) async => []);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          nasaRepositoryProvider.overrideWithValue(mockRepo),
        ],
        child: MaterialApp(
          home: AsteroidResultsScreen(range: range),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(
      find.textContaining('No se encontraron asteroides'),
      findsOneWidget,
    );
  });

  testWidgets('AsteroidResultsScreen muestra error y botón de reintentar',
      (tester) async {
    final mockRepo = MockNasaRepository();
    final range = DateRange(
      startDate: DateTime(2025, 4, 13),
      endDate: DateTime(2025, 4, 20),
    );

    when(() => mockRepo.getAsteroids(any()))
        .thenThrow(Exception('Sin conexión'));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          nasaRepositoryProvider.overrideWithValue(mockRepo),
        ],
        child: MaterialApp(
          home: AsteroidResultsScreen(range: range),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Reintentar'), findsOneWidget);
  });
}
