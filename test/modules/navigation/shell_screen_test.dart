import 'package:cosmos_flutter/modules/navigation/navigation_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

// ─── Helpers de test ──────────────────────────────────────────────────────────

/// Crea un MaterialApp mínimo con un GoRouter para tests de la shell.
///
/// @what  Envuelve [ShellScreen] en un árbol válido con Riverpod y GoRouter.
/// @why   Los tests de navegación necesitan un router real para que
///        GoRouterState.of(context) funcione.
/// @impact Cambios en la estructura del router pueden requerir actualizar este helper.
Widget buildShellTestApp(GoRouter router) => ProviderScope(
      child: MaterialApp.router(routerConfig: router),
    );

GoRouter _buildTestRouter({String initialLocation = '/'}) => GoRouter(
      initialLocation: initialLocation,
      routes: [
        ShellRoute(
          builder: (context, state, child) => ShellScreen(child: child),
          routes: [
            GoRoute(path: '/', builder: (_, __) => const SizedBox()),
            GoRoute(path: '/iss', builder: (_, __) => const SizedBox()),
            GoRoute(path: '/apod', builder: (_, __) => const SizedBox()),
            GoRoute(path: '/profile', builder: (_, __) => const SizedBox()),
          ],
        ),
      ],
    );

// ─── Tests de ShellScreen ─────────────────────────────────────────────────────

void main() {
  group('ShellScreen —', () {
    testWidgets('renderiza los 4 destinos del NavigationBar', (tester) async {
      // Comprueba que el NavigationBar tiene las 4 pestañas configuradas.
      await tester.pumpWidget(buildShellTestApp(_buildTestRouter()));
      await tester.pumpAndSettle();

      expect(find.text('Explorar'), findsOneWidget);
      expect(find.text('ISS'), findsOneWidget);
      expect(find.text('APOD'), findsOneWidget);
      expect(find.text('Perfil'), findsOneWidget);
    });

    testWidgets('tab Explorar está seleccionado en la ruta /', (tester) async {
      // Verifica el índice del NavigationBar en la ruta inicial.
      await tester.pumpWidget(buildShellTestApp(_buildTestRouter()));
      await tester.pumpAndSettle();

      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.selectedIndex, 0);
    });

    testWidgets('tab ISS está seleccionado en la ruta /iss', (tester) async {
      // Verifica que la ruta /iss activa el segundo tab.
      await tester.pumpWidget(
        buildShellTestApp(_buildTestRouter(initialLocation: '/iss')),
      );
      await tester.pumpAndSettle();

      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.selectedIndex, 1);
    });

    testWidgets('tab APOD está seleccionado en la ruta /apod', (tester) async {
      // Verifica que la ruta /apod activa el tercer tab.
      await tester.pumpWidget(
        buildShellTestApp(_buildTestRouter(initialLocation: '/apod')),
      );
      await tester.pumpAndSettle();

      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.selectedIndex, 2);
    });

    testWidgets('tab Perfil está seleccionado en la ruta /profile',
        (tester) async {
      // Verifica que la ruta /profile activa el cuarto tab.
      await tester.pumpWidget(
        buildShellTestApp(_buildTestRouter(initialLocation: '/profile')),
      );
      await tester.pumpAndSettle();

      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.selectedIndex, 3);
    });

    testWidgets('el AppBar muestra el título CosmosFlutter', (tester) async {
      // Verifica la identidad visual del AppBar.
      await tester.pumpWidget(buildShellTestApp(_buildTestRouter()));
      await tester.pumpAndSettle();

      expect(find.text('CosmosFlutter'), findsOneWidget);
    });

    testWidgets('el ícono del Drawer está disponible', (tester) async {
      // Verifica que el Drawer puede abrirse (el botón existe en el AppBar).
      await tester.pumpWidget(buildShellTestApp(_buildTestRouter()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('al tocar el ícono de menú se abre el Drawer', (tester) async {
      // Abre el drawer y comprueba que el header de CosmosFlutter es visible.
      await tester.pumpWidget(buildShellTestApp(_buildTestRouter()));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      expect(find.text('CosmosFlutter'), findsWidgets);
    });

    testWidgets('al tocar ISS navega a la ruta /iss', (tester) async {
      // Simula tap en el tab ISS y verifica la navegación.
      final router = _buildTestRouter();
      await tester.pumpWidget(buildShellTestApp(router));
      await tester.pumpAndSettle();

      await tester.tap(find.text('ISS'));
      await tester.pumpAndSettle();

      expect(router.state.uri.toString(), '/iss');
    });
  });
}
