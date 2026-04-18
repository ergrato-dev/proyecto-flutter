import 'package:flutter/material.dart';

/// Pantalla placeholder para el módulo ISS (Fase 6).
///
/// @what  Muestra un estado "próximamente" para la vista de posición de la ISS.
/// @why   Reserva la ruta '/iss' en el NavigationBar mientras la fase 6 no
///        está implementada.
/// @impact Se reemplazará por la implementación real en la fase maps/realtime.
class IssPlaceholderScreen extends StatelessWidget {
  const IssPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.satellite_alt_outlined, size: 64),
            SizedBox(height: 16),
            Text('ISS — Posición en tiempo real'),
            Text('Disponible en Fase 6 (maps/realtime)'),
          ],
        ),
      );
}
