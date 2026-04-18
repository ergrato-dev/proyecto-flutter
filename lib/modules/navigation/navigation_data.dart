import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Modelo inmutable con la información de cada módulo del showcase.
///
/// @what  Describe un módulo: nombre, ruta, icono y estado por plataforma.
/// @why   Centraliza los metadatos para que HomeScreen y CosmosDrawer
///        no tengan listas duplicadas.
/// @impact Cualquier cambio en la lista de módulos parte de aquí.
class ModuleInfo {
  const ModuleInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.route,
    required this.icon,
    this.androidReady = false,
    this.webReady = false,
    this.iosReady = false,
  });

  final String id;
  final String name;
  final String description;
  final String route;
  final IconData icon;
  final bool androidReady;
  final bool webReady;
  final bool iosReady;
}

/// Catálogo completo de los 13 módulos del showcase.
///
/// @what  Lista de todos los módulos disponibles con su estado de implementación.
/// @why   Fuente única de datos para HomeScreen y CosmosDrawer.
/// @impact Añadir un módulo aquí lo hace aparecer automáticamente en el catálogo.
const List<ModuleInfo> kModuleCatalog = [
  ModuleInfo(
    id: 'navigation',
    name: 'Navegación',
    description: 'go_router: ShellRoute, tabs y deep linking cosmos://',
    route: '/',
    icon: Icons.explore_outlined,
    androidReady: true,
    webReady: true,
  ),
  ModuleInfo(
    id: 'lists',
    name: 'Catálogo Solar',
    description: 'ListView.builder y SliverList con cuerpos del sistema solar',
    route: '/lists',
    icon: Icons.public_outlined,
  ),
  ModuleInfo(
    id: 'forms',
    name: 'Formularios',
    description: 'reactive_forms: búsqueda de asteroides por fecha y distancia',
    route: '/forms',
    icon: Icons.search_outlined,
  ),
  ModuleInfo(
    id: 'animations',
    name: 'Animaciones',
    description: 'Órbitas planetarias animadas con AnimationController',
    route: '/animations',
    icon: Icons.animation_outlined,
  ),
  ModuleInfo(
    id: 'camera',
    name: 'Cámara / AR',
    description: 'AR overlay con constelaciones usando el plugin camera',
    route: '/camera',
    icon: Icons.camera_alt_outlined,
  ),
  ModuleInfo(
    id: 'maps',
    name: 'Mapas — ISS',
    description: 'Posición en tiempo real de la ISS sobre mapa terrestre',
    route: '/maps',
    icon: Icons.map_outlined,
  ),
  ModuleInfo(
    id: 'storage',
    name: 'Almacenamiento',
    description: 'shared_preferences + drift: caché APOD y favoritos',
    route: '/storage',
    icon: Icons.storage_outlined,
  ),
  ModuleInfo(
    id: 'notifications',
    name: 'Notificaciones',
    description: 'Alertas de tormentas solares (DONKI) y paso de la ISS',
    route: '/notifications',
    icon: Icons.notifications_outlined,
  ),
  ModuleInfo(
    id: 'sensors',
    name: 'Sensores',
    description: 'Giroscopio para star map interactivo con sensors_plus',
    route: '/sensors',
    icon: Icons.sensors_outlined,
  ),
  ModuleInfo(
    id: 'auth',
    name: 'Autenticación',
    description: 'Supabase auth + local_auth biométrico: diario de observaciones',
    route: '/auth',
    icon: Icons.lock_outline,
  ),
  ModuleInfo(
    id: 'realtime',
    name: 'Tiempo Real',
    description: 'Posición ISS en tiempo real con Supabase Realtime',
    route: '/realtime',
    icon: Icons.satellite_alt_outlined,
  ),
  ModuleInfo(
    id: 'platform',
    name: 'Platform',
    description: 'Diferencias Android / Web / iOS en permisos y UI',
    route: '/platform',
    icon: Icons.devices_outlined,
  ),
  ModuleInfo(
    id: 'artemis',
    name: 'Artemis',
    description: 'Misiones lunares + galería NASA del proyecto Artemis',
    route: '/artemis',
    icon: Icons.rocket_launch_outlined,
  ),
];

/// Rutas de los tabs del NavigationBar inferior.
const List<String> kTabRoutes = ['/', '/iss', '/apod', '/profile'];

/// Índice de tab para una ruta dada; devuelve 0 si no hay coincidencia.
int tabIndexForLocation(String location) {
  final index = kTabRoutes.indexWhere(
    (route) => location == route || location.startsWith('$route/'),
  );
  return index < 0 ? 0 : index;
}

/// Navega a la ruta correspondiente al índice de tab seleccionado.
void goToTab(BuildContext context, int index) {
  context.go(kTabRoutes[index]);
}
