import 'package:cosmos_flutter/modules/lists/screens/bodies_screen.dart';
import 'package:cosmos_flutter/modules/navigation/navigation_data.dart';
import 'package:cosmos_flutter/modules/navigation/screens/apod_placeholder_screen.dart';
import 'package:cosmos_flutter/modules/navigation/screens/home_screen.dart';
import 'package:cosmos_flutter/modules/navigation/screens/iss_placeholder_screen.dart';
import 'package:cosmos_flutter/modules/navigation/screens/profile_placeholder_screen.dart';
import 'package:cosmos_flutter/modules/navigation/screens/shell_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Provider que expone la instancia única de GoRouter a toda la app.
///
/// @what  Provee el GoRouter configurado con ShellRoute, rutas de tab y deep linking.
/// @why   Centralizar el router en un Provider permite reemplazarlo en tests
///        sin modificar el árbol de widgets.
/// @impact Cambios en esta instancia afectan toda la navegación de la app.
final routerProvider = Provider<GoRouter>((ref) => _buildRouter());

/// Construye y configura el GoRouter de la aplicación.
///
/// @what  Crea el GoRouter con ShellRoute (NavigationBar inferior) y rutas anidadas.
/// @why   Separar la construcción del provider facilita testear el router de forma aislada.
/// @impact La instancia es creada una sola vez al inicializar el Provider.
GoRouter _buildRouter() => GoRouter(
      initialLocation: '/',

      routes: [
        ShellRoute(
          builder: (context, state, child) => ShellScreen(child: child),
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomeScreen(),
            ),
            GoRoute(
              path: '/iss',
              builder: (context, state) => const IssPlaceholderScreen(),
            ),
            GoRoute(
              path: '/apod',
              builder: (context, state) => const ApodPlaceholderScreen(),
            ),
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfilePlaceholderScreen(),
            ),
            // Rutas de módulos pendientes — se llenarán en fases posteriores.
            ...kModuleCatalog
                .where((m) => !kTabRoutes.contains(m.route) && m.route != '/lists')
                .map(
                  (m) => GoRoute(
                    path: m.route,
                    builder: (context, state) => _ComingSoonScreen(module: m),
                  ),
                ),
            GoRoute(
              path: '/lists',
              builder: (context, state) => const BodiesScreen(),
            ),
          ],
        ),
      ],
    );

/// Pantalla temporal para módulos aún no implementados.
///
/// @what  Muestra un mensaje de "próximamente" para rutas sin pantalla final.
/// @why   Permite que todos los módulos del catálogo tengan ruta válida desde el inicio.
/// @impact Se reemplaza por la pantalla real en la fase correspondiente.
class _ComingSoonScreen extends StatelessWidget {
  const _ComingSoonScreen({required this.module});

  final ModuleInfo module;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(module.name)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(module.icon, size: 64),
              const SizedBox(height: 16),
              Text(
                '${module.name} — Próximamente',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                module.description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
}
