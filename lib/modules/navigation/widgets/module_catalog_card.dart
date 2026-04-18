import 'package:cosmos_flutter/modules/navigation/navigation_data.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Card del catálogo de módulos en la HomeScreen.
///
/// @what  Muestra el nombre, descripción, icono y estado de plataforma de un módulo.
/// @why   Encapsula la presentación de cada módulo para que HomeScreen solo
///        gestione la lista, sin lógica de presentación duplicada.
/// @impact Cambios de estilo aquí afectan todas las cards del catálogo.
class ModuleCatalogCard extends StatelessWidget {
  const ModuleCatalogCard({super.key, required this.module});

  final ModuleInfo module;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go(module.route),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabecera: icono + nombre del módulo.
              Row(
                children: [
                  Icon(module.icon, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      module.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Descripción breve del módulo.
              Text(
                module.description,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Chips de estado por plataforma.
              Wrap(
                spacing: 4,
                children: [
                  _PlatformChip(
                    label: 'Android',
                    ready: module.androidReady,
                  ),
                  _PlatformChip(
                    label: 'Web',
                    ready: module.webReady,
                  ),
                  _PlatformChip(
                    label: 'iOS',
                    ready: module.iosReady,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Chip pequeño que indica si una plataforma está soportada.
///
/// @what  Muestra "Android ✓" o "Android —" según el estado de [ready].
/// @why   Reutilizable en ModuleCatalogCard sin lógica de color duplicada.
/// @impact Cambios de estilo afectan todos los chips de plataforma del catálogo.
class _PlatformChip extends StatelessWidget {
  const _PlatformChip({required this.label, required this.ready});

  final String label;
  final bool ready;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Chip(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      label: Text(
        ready ? '$label ✓' : '$label —',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: ready
                  ? colorScheme.onTertiaryContainer
                  : colorScheme.onSurfaceVariant,
            ),
      ),
      backgroundColor: ready
          ? colorScheme.tertiaryContainer
          : colorScheme.surfaceContainerHighest,
    );
  }
}
