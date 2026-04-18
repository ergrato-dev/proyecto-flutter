import 'package:cosmos_flutter/modules/navigation/navigation_data.dart';
import 'package:cosmos_flutter/modules/navigation/widgets/module_catalog_card.dart';
import 'package:flutter/material.dart';

/// Pantalla principal — catálogo de todos los módulos del showcase.
///
/// @what  Muestra una grilla de [ModuleCatalogCard] con los 13 módulos disponibles.
/// @why   Es la pantalla raíz de la app; da visibilidad inmediata de todo el showcase
///        y permite navegar a cualquier módulo con un toque.
/// @impact Es la pantalla que ve el usuario al iniciar la app (ruta '/').
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Módulos del showcase',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList.builder(
              itemCount: kModuleCatalog.length,
              itemBuilder: (context, index) =>
                  ModuleCatalogCard(module: kModuleCatalog[index]),
            ),
          ),
        ],
      );
}
