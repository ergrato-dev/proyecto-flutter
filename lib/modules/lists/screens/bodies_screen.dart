import 'package:cosmos_flutter/modules/lists/models/celestial_body.dart';
import 'package:cosmos_flutter/modules/lists/providers/lists_providers.dart';
import 'package:cosmos_flutter/modules/lists/screens/body_detail_screen.dart';
import 'package:cosmos_flutter/modules/lists/utils/body_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Pantalla principal del módulo listas: catálogo de cuerpos del sistema solar.
///
/// @what  Muestra una lista filtrable de todos los cuerpos celestes obtenidos
///        de Solar System OpenData mediante [solarSystemBodiesProvider].
/// @why   Demuestra [ListView.builder] de alto rendimiento con virtualización
///        para ~2000 cuerpos, gestión de estado async con Riverpod y filtro
///        por tipo de cuerpo celeste.
/// @impact Requiere conexión a Internet para la primera carga. La caché de 24h
///         está en [SolarSystemRepository]. Navega a [BodyDetailScreen].
class BodiesScreen extends ConsumerStatefulWidget {
  const BodiesScreen({super.key});

  @override
  ConsumerState<BodiesScreen> createState() => _BodiesScreenState();
}

class _BodiesScreenState extends ConsumerState<BodiesScreen> {
  BodyFilterType _activeFilter = BodyFilterType.all;

  @override
  Widget build(BuildContext context) {
    final bodiesAsync = ref.watch(solarSystemBodiesProvider);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            title: const Text('Sistema Solar'),
            floating: true,
            snap: true,
            forceElevated: innerBoxIsScrolled,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(52),
              child: _FilterChipsRow(
                activeFilter: _activeFilter,
                onFilterChanged: (f) => setState(() => _activeFilter = f),
              ),
            ),
          ),
        ],
        body: bodiesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _ErrorView(
            message: 'No se pudieron cargar los cuerpos celestes.\n$error',
            onRetry: () => ref.invalidate(solarSystemBodiesProvider),
          ),
          data: (bodies) {
            final filtered = bodies
                .where((b) => matchesFilter(b, _activeFilter))
                .toList();

            if (filtered.isEmpty) {
              return const Center(
                child: Text('No hay cuerpos para este filtro.'),
              );
            }

            return ListView.builder(
              key: ValueKey(_activeFilter),
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: filtered.length,
              itemBuilder: (context, index) =>
                  _BodyTile(body: filtered[index]),
            );
          },
        ),
      ),
    );
  }
}

// ─── Widgets privados ─────────────────────────────────────────────────────────

/// Fila de filtros de tipo de cuerpo celeste.
class _FilterChipsRow extends StatelessWidget {
  const _FilterChipsRow({
    required this.activeFilter,
    required this.onFilterChanged,
  });

  final BodyFilterType activeFilter;
  final ValueChanged<BodyFilterType> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        spacing: 8,
        children: BodyFilterType.values.map((filter) {
          return FilterChip(
            label: Text(filter.label),
            selected: activeFilter == filter,
            onSelected: (_) => onFilterChanged(filter),
          );
        }).toList(),
      ),
    );
  }
}

/// Tile de un cuerpo celeste en la lista.
class _BodyTile extends StatelessWidget {
  const _BodyTile({required this.body});

  final CelestialBody body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: colorScheme.primaryContainer,
        child: Icon(
          iconForBodyType(body.bodyType),
          color: colorScheme.onPrimaryContainer,
          size: 20,
        ),
      ),
      title: Text(
        body.name,
        style: theme.textTheme.bodyLarge,
      ),
      subtitle: Text(
        _buildSubtitle(body),
        style: theme.textTheme.bodySmall
            ?.copyWith(color: colorScheme.onSurfaceVariant),
      ),
      trailing: const Icon(Icons.chevron_right_outlined),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => BodyDetailScreen(bodyId: body.id),
        ),
      ),
    );
  }

  String _buildSubtitle(CelestialBody body) {
    final parts = <String>[body.bodyType];
    if (body.meanRadius != null && body.meanRadius! > 0) {
      parts.add('r = ${body.meanRadius!.toStringAsFixed(0)} km');
    }
    if (body.gravity != null && body.gravity! > 0) {
      parts.add('g = ${body.gravity!.toStringAsFixed(2)} m/s²');
    }
    return parts.join(' · ');
  }
}

/// Vista de error con botón de reintentar.
class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, size: 64),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_outlined),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
