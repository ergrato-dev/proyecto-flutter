import 'package:cosmos_flutter/modules/navigation/navigation_data.dart';
import 'package:cosmos_flutter/modules/navigation/widgets/cosmos_drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Pantalla shell que envuelve todas las rutas con NavigationBar y Drawer.
///
/// @what  Renderiza el layout base de la app: AppBar, NavigationBar inferior,
///        CosmosDrawer lateral, y el contenido de la ruta activa en [child].
/// @why   ShellRoute requiere un widget contenedor; centralizarlo aquí evita
///        duplicar AppBar y NavigationBar en cada pantalla hija.
/// @impact Cambios en esta pantalla afectan el layout de toda la app.
class ShellScreen extends StatelessWidget {
  const ShellScreen({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = tabIndexForLocation(location);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CosmosFlutter'),
        centerTitle: false,
      ),
      drawer: const CosmosDrawer(),
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) => goToTab(context, index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explorar',
          ),
          NavigationDestination(
            icon: Icon(Icons.satellite_alt_outlined),
            selectedIcon: Icon(Icons.satellite_alt),
            label: 'ISS',
          ),
          NavigationDestination(
            icon: Icon(Icons.image_outlined),
            selectedIcon: Icon(Icons.image),
            label: 'APOD',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
