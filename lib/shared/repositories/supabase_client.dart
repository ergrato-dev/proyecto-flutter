/// Cliente singleton de Supabase para CosmosFlutter.
///
/// @what Inicializa `supabase_flutter` con las credenciales del `.env` y
///   expone el cliente global para autenticación, base de datos y Realtime.
/// @why Un único punto de inicialización evita múltiples instancias del cliente
///   y garantiza que RLS esté activo en todas las operaciones.
/// @impact Usado por los módulos `auth/` y `realtime/`. Debe inicializarse
///   en `main.dart` antes de `runApp()`.
library;

// TODO(fase-9): implementar con supabase_flutter + flutter_dotenv.
// Ejemplo de inicialización en main.dart:
//   await dotenv.load();
//   await Supabase.initialize(
//     url: dotenv.env['SUPABASE_URL']!,
//     anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
//   );
class SupabaseClient {
  // Stub — se implementa en la Fase 9 (módulo auth/).
}
