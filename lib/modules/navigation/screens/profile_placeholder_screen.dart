import 'package:flutter/material.dart';

/// Pantalla placeholder para el módulo de autenticación / perfil (Fase 10).
///
/// @what  Muestra un estado "próximamente" para el perfil del observador.
/// @why   Reserva la ruta '/profile' en el NavigationBar mientras la fase 10
///        no está implementada.
/// @impact Se reemplazará por la pantalla de auth/perfil en la fase auth.
class ProfilePlaceholderScreen extends StatelessWidget {
  const ProfilePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_outline, size: 64),
            SizedBox(height: 16),
            Text('Perfil del observador'),
            Text('Disponible en Fase 10 (auth)'),
          ],
        ),
      );
}
