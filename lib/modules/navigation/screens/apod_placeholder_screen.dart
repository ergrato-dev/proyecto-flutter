import 'package:flutter/material.dart';

/// Pantalla placeholder para el módulo APOD (Fase 8).
///
/// @what  Muestra un estado "próximamente" para la imagen astronómica del día.
/// @why   Reserva la ruta '/apod' en el NavigationBar mientras la fase 8 no
///        está implementada.
/// @impact Se reemplazará por la implementación real en la fase storage.
class ApodPlaceholderScreen extends StatelessWidget {
  const ApodPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_outlined, size: 64),
            SizedBox(height: 16),
            Text('APOD — Imagen astronómica del día'),
            Text('Disponible en Fase 8 (storage)'),
          ],
        ),
      );
}
