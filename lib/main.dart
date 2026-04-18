import 'package:cosmos_flutter/modules/navigation/navigation_module.dart';
import 'package:cosmos_flutter/shared/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Punto de entrada de CosmosFlutter.
///
/// @what  Inicializa ProviderScope (Riverpod) y monta la app raíz.
/// @why   ProviderScope debe estar en el top del árbol para que todos los
///        providers sean accesibles desde cualquier widget.
/// @impact Cualquier provider definido en la app depende de este ProviderScope.
void main() {
  runApp(const ProviderScope(child: CosmosApp()));
}

/// Widget raíz de la aplicación.
///
/// @what  Configura MaterialApp.router con el tema oscuro y el GoRouter
///        provisto por [routerProvider].
/// @why   ConsumerWidget permite leer [routerProvider] reactivamente; si el
///        router cambia (ej. en tests), la app se reconstruye automáticamente.
/// @impact Cambiar el tema o el router aquí afecta toda la app.
class CosmosApp extends ConsumerWidget {
  const CosmosApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'CosmosFlutter',
      theme: AppTheme.dark(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
