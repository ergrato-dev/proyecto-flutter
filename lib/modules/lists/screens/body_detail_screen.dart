import 'package:cosmos_flutter/modules/lists/models/celestial_body.dart';
import 'package:cosmos_flutter/modules/lists/providers/lists_providers.dart';
import 'package:cosmos_flutter/modules/lists/utils/body_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Pantalla de detalle de un cuerpo celeste.
///
/// @what  Muestra todos los campos de [CelestialBody] disponibles para el cuerpo
///        identificado por [bodyId], cargados desde [solarSystemBodyProvider].
/// @why   Cumple RF-LIST-04: visualización de datos físicos y orbitales completos.
/// @impact Requiere que la ruta pase [bodyId] correctamente. Navega hacia atrás
///         a [BodiesScreen].
class BodyDetailScreen extends ConsumerWidget {
  const BodyDetailScreen({required this.bodyId, super.key});

  final String bodyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bodyAsync = ref.watch(solarSystemBodyProvider(bodyId));

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle')),
      body: bodyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_off_outlined, size: 64),
                const SizedBox(height: 16),
                Text(
                  'No se pudo cargar el detalle.\n$error',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => ref.invalidate(solarSystemBodyProvider(bodyId)),
                  icon: const Icon(Icons.refresh_outlined),
                  label: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
        data: (body) => _BodyDetail(body: body),
      ),
    );
  }
}

// ─── Widget de contenido ──────────────────────────────────────────────────────

/// Contenido detallado de un cuerpo celeste.
class _BodyDetail extends StatelessWidget {
  const _BodyDetail({required this.body});

  final CelestialBody body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return CustomScrollView(
      slivers: [
        // Encabezado visual con icono grande y nombre.
        SliverToBoxAdapter(
          child: Container(
            color: colorScheme.primaryContainer,
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(
                  iconForBodyType(body.bodyType),
                  size: 80,
                  color: colorScheme.onPrimaryContainer,
                ),
                const SizedBox(height: 12),
                Text(
                  body.name,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (body.alternativeName != null &&
                    body.alternativeName!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      body.alternativeName!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer.withAlpha(180),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                Chip(
                  label: Text(body.bodyType),
                  backgroundColor: colorScheme.secondary,
                  labelStyle:
                      TextStyle(color: colorScheme.onSecondary),
                ),
              ],
            ),
          ),
        ),

        // Secciones de datos.
        SliverList(
          delegate: SliverChildListDelegate([
            _Section(
              title: 'Datos generales',
              children: [
                _DataRow('Planeta principal', body.isPlanet ? 'Sí' : 'No'),
                if (body.aroundPlanetId != null)
                  _DataRow('Satélite de', body.aroundPlanetId!),
                if (body.discoveredBy != null)
                  _DataRow('Descubierto por', body.discoveredBy!),
                if (body.discoveryDate != null)
                  _DataRow('Fecha de descubrimiento', body.discoveryDate!),
              ],
            ),
            _Section(
              title: 'Datos físicos',
              children: [
                _DataRow('Radio medio', _formatKm(body.meanRadius)),
                _DataRow('Radio ecuatorial', _formatKm(body.equaRadius)),
                _DataRow('Radio polar', _formatKm(body.polarRadius)),
                _DataRow('Densidad', _formatUnit(body.density, 'g/cm³')),
                _DataRow('Gravedad', _formatUnit(body.gravity, 'm/s²')),
                _DataRow('Vel. de escape', _formatUnit(body.escape, 'm/s')),
                _DataRow('Temp. media', _formatTemp(body.avgTemp)),
                if (body.massValue != null)
                  _DataRow(
                    'Masa',
                    '${body.massValue} × 10^${body.massExponent} kg',
                  ),
                if (body.volValue != null)
                  _DataRow(
                    'Volumen',
                    '${body.volValue} × 10^${body.volExponent} km³',
                  ),
              ],
            ),
            _Section(
              title: 'Datos orbitales',
              children: [
                _DataRow('Semieje mayor', _formatKm(body.semimajorAxis)),
                _DataRow('Perihelio', _formatKm(body.perihelion)),
                _DataRow('Afelio', _formatKm(body.aphelion)),
                _DataRow(
                    'Excentricidad', _formatUnit(body.eccentricity, '')),
                _DataRow(
                    'Inclinación', _formatUnit(body.inclination, '°')),
                _DataRow(
                    'Período orbital', _formatUnit(body.sideralOrbit, 'días')),
                _DataRow(
                    'Período de rotación',
                    _formatUnit(body.sideralRotation, 'h')),
              ],
            ),
            const SizedBox(height: 32),
          ]),
        ),
      ],
    );
  }

  String _formatKm(double? value) {
    if (value == null || value == 0) return '—';
    return '${value.toStringAsFixed(2)} km';
  }

  String _formatUnit(double? value, String unit) {
    if (value == null) return '—';
    return '${value.toStringAsFixed(4)} $unit'.trim();
  }

  String _formatTemp(double? kelvin) {
    if (kelvin == null || kelvin == 0) return '—';
    return '${kelvin.toStringAsFixed(0)} K';
  }
}

/// Sección con título y lista de filas de datos.
class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Filtrar filas vacías (valor "—") no vale; mejor mostrar todo.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Divider(height: 1),
        ...children,
      ],
    );
  }
}

/// Fila etiqueta–valor para los datos del cuerpo celeste.
class _DataRow extends StatelessWidget {
  const _DataRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
