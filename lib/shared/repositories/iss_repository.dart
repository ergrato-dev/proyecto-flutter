/// Repositorio que consulta la posición en tiempo real de la ISS.
///
/// @what Obtiene latitud/longitud de la ISS desde Open-Notify y la lista de
///   astronautas actualmente en el espacio.
/// @why Centraliza el polling HTTP para que tanto el módulo `maps/` como
///   `realtime/` consuman la misma fuente de datos.
/// @impact Cambios aquí afectan la pantalla de mapa ISS y las alertas de paso.
library;

// TODO(fase-6): implementar con Dio + polling + Supabase broadcast.
class IssRepository {
  // Stub — se implementa en la Fase 6 (módulo maps/).
}
