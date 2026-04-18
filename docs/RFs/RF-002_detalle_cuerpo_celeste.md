<!--
  ¿Qué? Requisito funcional que define la pantalla de detalle de un cuerpo celeste.
  ¿Para qué? Documentar la funcionalidad de consulta de propiedades físicas y
  orbitales de un objeto del sistema solar; caso de uso de navegación push con datos.
  ¿Impacto? Depende de RF-001; es el destino de toda navegación desde el catálogo.
  Afecta a HU-002.
-->

# RF-002 — Detalle de cuerpo celeste

## Identificación

| Campo           | Valor                               |
| --------------- | ----------------------------------- |
| **ID**          | RF-002                              |
| **Nombre**      | Detalle de cuerpo celeste           |
| **Módulo**      | `lib/modules/lists/`                |
| **Prioridad**   | Alta                                |
| **Estado**      | Pendiente                           |
| **Fecha**       | Abril 2026                          |
| **HU asociada** | HU-002                              |
| **RF previo**   | RF-001                              |

---

## Descripción

Al seleccionar un ítem del catálogo (RF-001), la app navega a `BodyDetailScreen`,
que muestra la ficha completa del cuerpo celeste. Los datos se obtienen del endpoint
`/bodies/{id}` de Solar System OpenData. La pantalla organiza la información en
secciones colapsables: datos físicos, datos orbitales, composición atmosférica (si
aplica) y cuerpos relacionados (lunas del planeta o planeta anfitrión si es luna).

---

## Parámetros de entrada

| Parámetro  | Tipo Dart | Obligatorio | Validaciones / Notas                                           |
| ---------- | --------- | ----------- | -------------------------------------------------------------- |
| `bodyId`   | `String`  | Sí          | ID del cuerpo según la API (`id` del modelo `CelestialBody`)  |
| `bodyName` | `String`  | Sí          | Se usa como título inicial antes de cargar el detalle          |

---

## Flujo

1. `context.push('/bodies/:id', extra: {'name': bodyName})` desde `BodyListItem`.
2. `BodyDetailScreen` recibe `bodyId` por parámetro de ruta (go_router).
3. `bodyDetailProvider(bodyId)` (Riverpod `FutureProvider.family`) realiza `GET
   /bodies/{id}` o recupera del caché `drift` si existe entrada válida.
4. Mientras carga: `CustomScrollView` con `SliverAppBar` en modo loading y skeleton
   para cada sección.
5. Cuando llegan los datos se renderizan las secciones:
   - **Datos físicos:** masa, densidad, gravedad superficial, radio medio, velocidad
     de escape.
   - **Datos orbitales:** período sidéreo, excentricidad, semi-eje mayor, inclinación.
   - **Atmósfera:** presente / ausente; composición si existe.
   - **Cuerpos relacionados:** lista compacta de lunas (si es planeta) o enlace al
     planeta anfitrión (si es luna).
6. El botón `♡` en el `SliverAppBar` alterna el estado de favorito (RF-006) con
   haptic feedback.
7. El botón de retroceso navega de vuelta al catálogo (`context.pop()`).

---

## Estados y salidas

| Estado    | Condición                          | Widget mostrado                                              |
| --------- | ---------------------------------- | ------------------------------------------------------------ |
| `loading` | Petición en curso                  | `SliverAppBar` + skeletons de secciones                      |
| `data`    | Datos recibidos correctamente      | Ficha completa con secciones expandibles                     |
| `error`   | ID no encontrado o fallo de red    | `ErrorWidget` con botón **Reintentar** y **Volver**          |

---

## Widgets / Providers asociados

| Nombre                        | Tipo                      | Descripción                                               |
| ----------------------------- | ------------------------- | --------------------------------------------------------- |
| `BodyDetailScreen`            | `ConsumerWidget`          | Pantalla de detalle con `SliverAppBar`                    |
| `bodyDetailProvider`          | `FutureProvider.family`   | Obtiene el detalle por ID                                 |
| `favoriteToggleProvider`      | `StateNotifierProvider`   | Gestiona el estado de favorito (RF-006)                   |
| `BodyPhysicalSection`         | `StatelessWidget`         | Sección de datos físicos con `ExpansionTile`              |
| `BodyOrbitalSection`          | `StatelessWidget`         | Sección de datos orbitales                                |
| `RelatedBodiesSection`        | `StatelessWidget`         | Lista compacta de cuerpos relacionados                    |
| `SolarRepository`             | `class`                   | `getBodyDetail(String id)` en `solar_system_repository.dart` |

---

## Reglas de negocio

- **RN-002.1:** Los datos del detalle se cachean por 24 horas en `drift` (misma TTL
  que el listado).
- **RN-002.2:** Si el cuerpo no tiene datos atmosféricos, la sección **Atmósfera**
  muestra "Sin atmósfera conocida" en lugar de ocultarse, para mantener consistencia.
- **RN-002.3:** El estado de favorito se persiste inmediatamente en `drift` sin esperar
  confirmación de red; es una operación puramente local.
- **RN-002.4:** Los valores nulos devueltos por la API (ej. masa desconocida) se
  muestran como "—" (guion em) en la UI, nunca como `null` o vacío.
- **RN-002.5:** La pantalla de detalle es accesible también por deep link:
  `cosmos://bodies/:id`.
