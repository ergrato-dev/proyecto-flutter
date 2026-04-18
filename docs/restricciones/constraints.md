# Restricciones del Proyecto — CosmosFlutter

**Proyecto:** CosmosFlutter — Showcase app de astronomía básica en Flutter  
**Versión:** 1.0  
**Fecha:** Abril 2026  
**Clasificación:** Académico

---

## RC-01 — Restricciones tecnológicas

| ID | Restricción | Justificación |
|---|---|---|
| RC-01.1 | El framework obligatorio es **Flutter SDK 3.29.3**. No se permite migrar a otro framework ni usar versiones distintas del SDK. | El propósito del proyecto es demostrar las capacidades de Flutter. |
| RC-01.2 | El lenguaje es **Dart** con sound null safety. No se permite deshabilitar null safety ni usar `dynamic` implícito. | Garantiza type safety y facilita el mantenimiento académico del código. |
| RC-01.3 | El único gestor de paquetes permitido es **pub** (`flutter pub` / `dart pub`). No se puede usar pnpm, npm, yarn ni bun. | Reproducibilidad de builds y auditoría de dependencias centralizada. |
| RC-01.4 | Todas las versiones de dependencias en `pubspec.yaml` deben ser **exactas** (sin `^`, `>=`, `any`). | Previene la introducción silenciosa de CVEs y builds no reproducibles. |
| RC-01.5 | El backend debe ser **Supabase free tier**. No se permite desplegar infraestructura propia ni usar otros BaaS. | Restricción de presupuesto académico (coste $0). |
| RC-01.6 | La navegación debe implementarse con **go_router**. No se puede usar Navigator 1.0 directamente ni `onGenerateRoute` como único mecanismo de routing. | El showcase debe demostrar explícitamente la configuración de navegación declarativa con go_router. |

---

## RC-02 — Restricciones de APIs externas

| ID | Restricción | Justificación |
|---|---|---|
| RC-02.1 | Solo se pueden consumir las APIs listadas en `copilot-instructions.md` (NASA, Solar System OpenData, Open-Notify). Cualquier API adicional debe ser gratuita y documentada antes de integrarse. | Control de costes y dependencias externas. |
| RC-02.2 | La NASA API key debe ser personal (registrada en `api.nasa.gov`). `DEMO_KEY` solo se admite en desarrollo local, nunca en commits con tests de integración. | El límite de `DEMO_KEY` (30 req/hora) impediría ejecutar la suite de tests completa. |
| RC-02.3 | Las peticiones a Open-Notify usan HTTP (no HTTPS). En Android ≥ 9 se requiere configurar `android:usesCleartextTraffic` o usar un proxy HTTPS. | Limitación de la API Open-Notify que no ofrece endpoint HTTPS. |
| RC-02.4 | El rango máximo de consulta en NASA NeoWs es de **7 días** por petición (límite de la API). La app no puede solicitar rangos superiores. | Restricción impuesta por la API externa, no modificable. |

---

## RC-03 — Restricciones de plataforma

| ID | Restricción | Justificación |
|---|---|---|
| RC-03.1 | La prioridad de desarrollo es **Android → Web → iOS**. Las funcionalidades deben verificarse en Android antes de adaptarse a Web e iOS. | Disponibilidad de dispositivos y emuladores del equipo académico. |
| RC-03.2 | Los módulos que requieren hardware nativo (cámara, giroscopio, biometría) **no son obligatorios en Web**; deben degradarse con un mensaje informativo. | Los navegadores tienen acceso limitado o diferente a APIs de hardware. |
| RC-03.3 | El módulo de cámara AR queda como **stretch goal** (funcionalidad opcional). Su ausencia no bloquea la entrega del proyecto. | Complejidad alta; se prioriza demostrar el mayor número de módulos core. |
| RC-03.4 | iOS requiere cuenta de Apple Developer para pruebas en dispositivo físico. Si no se dispone de ella, iOS se valida únicamente en simulador. | Restricción económica/académica. |

---

## RC-04 — Restricciones de seguridad

| ID | Restricción |
|---|---|
| RC-04.1 | Los archivos `.env`, `.env.local` y cualquier variante **no deben commitearse** al repositorio. El `.gitignore` ya los excluye. |
| RC-04.2 | No se puede publicar la app en Google Play ni App Store en su forma actual (showcase con `DEMO_KEY` o claves de desarrollo). |
| RC-04.3 | Ninguna vulnerabilidad CVE de nivel **moderate, high o critical** puede llegar al branch principal sin mitigación documentada. |
| RC-04.4 | El proyecto no debe almacenar datos personales de terceros; el diario de observaciones es exclusivamente de uso personal del observador autenticado. |

---

## RC-05 — Restricciones de calidad

| ID | Restricción |
|---|---|
| RC-05.1 | La cobertura de tests no puede bajar del **80 %** de líneas y ramas por módulo. Si baja, el commit queda bloqueado. |
| RC-05.2 | No se puede hacer merge a `main` con errores de análisis estático (`dart analyze`) ni de formato (`dart format --set-exit-if-changed .`). |
| RC-05.3 | No se permiten `// TODO` sin issue asociado en el repositorio. |
| RC-05.4 | Cada función, provider y widget debe tener documentación Dartdoc (`///` con `@what / @why / @impact`) antes de considerarse completo. |

---

## RC-06 — Restricciones de proceso y tiempo

| ID | Restricción |
|---|---|
| RC-06.1 | El proyecto sigue el formato **Conventional Commits** con cuerpo pedagógico. Commits sin este formato serán rechazados en la revisión académica. |
| RC-06.2 | Cada módulo debe entregarse con su documentación y tests; no se aceptan módulos "en construcción" en la entrega final. |
| RC-06.3 | El proyecto es **académico y sin fines comerciales**. El uso de las APIs gratuitas de NASA y Solar System OpenData está sujeto a sus respectivos términos de uso. |

---

## RC-07 — Restricciones de arquitectura

| ID | Restricción |
|---|---|
| RC-07.1 | La estructura de carpetas definida en `copilot-instructions.md` (`lib/modules/`, `lib/shared/`) es obligatoria y no puede modificarse sin revisión del equipo. |
| RC-07.2 | No se permiten importaciones cruzadas entre módulos (`lib/modules/auth` no puede importar de `lib/modules/maps`). Toda lógica compartida va en `lib/shared/`. |
| RC-07.3 | El cliente Supabase debe ser `Supabase.instance.client` (singleton inicializado en `main.dart`). No se puede instanciar en otros lugares. |
| RC-07.4 | Los repositorios HTTP de las APIs astronómicas deben centralizarse en `lib/shared/repositories/` (`nasa_repository.dart`, `solar_system_repository.dart`, `iss_repository.dart`). No se permiten llamadas `dio.get()` directas a las APIs en los módulos. |
