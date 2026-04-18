import 'package:cosmos_flutter/modules/lists/models/celestial_body.dart';
import 'package:cosmos_flutter/shared/repositories/solar_system_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider del repositorio Solar System. Singleton para toda la app.
///
/// @what  Crea y expone una instancia de [SolarSystemRepository].
/// @why   Centraliza la creación del repositorio para facilitar el mock en tests.
/// @impact Todos los providers de este módulo dependen de este provider.
final solarSystemRepositoryProvider = Provider<SolarSystemRepository>(
  (ref) => SolarSystemRepository(),
);

/// Provider que carga la lista completa de cuerpos del sistema solar.
///
/// @what  Llama a [SolarSystemRepository.getBodies] y expone
///        AsyncValue de List de CelestialBody.
/// @why   FutureProvider gestiona automáticamente los estados loading/data/error.
/// @impact Afecta a [BodiesScreen]. La caché de 24h está en el repositorio.
final solarSystemBodiesProvider = FutureProvider<List<CelestialBody>>(
  (ref) => ref.watch(solarSystemRepositoryProvider).getBodies(),
);

/// Provider de detalle de un cuerpo celeste por su ID.
///
/// @what  Llama a [SolarSystemRepository.getBodyById] con el [id] dado.
/// @why   FutureProvider.family permite cachear el detalle por ID.
/// @impact Afecta a [BodyDetailScreen].
final solarSystemBodyProvider =
    FutureProvider.family<CelestialBody, String>(
  (ref, id) => ref.watch(solarSystemRepositoryProvider).getBodyById(id),
);
