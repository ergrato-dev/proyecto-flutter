# Plan de Trabajo — CosmosFlutter

**Proyecto:** CosmosFlutter — Showcase app de astronomía básica en Flutter  
**Stack:** Flutter 3.29.3 · Dart 3.7.2 · Riverpod · Supabase · pub  
**Plataformas:** Android → Web → iOS  
**Narrativa:** planetas · satélites · asteroides · clima espacial · ISS · proyecto Artemis  
**Última actualización:** Abril 2026 — documentación inicial adaptada a Flutter

> Marcar cada ítem con `[x]` al completarlo.  
> Añadir la fecha de cierre al final del ítem: `[x] descripción — ✅ 2026-04-17`

---

## Fase 0 — Fundamentos del proyecto

### 0.1 Documentación base
- [x] `copilot-instructions.md` con tema astronómico, APIs y stack Flutter — ✅ 2026-04-17
- [x] `.github/instructions/` — modules, testing, supabase, astronomy-apis (adaptados a Flutter) — ✅ 2026-04-17
- [x] `.github/prompts/` — new-module, new-api-repository, add-tests, audit-dependencies (Flutter) — ✅ 2026-04-17
- [x] `docs/requirements/functional.md` — requisitos funcionales — ✅ 2026-04-17
- [x] `docs/requirements/non-functional.md` — requisitos no funcionales — ✅ 2026-04-17
- [x] `docs/requirements/user-stories.md` — historias de usuario — ✅ 2026-04-17
- [x] `docs/requirements/constraints.md` — restricciones — ✅ 2026-04-17
- [x] `.gitignore` incluyendo `.env`, `build/`, `.dart_tool/`, `.flutter-plugins` — ✅ 2026-04-17

### 0.2 Inicialización del proyecto
- [x] `.docker/Dockerfile` y `.docker/entrypoint.sh` — imagen `cosmos-flutter:dev` construida — ✅ 2026-04-17
  > Corrección aplicada: `flutter precache` corre como root antes de crear el usuario
  > no-root; solo `chmod a+rw /sdks/flutter/bin/cache` (evita `chown -R` de 1.3 GB).
  > Flutter en cirruslabs está en `/sdks/flutter`, no en `/opt/flutter`.
- [x] `docker-compose.yml` con servicios: dev, test, analyze, build_apk, build_web — ✅ 2026-04-17
- [x] `.env.example` con las variables requeridas (sin valores reales) — ✅ 2026-04-17
- [x] `docs/setup/` — guías Docker y local — ✅ 2026-04-17
- [ ] `flutter create --org com.ergrato.cosmos --platforms android,web,ios cosmos_flutter`
- [ ] Verificar que `pubspec.yaml` no tiene `^` ni `>=` (corregir si los hay)
- [ ] `dart pub audit` — sin CVEs reportados
- [ ] Configurar `analysis_options.yaml` con `very_good_analysis` (o equivalente estricto)
- [ ] Registrar clave NASA en `https://api.nasa.gov/` y guardar en `.env`
- [ ] Crear proyecto Supabase free tier y guardar credenciales en `.env`
- [ ] Primer commit: `chore(init): bootstrap Flutter 3.29.3 project with strict analysis`

### 0.3 Estructura de carpetas
- [ ] Crear árbol `lib/modules/` con carpetas vacías para los 13 módulos
- [ ] Crear `lib/shared/widgets/`, `providers/`, `repositories/`, `theme/`
- [ ] Crear `lib/shared/repositories/nasa_repository.dart` (Dio + API key)
- [ ] Crear `lib/shared/repositories/solar_system_repository.dart`
- [ ] Crear `lib/shared/repositories/iss_repository.dart`
- [ ] Crear `lib/shared/repositories/supabase_client.dart` (singleton + init en main.dart)
- [ ] Commit: `chore(structure): create module folders and shared repositories`

### 0.4 Infraestructura de testing
- [ ] Agregar `flutter_test`, `mocktail` con versiones exactas a `dev_dependencies`
- [ ] Configurar `flutter_test` con umbral de cobertura en CI (lcov)
- [ ] `flutter test --coverage` — todos los tests de scaffold PASS
- [ ] Commit: `chore(test): configure flutter_test with mocktail`

---

## Fase 1 — Módulo: Navegación (`navigation/`)

> **Caso de uso astronómico:** navegar entre Planetas, ISS, APOD, Eventos  
> **RF:** RF-NAV-01 al RF-NAV-05 | **HU:** HU-15

