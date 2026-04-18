/// Módulo de navegación — go_router con ShellRoute y deep linking.
///
/// @what  Demuestra la navegación declarativa de Flutter usando go_router:
///        ShellRoute con NavigationBar de 4 tabs, Drawer lateral con los
///        13 módulos del showcase y deep linking con el esquema cosmos://.
/// @why   La navegación es la base de toda la app; go_router proporciona
///        routing tipado, soporte de deep links y fácil integración con Riverpod.
/// @impact Todas las rutas de la app están declaradas aquí. Cambios en la
///         estructura de rutas afectan el deep linking y los tests de navegación.
///
/// Dependencias cruzadas:
/// - Importado por lib/main.dart (routerProvider).
/// - Consume kModuleCatalog de navigation_data.dart.
/// - Permisos requeridos: ninguno en esta fase.
library;

export 'navigation_data.dart';
export 'providers/navigation_providers.dart';
export 'screens/apod_placeholder_screen.dart';
export 'screens/home_screen.dart';
export 'screens/iss_placeholder_screen.dart';
export 'screens/profile_placeholder_screen.dart';
export 'screens/shell_screen.dart';
export 'widgets/cosmos_drawer.dart';
export 'widgets/module_catalog_card.dart';
