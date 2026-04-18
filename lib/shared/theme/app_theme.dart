import 'package:flutter/material.dart';

/// Tema visual de CosmosFlutter — paleta oscura inspirada en el cosmos.
///
/// @what  Centraliza la configuración de colores, tipografía y estilos globales.
/// @why   Un único punto de verdad evita colores hardcodeados en los widgets
///        y facilita cambiar la paleta completa desde aquí.
/// @impact Todos los widgets de la app heredan estos valores mediante Theme.of(context).
class AppTheme {
  AppTheme._();

  // Color semilla — azul profundo espacial.
  static const Color _seedColor = Color(0xFF1A237E);

  /// Construye el ThemeData oscuro de la app.
  static ThemeData dark() => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        navigationBarTheme: const NavigationBarThemeData(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        ),
      );
}