- [ ] Instalar go_router con versión exacta y ejecutar `dart pub audit`
- [ ] Implementar `ShellRoute` con `NavigationBar` (Explorar / ISS / APOD / Perfil)
- [ ] Implementar `Drawer` lateral con listado de módulos
- [ ] Pantalla Home: catálogo con nombre, descripción y estado de plataforma por módulo
- [ ] Configurar deep linking (scheme `cosmos://`)
- [ ] Tests: navegación entre tabs, apertura del drawer, deep link
- [ ] `dart pub audit` — sin CVEs
- [ ] Cobertura ≥ 80% en el módulo
- [ ] Commit: `feat(navigation): implement ShellRoute, Drawer and module catalog`

---

## Fase 2 — Módulo: Catálogo solar (`lists/`)

> **Caso de uso astronómico:** catálogo de planetas, lunas y asteroides  
> **RF:** RF-LIST-01 al RF-LIST-05 | **HU:** HU-01, HU-02

- [ ] Implementar `SolarSystemRepository` (Solar System OpenData `/bodies`)
- [ ] Implementar `bodiesProvider` + `bodyDetailProvider` (Riverpod FutureProvider)
- [ ] `ListView.builder` con virtualización para ≥ 500 elementos
- [ ] `CustomScrollView` + `SliverList` agrupado por tipo (planeta / satélite / asteroide / cometa)
- [ ] Pantalla de detalle con todos los campos (RF-LIST-04)
- [ ] Caché 24h + indicador offline
- [ ] Tests: loading, data, error, detalle
- [ ] Cobertura ≥ 80%
- [ ] Commit: `feat(lists): solar system catalog with ListView.builder and SliverList`

---

## Fase 3 — Módulo: Formularios (`forms/`)

> **Caso de uso astronómico:** búsqueda de asteroides por fecha y distancia  
> **RF:** RF-FORM-01 al RF-FORM-06 | **HU:** HU-06

- [ ] Instalar reactive_forms con versión exacta y auditar
- [ ] Implementar validadores: fechas, rango ≤ 7 días
- [ ] Formulario con `DatePickerDialog` (Android / Web / iOS) y campo de distancia
- [ ] Gestión de foco entre campos y cierre de teclado
- [ ] Implementar `NeoWsRepository` + `neoWsProvider` (NASA NeoWs)
- [ ] Lista de resultados con badge PHA (potencialmente peligroso)
- [ ] Tests: validación correcta, error fecha invertida, error rango > 7 días, submit OK
- [ ] Cobertura ≥ 80%
- [ ] Commit: `feat(forms): asteroid search with reactive_forms validation`

---

## Fase 4 — Módulo: APOD + Almacenamiento (`storage/`)

> **Caso de uso astronómico:** imagen astronómica del día y favoritos  
> **RF:** RF-APOD-01 al RF-APOD-03, RF-STOR-01 al RF-STOR-04 | **HU:** HU-04, HU-05

- [ ] Implementar `ApodRepository` + `apodProvider` (NASA APOD, caché 1h)
- [ ] Pantalla APOD: imagen progresiva, título, descripción, créditos
- [ ] Soporte de vídeo APOD (abrir en navegador externo con `url_launcher`)
- [ ] Navegación a APODs anteriores (≤ 30 días)
- [ ] Persistir APOD del día en `shared_preferences` para offline
- [ ] Sistema de favoritos (planetas) persistido localmente con drift
- [ ] Historial de búsquedas de asteroides (últimas 10) con drift
- [ ] Pantalla de gestión de caché con espacio usado y botón borrar
- [ ] Share API: compartir imagen APOD (`share_plus`)
- [ ] Tests: carga, offline fallback, añadir/quitar favorito, historial
- [ ] Cobertura ≥ 80%
- [ ] Commit: `feat(storage): APOD viewer with offline cache and favorites`

---

## Fase 5 — Módulo: Rastreo ISS (`maps/` + `realtime/`)

> **Caso de uso astronómico:** posición en tiempo real de la ISS  
> **RF:** RF-MAP-01 al RF-MAP-05, RF-RT-01 al RF-RT-03 | **HU:** HU-07, HU-08

- [ ] Instalar google_maps_flutter con versión exacta y auditar
- [ ] Implementar `IssRepository` con polling cada 5s (Open-Notify)
- [ ] Implementar `astronautsProvider` (Open-Notify, caché 1h)
- [ ] Mapa con marcador ISS actualizado en tiempo real
- [ ] Trazar trayectoria orbital (últimos 10 min, 120 puntos)
- [ ] Panel de coordenadas superpuesto al mapa
- [ ] Botón "centrar en ISS" + lista de tripulantes
- [ ] Supabase Realtime: publicar posición ISS y suscribir múltiples clientes
- [ ] Reconexión automática tras pérdida de red
- [ ] Tests: render mapa, actualización posición, lista tripulantes, Realtime, reconexión
- [ ] Cobertura ≥ 80%
- [ ] Commit: `feat(maps): ISS real-time tracker with google_maps_flutter`
- [ ] Commit: `feat(realtime): Supabase Realtime ISS position broadcast with auto-reconnect`

