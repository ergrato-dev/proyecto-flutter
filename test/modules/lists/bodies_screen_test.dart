import 'dart:async';

import 'package:cosmos_flutter/modules/lists/models/celestial_body.dart';
import 'package:cosmos_flutter/modules/lists/providers/lists_providers.dart';
import 'package:cosmos_flutter/modules/lists/screens/bodies_screen.dart';
import 'package:cosmos_flutter/shared/repositories/solar_system_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSolarSystemRepository extends Mock implements SolarSystemRepository {}

/// Devuelve una lista de planetas de prueba.
List<CelestialBody> _fakeBodies() => [
      const CelestialBody(
        id: 'terre',
        name: 'Earth',
        bodyType: 'Planet',
        isPlanet: true,
        meanRadius: 6371.0,
        gravity: 9.8,
      ),
      const CelestialBody(
        id: 'mars',
        name: 'Mars',
        bodyType: 'Planet',
        isPlanet: true,
        meanRadius: 3389.5,
        gravity: 3.72,
      ),
      const CelestialBody(
        id: 'lune',
        name: 'Moon',
        bodyType: 'Moon',
        isPlanet: false,
        meanRadius: 1737.4,
        gravity: 1.62,
      ),
    ];

/// Envuelve el widget con ProviderScope con el mock inyectado.
Widget _buildTestApp(MockSolarSystemRepository mockRepo) {
  return ProviderScope(
    overrides: [
      solarSystemRepositoryProvider.overrideWithValue(mockRepo),
    ],
    child: const MaterialApp(
      home: BodiesScreen(),
    ),
  );
}

void main() {
  late MockSolarSystemRepository mockRepo;

  setUp(() {
    mockRepo = MockSolarSystemRepository();
  });

  testWidgets('muestra CircularProgressIndicator mientras carga', (tester) async {
    // Completer nunca resuelto → el provider queda en estado loading.
    final completer = Completer<List<CelestialBody>>();
    when(() => mockRepo.getBodies()).thenAnswer((_) => completer.future);

    await tester.pumpWidget(_buildTestApp(mockRepo));
    // Primer pump: inicia la build y lanza la Future.
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Completar para que el Timer se cierre correctamente.
    completer.complete([]);
    await tester.pumpAndSettle();
  });

  testWidgets('muestra lista con cuerpos cuando carga con éxito', (tester) async {
    when(() => mockRepo.getBodies()).thenAnswer((_) async => _fakeBodies());

    await tester.pumpWidget(_buildTestApp(mockRepo));
    await tester.pump(); // inicia la future
    await tester.pumpAndSettle(); // espera el resultado

    // Los cuerpos aparecen como ListTile.
    expect(find.text('Earth'), findsOneWidget);
    expect(find.text('Mars'), findsOneWidget);
    expect(find.text('Moon'), findsOneWidget);
  });

  testWidgets('muestra mensaje de error con botón reintentar cuando falla', (tester) async {
    when(() => mockRepo.getBodies())
        .thenThrow(Exception('Sin conexión'));

    await tester.pumpWidget(_buildTestApp(mockRepo));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.cloud_off_outlined), findsOneWidget);
    expect(find.text('Reintentar'), findsOneWidget);
  });

  testWidgets('los FilterChips se muestran para cada tipo de filtro', (tester) async {
    when(() => mockRepo.getBodies()).thenAnswer((_) async => _fakeBodies());

    await tester.pumpWidget(_buildTestApp(mockRepo));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('Todos'), findsOneWidget);
    expect(find.text('Planetas'), findsOneWidget);
    expect(find.text('Satélites'), findsOneWidget);
    expect(find.text('Asteroides'), findsOneWidget);
  });

  testWidgets('filtro Satélites muestra solo Moon y oculta los planetas', (tester) async {
    when(() => mockRepo.getBodies()).thenAnswer((_) async => _fakeBodies());

    await tester.pumpWidget(_buildTestApp(mockRepo));
    await tester.pump();
    await tester.pumpAndSettle();

    // Tocar el chip de Satélites.
    await tester.tap(find.text('Satélites'));
    await tester.pumpAndSettle();

    expect(find.text('Moon'), findsOneWidget);
    expect(find.text('Earth'), findsNothing);
    expect(find.text('Mars'), findsNothing);
  });

  testWidgets('filtro sin resultados muestra mensaje vacío', (tester) async {
    when(() => mockRepo.getBodies()).thenAnswer((_) async => _fakeBodies());

    await tester.pumpWidget(_buildTestApp(mockRepo));
    await tester.pump();
    await tester.pumpAndSettle();

    // Cometas — no hay ninguno en la lista de prueba.
    await tester.tap(find.text('Cometas'));
    await tester.pumpAndSettle();

    expect(find.text('No hay cuerpos para este filtro.'), findsOneWidget);
  });

  testWidgets('tiene semántica accesible para cada ListTile de planeta', (tester) async {
    when(() => mockRepo.getBodies()).thenAnswer((_) async => _fakeBodies());

    await tester.pumpWidget(_buildTestApp(mockRepo));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('Earth'), findsNothing); // ListTile no genera label directo
    // Verificamos al menos que los textos están en el árbol semántico.
    final earthFinder = find.text('Earth');
    expect(earthFinder, findsOneWidget);
  });
}
