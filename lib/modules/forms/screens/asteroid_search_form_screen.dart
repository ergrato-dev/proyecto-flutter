import 'package:cosmos_flutter/modules/forms/models/asteroid.dart';
import 'package:cosmos_flutter/modules/forms/models/date_range.dart';
import 'package:cosmos_flutter/modules/forms/providers/forms_providers.dart';
import 'package:cosmos_flutter/modules/forms/utils/asteroid_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Pantalla principal del módulo formularios: búsqueda de asteroides.
///
/// @what  Formulario con dos `DatePickerDialog` para seleccionar el rango de
///        fechas y lanzar la búsqueda de asteroides en NASA NeoWs.
/// @why   Demuestra `reactive_forms` con validadores personalizados (orden de
///        fechas y límite de 7 días), gestión de foco y cierre de teclado.
/// @impact Requiere `nasaRepositoryProvider` y `nasaNeoWsProvider` (Riverpod).
///         Navega a [AsteroidResultsScreen] tras el submit.
class AsteroidSearchFormScreen extends ConsumerStatefulWidget {
  const AsteroidSearchFormScreen({super.key});

  @override
  ConsumerState<AsteroidSearchFormScreen> createState() =>
      _AsteroidSearchFormScreenState();
}

class _AsteroidSearchFormScreenState
    extends ConsumerState<AsteroidSearchFormScreen> {
  late final FormGroup _form;

  @override
  void initState() {
    super.initState();
    _form = buildAsteroidSearchForm();
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  // Formatea DateTime → 'dd/MM/yyyy' para mostrar en el botón.
  String _formatDate(DateTime? date) {
    if (date == null) return 'Seleccionar fecha';
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Future<void> _pickDate(BuildContext context, String controlName) async {
    final control = _form.control(controlName) as FormControl<DateTime>;
    final initial = control.value ?? DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      helpText: controlName == 'startDate' ? 'Fecha de inicio' : 'Fecha de fin',
    );

    if (picked != null) {
      control.value = picked;
      // Quitar foco para cerrar el teclado si hubiese uno activo.
      if (context.mounted) FocusScope.of(context).unfocus();
    }
  }

  void _onSubmit() {
    _form.markAllAsTouched();
    if (_form.invalid) return;

    final start = (_form.control('startDate') as FormControl<DateTime>).value!;
    final end = (_form.control('endDate') as FormControl<DateTime>).value!;
    final range = DateRange(startDate: start, endDate: end);

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => AsteroidResultsScreen(range: range),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Búsqueda de asteroides')),
      body: ReactiveForm(
        formGroup: _form,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Encabezado informativo.
              Card(
                color: colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.scatter_plot_outlined,
                        color: colorScheme.onPrimaryContainer,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Selecciona un rango de hasta 7 días para buscar '
                          'asteroides cercanos a la Tierra según la NASA.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Selector de fecha inicio.
              Text('Fecha de inicio', style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
              ReactiveFormConsumer(
                builder: (context, form, _) {
                  final control =
                      form.control('startDate') as FormControl<DateTime>;
                  return OutlinedButton.icon(
                    onPressed: () => _pickDate(context, 'startDate'),
                    icon: const Icon(Icons.calendar_today_outlined),
                    label: Text(_formatDate(control.value)),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Selector de fecha fin.
              Text('Fecha de fin', style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
              ReactiveFormConsumer(
                builder: (context, form, _) {
                  final control =
                      form.control('endDate') as FormControl<DateTime>;
                  return OutlinedButton.icon(
                    onPressed: () => _pickDate(context, 'endDate'),
                    icon: const Icon(Icons.calendar_today_outlined),
                    label: Text(_formatDate(control.value)),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Mensajes de error del FormGroup.
              ReactiveFormConsumer(
                builder: (context, form, _) {
                  if (form.valid || !form.touched) {
                    return const SizedBox.shrink();
                  }
                  String? errorMessage;
                  if (form.hasError(kDateOrderError)) {
                    errorMessage =
                        'La fecha de fin no puede ser anterior a la de inicio.';
                  } else if (form.hasError(kDateRangeError)) {
                    errorMessage =
                        'El rango no puede superar los 7 días (límite de la API NASA).';
                  }
                  if (errorMessage == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      errorMessage,
                      style: TextStyle(
                        color: colorScheme.error,
                        fontSize: 13,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),

              // Botón de búsqueda.
              FilledButton.icon(
                onPressed: _onSubmit,
                icon: const Icon(Icons.search_outlined),
                label: const Text('Buscar asteroides'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Pantalla de resultados ───────────────────────────────────────────────────

/// Pantalla que muestra la lista de asteroides del rango buscado.
///
/// @what  Consume [nasaNeoWsProvider] y muestra los asteroides con badge PHA.
/// @why   Demuestra `FutureProvider.family` con estado loading/data/error en un
///        `ListView.builder` agrupado, indicando el riesgo de cada asteroide.
/// @impact Depende de [NasaRepository.getAsteroids]. Los tests mockean el provider.
class AsteroidResultsScreen extends ConsumerWidget {
  const AsteroidResultsScreen({required this.range, super.key});

  final DateRange range;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asteroidsAsync = ref.watch(nasaNeoWsProvider(range));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${_fmt(range.startDate)} – ${_fmt(range.endDate)}',
          style: const TextStyle(fontSize: 14),
        ),
      ),
      body: asteroidsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorView(
          message: 'No se pudieron cargar los asteroides.\n$error',
          onRetry: () => ref.invalidate(nasaNeoWsProvider(range)),
        ),
        data: (asteroids) {
          if (asteroids.isEmpty) {
            return const Center(
              child: Text('No se encontraron asteroides en este rango.'),
            );
          }
          return _AsteroidList(asteroids: asteroids);
        },
      ),
    );
  }

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}

// ─── Widgets privados ─────────────────────────────────────────────────────────

/// Lista de asteroides ordenada por fecha de acercamiento.
class _AsteroidList extends StatelessWidget {
  const _AsteroidList({required this.asteroids});

  final List<Asteroid> asteroids;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: asteroids.length,
      itemBuilder: (context, index) =>
          _AsteroidTile(asteroid: asteroids[index]),
    );
  }
}

/// Tile de un asteroide con badge PHA y datos de acercamiento.
class _AsteroidTile extends StatelessWidget {
  const _AsteroidTile({required this.asteroid});

  final Asteroid asteroid;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isPha = asteroid.isPotentiallyHazardous;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor:
            isPha ? colorScheme.errorContainer : colorScheme.primaryContainer,
        child: Icon(
          isPha ? Icons.warning_amber_outlined : Icons.scatter_plot_outlined,
          color: isPha
              ? colorScheme.onErrorContainer
              : colorScheme.onPrimaryContainer,
          size: 20,
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              asteroid.name,
              style: theme.textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isPha)
            Chip(
              label: const Text('PHA'),
              backgroundColor: colorScheme.errorContainer,
              labelStyle: TextStyle(
                color: colorScheme.onErrorContainer,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
      subtitle: Text(
        _buildSubtitle(),
        style: theme.textTheme.bodySmall
            ?.copyWith(color: colorScheme.onSurfaceVariant),
      ),
    );
  }

  String _buildSubtitle() {
    final parts = <String>[
      asteroid.closeApproachDate,
      '${(asteroid.missDistanceKm / 1000).toStringAsFixed(0)} k km',
      '${asteroid.relativeVelocityKmPerH.toStringAsFixed(0)} km/h',
    ];
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
            Text(message, textAlign: TextAlign.center),
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