---

## Fase 6 — Módulo: Proyecto Artemis (`artemis/`)

> **Caso de uso astronómico:** estado de misiones lunares, cronograma y galería NASA  
> **RF:** RF-ART-01 al RF-ART-04 | **HU:** HU-16

- [ ] Añadir `fetchArtemisImages` a `NasaRepository` (NASA Images API)
- [ ] Implementar `artemisImagesProvider` (Riverpod FutureProvider, caché 6h)
- [ ] Datos estáticos de misiones: Artemis I (completada 2022), Artemis II (tripulada 2026), Artemis III (2027+)
- [ ] `MissionStatusScreen` — lista de misiones con `ListView.builder`
- [ ] `ArtemisGalleryScreen` — galería horizontal de imágenes con `PageView` o `ListView` horizontal
- [ ] Añadir entrada en el Drawer para acceso directo a Artemis
- [ ] Tests: render lista de misiones, estados completada/en-progreso/planificada, carga galería
- [ ] Cobertura ≥ 80%
- [ ] Commit: `feat(artemis): mission status screen and NASA image gallery`

---

## Fase 7 — Módulo: Notificaciones (`notifications/`)

> **Caso de uso astronómico:** alertas de tormentas solares y paso de la ISS  
> **RF:** RF-NOTIF-01 al RF-NOTIF-04 | **HU:** HU-09

- [ ] Instalar `flutter_local_notifications` con versión exacta y auditar
- [ ] Implementar `DonkiRepository` + `donkiProvider` (NASA DONKI, caché 30 min, filtrado M+/X+)
- [ ] Implementar `notificationPermissionProvider` (Android 13+ POST_NOTIFICATIONS)
- [ ] Librería `notification_scheduler.dart`: handler, alerta solar inmediata, APOD diaria
- [ ] `NotificationSettingsScreen`: toggles (solar M+, APOD diaria), banner de permisos
- [ ] Solicitud de permiso con explicación en español
- [ ] Añadir entrada en el Drawer para notificaciones
- [ ] Tests: `isMajorSolarFlare`, `donkiProvider`, `notificationPermissionProvider`, settings screen
- [ ] Cobertura ≥ 80%
- [ ] Commit: `feat(notifications): solar storm alerts and notification settings`

---

## Fase 8 — Módulo: Sensores / Star Map (`sensors/`)

> **Caso de uso astronómico:** mapa estelar controlado por giroscopio  
> **RF:** RF-SENS-01 al RF-SENS-04 | **HU:** HU-10

- [ ] Instalar `sensors_plus` con versión exacta y auditar
- [ ] Implementar `gyroscopeProvider` (StreamProvider — integración velocidad angular → rotación)
- [ ] Implementar `accelerometerProvider` (StreamProvider)
- [ ] Catálogo offline: ≥ 100 estrellas con coordenadas reales RA/Dec J2000.0 + constelaciones
- [ ] `CustomPainter` para renderizar el cielo: proyección equidistante RA/Dec → píxeles
- [ ] Giroscopio controla rotación; fallback a `GestureDetector` (pan) sin giroscopio
- [ ] Label con nombre de constelación más próxima al centro
- [ ] Botón "Centrar" + coordenadas RA/Dec en pantalla
- [ ] Tests: catálogo de datos, `gyroscopeProvider`, `accelerometerProvider`, `StarMapScreen`
- [ ] Cobertura ≥ 80%
- [ ] Commit: `feat(sensors): gyroscope-driven star map with graceful fallback`

---

## Fase 9 — Módulo: Autenticación y perfil (`auth/`)

> **Caso de uso astronómico:** diario personal de observaciones  
> **RF:** RF-AUTH-01 al RF-AUTH-05 | **HU:** HU-11, HU-12, HU-13

- [ ] Instalar `supabase_flutter` + `local_auth` + `flutter_secure_storage` con versiones exactas
- [ ] Implementar `authSessionProvider` (Riverpod StreamProvider — `onAuthStateChange`)
- [ ] Pantalla de registro (email + contraseña, validación reactive_forms)
- [ ] Pantalla de login con opción biométrica (`local_auth`)
- [ ] Guardar token en `flutter_secure_storage` (nunca SharedPreferences sin cifrado)
- [ ] Migración Supabase: tabla `observations` con RLS
- [ ] CRUD de observaciones: crear, listar, editar, eliminar
- [ ] Tests: registro, login, biometría mock, CRUD observaciones mock
- [ ] Cobertura ≥ 80%
- [ ] Commit: `feat(auth): Supabase auth with biometrics and observations diary`

---

## Fase 10 — Módulo: Animaciones (`animations/`)

> **Caso de uso astronómico:** órbitas planetarias animadas  
> **RF:** RF-ANIM-01 al RF-ANIM-04 | **HU:** HU-03

