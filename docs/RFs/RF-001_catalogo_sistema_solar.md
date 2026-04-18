<!--
  ¿Qué? Requisito funcional que define la visualización del catálogo completo de
  cuerpos del sistema solar.
  ¿Para qué? Documentar formalmente la funcionalidad principal del módulo lists/,
  que demuestra ListView.builder y SliverList con datos reales de una API pública.
  ¿Impacto? Sin este requisito no existe la pantalla de exploración central de la app;
  afecta a HU-001, HU-002 y al flujo de favoritos (RF-006).
-->

# RF-001 — Catálogo del sistema solar

## Identificación

| Campo         | Valor                                   |
| ------------- | --------------------------------------- |
| **ID**        | RF-001                                  |
| **Nombre**    | Catálogo del sistema solar              |
| **Módulo**    | `lib/modules/lists/`                    |
| **Prioridad** | Alta                                    |
| **Estado**    | Pendiente                               |
| **Fecha**     | Abril 2026                              |
| **HU asociada** | HU-001                               |

---

## Descripción

El sistema debe consultar la API pública Solar System OpenData
(`https://api.le-systeme-solaire.net/rest/bodies`) y mostrar la lista completa de
cuerpos del sistema solar. Los elementos se agrupan por tipo (planeta, satélite
natural, asteroide, cometa) y se renderizan con virtualización eficiente para
soportar más de 500 ítems sin pérdida de fluidez. El estado de la petición
(cargando / datos / error) se gestiona con `flutter_riverpod` (`AsyncNotifier`).

---

## Parámetros de entrada

| Parámetro     | Tipo Dart   | Obligatorio | Validaciones / Notas                          |
| ------------- | ----------- | ----------- | --------------------------------------------- |
| `filter`      | `String?`   | No          | Texto libre para filtrar por nombre           |
| `bodyType`    | `BodyType?` | No          | Enum: `planet`, `moon`, `asteroid`, `comet`   |

---

## Flujo

1. El usuario abre la app y navega a la sección **Explorar** (tab principal).
2. `BodyListScreen` se monta; el `bodyListProvider` (Riverpod `FutureProvider`) inicia
   la petición a Solar System OpenData si los datos no están en caché.
3. Mientras la petición está en curso se muestra un `ListView` con 8 ítems skeleton
   (shimmer placeholder).
4. Al recibir la respuesta, los cuerpos se clasifican por tipo y se renderizan con
   `CustomScrollView` + `SliverStickyHeader` + `SliverList`.
5. Si los datos provienen de caché local (`drift`) se muestra un badge **"Datos en
   caché"** con la fecha de última actualización.
6. El usuario puede usar el campo de búsqueda para filtrar por nombre; el filtrado
   ocurre localmente sobre los datos ya cargados.
7. El usuario puede seleccionar un tipo en el selector de categorías para ocultar
   los demás grupos.
8. Al tocar un ítem se navega a `BodyDetailScreen` (RF-002) con `context.push`.

---

## Estados y salidas

| Estado     | Condición                            | Widget mostrado                                                 |
| ---------- | ------------------------------------ | --------------------------------------------------------------- |
| `loading`  | Petición HTTP en curso               | Skeleton `ListView` con 8 placeholders animados                 |
| `data`     | Respuesta recibida correctamente     | `CustomScrollView` agrupado con secciones sticky por tipo       |
| `error`    | Fallo de red o respuesta no-2xx      | `ErrorWidget` con mensaje en español y botón **Reintentar**     |
| `offline`  | Sin conexión, datos en caché local   | Lista completa con banner amarillo **"Sin conexión — caché"**   |
| `empty`    | Filtro activo sin resultados         | Ilustración + texto "No se encontraron cuerpos con ese nombre"  |

---

## Widgets / Providers asociados

| Nombre                | Tipo                   | Descripción                                                        |
| --------------------- | ---------------------- | ------------------------------------------------------------------ |
| `BodyListScreen`      | `ConsumerWidget`       | Pantalla principal del catálogo                                    |
| `bodyListProvider`    | `FutureProvider`       | Obtiene y cachea la lista completa desde la API                    |
| `filteredBodiesProvider` | `Provider`          | Filtra localmente sobre `bodyListProvider` según `filter`/`bodyType` |
| `BodyListItem`        | `StatelessWidget`      | Ítem de lista con nombre, tipo e icono                             |
| `BodyTypeSelector`    | `StatelessWidget`      | Selector de categoría (chips horizontales)                         |
| `SolarRepository`     | `class`                | Cliente HTTP en `lib/shared/repositories/solar_system_repository.dart` |

---

## Reglas de negocio

- **RN-001.1:** Los datos de la API deben cachearse en `drift` con TTL de 24 horas.
  Pasado el TTL, la próxima apertura de la pantalla desencadena una nueva petición.
- **RN-001.2:** El filtrado por nombre es insensible a mayúsculas y acentos
  (normalización con `String.toLowerCase()` + `removeDiacritics`).
- **RN-001.3:** El orden dentro de cada grupo es: planetas por distancia al Sol
  (ascendente), lunas por planeta anfitrión, asteroides y cometas alfabéticamente.
- **RN-001.4:** La API no requiere autenticación. Ante un error HTTP 429 (rate limit)
  se muestra el mensaje "Límite de peticiones alcanzado — intenta en unos minutos."
- **RN-001.5:** En modo offline sin caché disponible se muestra el error con
  instrucción de conectarse a internet; no se permite mostrar lista vacía sin aviso.
