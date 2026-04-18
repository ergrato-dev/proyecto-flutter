import 'package:cosmos_flutter/modules/navigation/navigation_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

// ─── Helper ──────────────────────────────────────────────────────────────────

/// Monta HomeScreen dentro de un router mínimo para tests aislados.
Widget buildHomeTestApp() {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) => ShellScreen(child: child),
        routes: [
          GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
          // Rutas destino necesarias para que las cards naveguen sin error.
          ...kModuleCatalog
              .where((m) => m.route != '/')
              .map((m) => GoRoute(
                    path: m.route,
                    builder: (_, __) => Scaffold(
                      body: Text(m.name),
                    ),
                  )),
        ],
      ),
    ],
  );

  return ProviderScope(
    child: MaterialApp.router(routerConfig: router),
  );
}

// ─── Tests de HomeScreen ──────────────────────────────────────────────────────

void main() {
  group('HomeScreen —', () {
    testWidgets('renderiza el título de la sección de catálogo', (tester) async {
      // Verifica que el encabezado del catálogo es visible.
      await tester.pumpWidget(buildHomeTestApp());
      await tester.pumpAndSettle();

      expect(find.text('Módulos del showcase'), findsOneWidget);
    });

    testWidgets('renderiza el módulo Navegación en el catálogo', (tester) async {
      // Verifica que el primer módulo del catálogo aparece.
      await tester.pumpWidget(buildHomeTestApp());
      await tester.pumpAndSettle();

      expect(find.text('Navegación'), findsOneWidget);
    });

    testWidgets('renderiza el módulo Artemis en el catálogo', (tester) async {
      // Verifica que el último módulo del catálogo aparece (scroll necesario).
      await tester.pumpWidget(buildHomeTestApp());
      await tester.pumpAndSettle();

      // Hace scroll hasta el final de la lista para encontrar Artemis.
      await tester.scrollUntilVisible(
        find.text('Artemis'),
        500,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.text('Artemis'), findsOneWidget);
    });

    testWidgets('las cards muestran el chip Android ✓ para módulos listos',
        (tester) async {
      // Verifica que el módulo Navegación (androidReady: true) muestra el chip.
      await tester.pumpWidget(buildHomeTestApp());
      await tester.pumpAndSettle();

      expect(find.text('Android ✓'), findsWidgets);
    });

    testWidgets('las cards muestran Android — para módulos no listos',
        (tester) async {
      // Verifica que módulos sin Android ready muestran el chip negativo.
      await tester.pumpWidget(buildHomeTestApp());
      await tester.pumpAndSettle();

      expect(find.text('Android —'), findsWidgets);
    });

    testWidgets('al tocar la card de Navegación navega a /', (tester) async {
      // Simula tap en la card del módulo Navegación y verifica que no falla.
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          ShellRoute(
            builder: (context, state, child) => ShellScreen(child: child),
            routes: [
              GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
            ],
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(child: MaterialApp.router(routerConfig: router)),
      );
      await tester.pumpAndSettle();

      // La card de navegación está en la ruta '/', tocar no lanza excepción.
      await tester.tap(find.text('Navegación'));
      await tester.pumpAndSettle();

      expect(router.state.uri.toString(), '/');
    });
  });

  // ─── Tests de navigation_data.dart ──────────────────────────────────────────

  group('tabIndexForLocation —', () {
    test('/ devuelve índice 0', () {
      expect(tabIndexForLocation('/'), 0);
    });

    test('/iss devuelve índice 1', () {
      expect(tabIndexForLocation('/iss'), 1);
    });

    test('/apod devuelve índice 2', () {
      expect(tabIndexForLocation('/apod'), 2);
    });

    test('/profile devuelve índice 3', () {
      expect(tabIndexForLocation('/profile'), 3);
    });

    test('ruta desconocida devuelve índice 0 por defecto', () {
      expect(tabIndexForLocation('/unknown'), 0);
    });

    test('subruta de /iss devuelve índice 1', () {
      expect(tabIndexForLocation('/iss/detail'), 1);
    });
  });

  group('kModuleCatalog —', () {
    test('contiene exactamente 13 módulos', () {
      expect(kModuleCatalog.length, 13);
    });

    test('todos los módulos tienen id, name y route no vacíos', () {
      for (final m in kModuleCatalog) {
        expect(m.id, isNotEmpty);
        expect(m.name, isNotEmpty);
        expect(m.route, isNotEmpty);
      }
    });

    test('no hay rutas duplicadas', () {
      final routes = kModuleCatalog.map((m) => m.route).toList();
      expect(routes.toSet().length, routes.length);
    });
  });
}
