---
applyTo: "lib/shared/repositories/**,lib/modules/auth/**,lib/modules/realtime/**"
---

# Instructions — Supabase

## Cliente centralizado

Usar siempre el cliente singleton de `lib/shared/repositories/supabase_client.dart`. Nunca crear instancias adicionales.

```dart
import 'package:cosmos_flutter/shared/repositories/supabase_client.dart';

// acceder al cliente global inicializado en main.dart
final client = Supabase.instance.client;
```

## Seguridad — obligatorio

- **Sin `service_role` key en el cliente**: solo `anon` key.
- **RLS activado** en todas las tablas desde la primera migración.
- Variables de entorno (cargadas con `flutter_dotenv`):
  - `SUPABASE_URL`
  - `SUPABASE_ANON_KEY`
- Nunca hardcodear URLs ni keys en el código fuente.

## Inicialización en main.dart

```dart
/// @what  inicializa Supabase antes de ejecutar la app
/// @why   garantiza que el cliente esté listo antes de cualquier widget
/// @impact si falla, la app no arranca; verificar variables de entorno
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const ProviderScope(child: MyApp()));
}
```

## Patrones de uso

### Auth

```dart
/// @what  suscribe al estado de autenticación de Supabase
/// @why   evita múltiples escuchas en distintas pantallas
/// @impact afecta a todas las rutas protegidas; requiere test actualizado
final subscription = Supabase.instance.client.auth.onAuthStateChange.listen(
  (data) {
    final AuthChangeEvent event = data.event;
    final Session? session = data.session;
    // actualizar estado del provider
  },
);

// cancelar al desmontar el widget / disponer el provider
subscription.cancel();
```

### Queries con RLS

```dart
// correcto — el usuario autenticado solo ve sus propios registros (RLS)
final response = await Supabase.instance.client
    .from('observations')
    .select();

// incorrecto — nunca bypassear RLS desde el cliente
```

### Realtime

```dart
/// @what  suscribe a cambios en tiempo real de la tabla `iss_positions`
/// @why   muestra la posición actualizada de la ISS sin polling manual
/// @impact requiere que RLS permita SELECT a usuarios anónimos en esa tabla
final channel = Supabase.instance.client
    .channel('iss-realtime')
    .onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'iss_positions',
      callback: (payload) { /* actualizar estado */ },
    )
    .subscribe();

// cancelar al disponer el provider
await Supabase.instance.client.removeChannel(channel);
```

## Manejo de errores

```dart
final response = await Supabase.instance.client
    .from('observations')
    .select();

// supabase_flutter lanza PostgrestException en caso de error
// capturar y relanzar con mensaje legible en español
try {
  final data = await Supabase.instance.client.from('observations').select();
  return data;
} on PostgrestException catch (e) {
  throw Exception('Error al cargar observaciones: ${e.message}');
}
```

## Almacenamiento seguro de tokens

Usar `flutter_secure_storage` para guardar el token de sesión:

```dart
// correcto — almacenamiento cifrado (keychain / keystore)
const storage = FlutterSecureStorage();
await storage.write(key: 'session', value: session.persistSessionString);

// incorrecto — SharedPreferences no cifra los datos
await prefs.setString('session', session.persistSessionString);
```