- [ ] Instalar `flutter_animate` con versión exacta y auditar
- [ ] `AnimationController` + `CustomPainter` para órbitas de Mercurio, Venus, Tierra, Marte
- [ ] Velocidades proporcionales a períodos orbitales reales
- [ ] Controles de pausa / reanudación
- [ ] `GestureDetector` + `Transform` para rotación 3D de planeta
- [ ] Spring zoom al seleccionar planeta (`AnimatedScale`)
- [ ] Tests: pausa/resume, gesto drag (mock), spring trigger
- [ ] Cobertura ≥ 80%
- [ ] Commit: `feat(animations): orbital animations with AnimationController and CustomPainter`

---

## Fase 11 — Módulo: Diferencias de plataforma (`platform/`)

> **Caso de uso astronómico:** comparativa Android/Web/iOS  
> **RF:** RF-PLAT-01 al RF-PLAT-03 | **HU:** HU-14

- [ ] Pantalla comparativa: permisos, APIs disponibles, diferencias de UI
- [ ] `CupertinoActionSheet` en iOS vs. `BottomSheet` en Android
- [ ] Responsivo Web: `LayoutBuilder` desde 320 px hasta 1440 px
- [ ] Snippets de código Dart comentados en cada diferencia
- [ ] Tests: render en cada plataforma (mock `Platform.isAndroid / isIOS / kIsWeb`)
- [ ] Cobertura ≥ 80%
- [ ] Commit: `feat(platform): platform differences showcase with responsive web layout`

---

## Fase 12 — Módulo: Cámara AR (`camera/`) ⚡ Stretch goal

> **Caso de uso astronómico:** overlay de constelaciones en AR  
> **RF:** RF-CAM-01 al RF-CAM-05

- [ ] Instalar `camera` con versión exacta y auditar
- [ ] Solicitud de permiso de cámara con `permission_handler` y explicación en español
- [ ] Overlay SVG de constelaciones sobre vista de cámara (`flutter_svg`)
- [ ] Integración con `gyroscopeProvider` del módulo `sensors/` para alinear overlay
- [ ] Captura de foto con previsualización (`takePicture`)
- [ ] Degradación en Web con mensaje informativo
- [ ] Tests: permiso denegado, permiso concedido, captura mock, overlay, Web
- [ ] Cobertura ≥ 80%
- [ ] Commit: `feat(camera): AR constellation overlay with camera plugin`

---

## Fase 13 — Pulido y entrega académica

### 13.1 Tema y accesibilidad
- [ ] Implementar sistema de tema dark/light en `lib/shared/theme/`
- [ ] Verificar contraste WCAG AA en todos los textos
- [ ] Añadir `Semantics` y `Tooltip` en todos los widgets interactivos
- [ ] Tamaño mínimo de área táctil 48×48 dp verificado (directriz Material)

### 13.2 Calidad final
- [ ] `dart analyze` — cero errores ni warnings
- [ ] `dart format --set-exit-if-changed lib/ test/` — código formateado
- [ ] `flutter test --coverage` — todos los módulos ≥ 80%
- [ ] `dart pub audit` — sin CVEs reportados
- [ ] Revisar que no hay `// TODO` sin issue asociado
- [ ] Revisar que no hay `// ignore:` sin comentario justificativo

### 13.3 Documentación final
- [ ] Completar dartdoc (`@what / @why / @impact`) en todos los módulos
- [ ] Actualizar `README.md` con instrucciones de instalación y ejecución
- [ ] Verificar que `.env.example` está actualizado con todas las variables

### 13.4 Commit de cierre
- [ ] Commit: `docs(project): finalize academic documentation and coverage report`

---

## Resumen de progreso

| Fase | Módulo | Estado |
|---|---|---|
| 0 | Fundamentos | ⬜ Pendiente |
| 1 | Navegación | ⬜ Pendiente |
| 2 | Catálogo solar (lists) | ⬜ Pendiente |
| 3 | Formularios (forms) | ⬜ Pendiente |
| 4 | APOD + Storage | ⬜ Pendiente |
| 5 | ISS (maps + realtime) | ⬜ Pendiente |
| 6 | Artemis (missions + gallery) | ⬜ Pendiente |
| 7 | Notificaciones | ⬜ Pendiente |
| 8 | Star Map (sensors) | ⬜ Pendiente |
| 9 | Auth + Perfil | ⬜ Pendiente |
| 10 | Animaciones | ⬜ Pendiente |
| 11 | Platform showcase | ⬜ Pendiente |
| 12 | Cámara AR ⚡ | ⬜ Pendiente |
| 13 | Pulido y entrega | ⬜ Pendiente |

**Leyenda:** ✅ Completo · 🟡 En progreso · ⬜ Pendiente · ⚡ Stretch goal
