import 'package:cosmos_flutter/modules/forms/models/asteroid.dart';
import 'package:cosmos_flutter/modules/forms/models/date_range.dart';
import 'package:cosmos_flutter/shared/repositories/nasa_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider del repositorio NASA. Singleton para toda la app.
///
/// @what  Crea y expone una instancia de [NasaRepository].
/// @why   Centraliza la creación del repositorio para facilitar el mock en tests.
/// @impact Todos los providers de esta app que accedan a la NASA dependen de este.
final nasaRepositoryProvider = Provider<NasaRepository>(
  (ref) => NasaRepository(),
);

/// Provider de la lista de asteroides cercanos a la Tierra para un [DateRange].
///
/// @what  Llama a [NasaRepository.getAsteroids] con el rango dado y expone
///        AsyncValue de List de Asteroid.
/// @why   FutureProvider.family permite cachear los resultados por rango de fechas.
/// @impact Afecta a [AsteroidResultsScreen]. El formulario valida el rango
///         antes de activar este provider.
final nasaNeoWsProvider =
    FutureProvider.family<List<Asteroid>, DateRange>(
  (ref, range) =>
      ref.watch(nasaRepositoryProvider).getAsteroids(range),
);
