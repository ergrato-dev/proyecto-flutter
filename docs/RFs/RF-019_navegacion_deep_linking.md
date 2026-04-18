<!--
  ¿Qué? Requisito funcional que define el sistema de navegación principal con
  go_router, ShellRoute, deep linking y guards de autenticación.
  ¿Para qué? Documentar el módulo navigation/ que es la columna vertebral de toda
  la app: todas las rutas, la NavigationBar y el Drawer parten de aquí.
  ¿Impacto? Afecta a todos los módulos. Cambios en rutas requieren revisar go_router config.
-->

# RF-019 — Navegación principal y deep linking

## Identificación

| Campo           | Valor                                    |
| --------------- | ---------------------------------------- |
| **ID**          | RF-019                                   |
| **Nombre**      | Navegación principal y deep linking      |
| **Módulo**      | `lib/modules/navigation/`                |
| **Prioridad**   | Alta                                     |
| **Estado**      | Pendiente                                |
| **Fecha**       | Abril 2026                               |
| **HU asociada** | HU-015                                   |

---

## Descripción

El módulo `navigation/` configura el árbol de rutas de la app con `go_router`.
La navegación usa un `ShellRoute` que envuelve un `NavigationBar` de 5 tabs
(Home, Planetas, ISS, APOD, Más). El `Drawer` ofrece acceso a módulos secundarios.
El guard de autenticación redirige a `SignInScreen` si se intenta acceder a rutas
protegidas sin sesión. El esquema de deep linking `cosmos://` permite abrir
pantallas específicas desde fuera de la app.

---

## Parámetros de entrada

| Parámetro   | Tipo Dart | Obligatorio | Validaciones / Notas                                        |
| ----------- | --------- | ----------- | ----------------------------------------------------------- |
| `deepLinkUri` | `Uri?`  | No          | URI del esquema `cosmos://`; procesado en `GoRouter.redirect` |

---

## Estructura de rutas

| Ruta                            | Pantalla                   | Protegida |
| ------------------------------- | -------------------------- | --------- |
| `/`                             | `HomeScreen` (catálogo)    | No        |
| `/bodies`                       | `BodyListScreen`           | No        |
| `/bodies/:id`                   | `BodyDetailScreen`         | No        |
| `/apod`                         | `ApodScreen`               | No        |
| `/asteroids`                    | `AsteroidSearchScreen`     | No        |
| `/iss`                          | `IssMapScreen`             | No        |
| `/iss/crew`                     | `IssCrew`                  | No        |
| `/animations`                   | `OrbitAnimationScreen`     | No        |
| `/starmap`                      | `StarMapScreen`            | No        |
| `/camera`                       | `ConstellationCameraScreen`| No        |
| `/artemis`                      | `ArtemisScreen`            | No        |
| `/notifications`                | `NotificationSettingsScreen` | No      |
| `/platform`                     | `PlatformShowcaseScreen`   | No        |
| `/profile`                      | `ProfileScreen`            | Sí        |
| `/profile/diary`                | `ObservationsListScreen`   | Sí        |
| `/profile/diary/new`            | `ObservationFormScreen`    | Sí        |
| `/profile/diary/:id`            | `ObservationFormScreen`    | Sí        |
| `/auth/signin`                  | `SignInScreen`             | No        |
| `/auth/signup`                  | `SignUpScreen`             | No        |
| `/storage`                      | `StorageManagementScreen`  | No        |

## Flujo

1. Al iniciar la app, `go_router.redirect` verifica `authSessionProvider`.
2. Si la ruta solicitada es protegida y no hay sesión → redirect a `/auth/signin`.
3. Si hay sesión y la ruta es `/auth/signin` o `/auth/signup` → redirect a `/profile`.
4. El `ShellRoute` renderiza el `NavigationBar` persistente en la parte inferior.
5. Las tabs del `NavigationBar` usan `context.go(route)` (reset de pila).
6. El `Drawer` usa `context.push(route)` para mantener la pila de navegación.
7. Deep links del esquema `cosmos://bodies/earth` → `go_router` lo resuelve como
   `/bodies/earth`.

---

## Estados y salidas

| Estado         | Condición                          | Widget mostrado                                        |
| -------------- | ---------------------------------- | ------------------------------------------------------ |
| `authenticated`| Sesión activa                      | NavigationBar + Drawer con ítem de Perfil visible      |
| `anonymous`    | Sin sesión                         | NavigationBar + Drawer con ítem "Iniciar sesión"       |
| `deepLink`     | App abierta por URI cosmos://      | Pantalla correspondiente a la ruta del URI             |

---

## Widgets / Providers asociados

| Nombre                | Tipo                    | Descripción                                               |
| --------------------- | ----------------------- | --------------------------------------------------------- |
| `AppRouter`           | `class`                 | Configura `GoRouter` con rutas, guards y deep links       |
| `MainScaffold`        | `StatefulWidget`        | `ShellRoute` con `NavigationBar` y `Drawer`               |
| `AppDrawer`           | `StatelessWidget`       | Drawer con todos los módulos secundarios                  |
| `authSessionProvider` | `StateNotifierProvider` | Estado de sesión; consultado por el guard de rutas        |

---

## Reglas de negocio

- **RN-019.1:** Las rutas protegidas se definen en una lista centralizada en
  `AppRouter`; agregar o quitar rutas protegidas solo requiere modificar esa lista.
- **RN-019.2:** El deep link scheme `cosmos://` debe declararse en
  `AndroidManifest.xml` (Android) y `Info.plist` (iOS).
- **RN-019.3:** En Flutter Web, las rutas se mapean a paths URL normales
  (`/bodies/earth`); el deep linking usa el URL del navegador.
- **RN-019.4:** `context.go` se usa para tabs (resetea la pila); `context.push` se
  usa para navegación dentro de una tab (apila pantallas).
