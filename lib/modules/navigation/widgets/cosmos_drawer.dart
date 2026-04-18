import 'package:cosmos_flutter/modules/navigation/navigation_data.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Drawer lateral con acceso a todos los módulos del showcase.
///
/// @what  Lista todos los módulos de [kModuleCatalog] con su icono y descripción,
///        más un enlace directo a las tabs principales.
/// @why   El NavigationBar solo muestra 4 tabs; el Drawer expone los 13 módulos.
/// @impact Cambios en [kModuleCatalog] se reflejan automáticamente aquí.
class CosmosDrawer extends StatelessWidget {
  const CosmosDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      child: Column(
        children: [
          // Cabecera del drawer con identidad visual de la app.
          DrawerHeader(
            decoration: BoxDecoration(color: colorScheme.primaryContainer),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.rocket_launch_outlined,
                  size: 40,
                  color: colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'CosmosFlutter',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                          ),
                    ),
                    Text(
                      'Showcase astronómico',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Lista scrollable de módulos.
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: kModuleCatalog.length,
              itemBuilder: (context, index) {
                final module = kModuleCatalog[index];
                return ListTile(
                  leading: Icon(module.icon),
                  title: Text(module.name),
                  subtitle: Text(
                    module.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    // Cierra el drawer y navega al módulo seleccionado.
                    Navigator.of(context).pop();
                    context.go(module.route);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
