<!--
  ¿Qué? Requisito funcional que define el sistema de autenticación con email/contraseña
  usando Supabase Auth.
  ¿Para qué? Documentar el módulo auth/ con reactive_forms, Supabase Auth y guards
  de rutas en go_router.
  ¿Impacto? Afecta a HU-011. Habilita el diario de observaciones (RF-017).
-->

# RF-015 — Autenticación con email y contraseña

## Identificación

| Campo           | Valor                                    |
| --------------- | ---------------------------------------- |
| **ID**          | RF-015                                   |
| **Nombre**      | Autenticación con email y contraseña     |
| **Módulo**      | `lib/modules/auth/`                      |
| **Prioridad**   | Alta                                     |
| **Estado**      | Pendiente                                |
| **Fecha**       | Abril 2026                               |
| **HU asociada** | HU-011                                   |
| **RF asociado** | RF-016 (biometría), RF-017 (diario)      |

---

## Descripción

El módulo `auth/` provee pantallas de registro (`SignUpScreen`) e inicio de sesión
(`SignInScreen`) con formularios `reactive_forms`. La autenticación se realiza contra
Supabase Auth (`supabase_flutter`). Al autenticarse correctamente, `AuthSessionNotifier`
actualiza el estado global de sesión y `go_router` redirige al área protegida. Los
errores se muestran en español junto al campo correspondiente.

---

## Parámetros de entrada

| Parámetro    | Tipo Dart | Obligatorio | Validaciones                                                             |
| ------------ | --------- | ----------- | ------------------------------------------------------------------------ |
| `email`      | `String`  | Sí          | Formato email válido; máx. 254 caracteres                                |
| `password`   | `String`  | Sí          | Mínimo 8 caracteres, al menos 1 mayúscula y 1 dígito (registro)         |
| `displayName`| `String`  | Solo registro | Mínimo 2 caracteres; máx. 50 (solo en `SignUpScreen`)                |

---

## Flujo

### Registro
1. El usuario accede a `SignUpScreen` desde el botón "Crear cuenta".
2. Completa email, contraseña y nombre visible.
3. Los campos se validan en tiempo real con validadores `reactive_forms` personalizados.
4. Al pulsar **Registrarse** (válido):
   a. `authNotifierProvider.signUp(email, password, displayName)` llama a
      `supabase.auth.signUp(email: email, password: password, data: {displayName})`.
   b. Se muestra `CircularProgressIndicator` en el botón; formulario bloqueado.
   c. Si éxito: Supabase envía email de confirmación; se navega a `EmailConfirmationScreen`.
   d. Si error (email ya en uso → 422): mensaje "Este email ya está registrado".

### Inicio de sesión
1. El usuario accede a `SignInScreen` desde el botón "Iniciar sesión".
2. Introduce email y contraseña.
3. Al pulsar **Entrar**:
   a. `authNotifierProvider.signIn(email, password)` llama a
      `supabase.auth.signInWithPassword(email, password)`.
   b. Si éxito: `AuthSessionNotifier` emite el nuevo `Session`; go_router navega
      al área protegida (`/profile`).
   c. Si error de credenciales: "Email o contraseña incorrectos."

### Cierre de sesión
1. El usuario pulsa **Cerrar sesión** desde el perfil.
2. `authNotifierProvider.signOut()` llama a `supabase.auth.signOut()`.
3. `go_router` redirige a `SignInScreen`.

---

## Estados y salidas

| Estado      | Condición                               | Widget mostrado                                           |
| ----------- | --------------------------------------- | --------------------------------------------------------- |
| `idle`      | Formulario sin enviar                   | Formulario con campos habilitados                         |
| `loading`   | Petición Supabase en curso              | Spinner en botón; campos bloqueados                       |
| `success`   | Sesión iniciada                         | Redirección automática por `go_router`                    |
| `error`     | Credenciales inválidas o error de red   | Mensaje de error en español bajo el formulario            |
| `emailConfirmation` | Registro exitoso, esperando confirmación | Pantalla informativa con instrucciones         |

---

## Widgets / Providers asociados

| Nombre                    | Tipo                      | Descripción                                                |
| ------------------------- | ------------------------- | ---------------------------------------------------------- |
| `SignInScreen`            | `ConsumerWidget`          | Formulario de inicio de sesión                             |
| `SignUpScreen`            | `ConsumerWidget`          | Formulario de registro                                     |
| `EmailConfirmationScreen` | `StatelessWidget`         | Pantalla post-registro esperando confirmación              |
| `authSessionProvider`     | `StateNotifierProvider`   | Estado global de sesión; escucha `onAuthStateChange`       |
| `AuthSessionNotifier`     | `StateNotifier`           | Expone `signIn`, `signUp`, `signOut`; única fuente de verdad |
| `SupabaseClient`          | `class` (supabase_flutter)| Instancia global inicializada en `main.dart`               |

---

## Reglas de negocio

- **RN-015.1:** Las credenciales Supabase nunca se hardcodean; se leen de `.env`
  con `flutter_dotenv` (`SUPABASE_URL`, `SUPABASE_ANON_KEY`).
- **RN-015.2:** La contraseña nunca se registra en logs ni se almacena en texto
  claro; el campo usa `obscureText: true` con toggle para visibilidad.
- **RN-015.3:** Tras 5 intentos fallidos de inicio de sesión, Supabase bloquea
  temporalmente la cuenta; el mensaje mostrado es: "Demasiados intentos — espera
  unos minutos antes de intentarlo de nuevo."
- **RN-015.4:** La `service_role` key de Supabase nunca se incluye en el cliente
  de Flutter; solo se usa la `anon key`.
- **RN-015.5:** El guard de ruta de `go_router` verifica `authSessionProvider.value`
  antes de permitir navegación a rutas protegidas; si no hay sesión, redirige a
  `/auth/signin`.
