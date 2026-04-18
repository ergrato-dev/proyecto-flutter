<!--
  ¿Qué? Requisito funcional que define la gestión de cuerpos celestes favoritos
  del usuario, persistidos localmente con drift (SQLite).
  ¿Para qué? Demostrar el uso de base de datos local (drift) para persistencia
  estructurada, combinado con Riverpod para reactividad inmediata.
  ¿Impacto? Afecta a RF-002 (botón favorito en detalle) y a HU-005.
-->

# RF-005 — Favoritos de cuerpos celestes

## Identificación

| Campo           | Valor                                |
| --------------- | ------------------------------------ |
| **ID**          | RF-005                               |
| **Nombre**      | Favoritos de cuerpos celestes        |
| **Módulo**      | `lib/modules/storage/`               |
| **Prioridad**   | Media                                |
| **Estado**      | Pendiente                            |
| **Fecha**       | Abril 2026                           |
| **HU asociada** | HU-005                               |
| **RF previo**   | RF-001, RF-002                       |

---

## Descripción

El sistema permite al usuario marcar cuerpos celestes como favoritos desde la
pantalla de detalle (RF-002). Los favoritos se almacenan en una tabla `favorites`
en la base de datos `drift` local. La pantalla `FavoritesScreen` muestra la lista
de favoritos guardados; desde allí se puede acceder al detalle de cada uno y
eliminarlos individualmente o todos a la vez.

---

## Parámetros de entrada

| Parámetro   | Tipo Dart         | Obligatorio | Validaciones / Notas                                 |
| ----------- | ----------------- | ----------- | ---------------------------------------------------- |
| `bodyId`    | `String`          | Sí          | ID del cuerpo en Solar System OpenData               |
| `bodyName`  | `String`          | Sí          | Nombre para mostrar sin necesidad de re-consultar    |
| `bodyType`  | `String`          | Sí          | Tipo: `planet`, `moon`, `asteroid`, `comet`          |

---

## Flujo

### Agregar favorito
1. Desde `BodyDetailScreen`, el usuario toca el ícono `♡` en el `SliverAppBar`.
2. `favoriteToggleProvider.toggle(bodyId)` comprueba si ya existe en `drift`.
3. Si no existe: inserta la fila en `favorites` y el ícono cambia a `♥` relleno con
   animación de escala + haptic feedback ligero.
4. Si ya existe: elimina la fila y el ícono vuelve a `♡` vacío.
5. El cambio es inmediato (optimista); no hay operación de red.

### Ver lista de favoritos
1. El usuario navega a **Favoritos** desde el Drawer.
2. `FavoritesScreen` usa `favoritesListProvider` (Riverpod `StreamProvider`) que
   observa la tabla `drift` en tiempo real.
3. La lista muestra nombre, tipo e icono de cada cuerpo favorito.
4. Tocar un ítem navega a `BodyDetailScreen` con el `bodyId`.
5. Deslizar un ítem hacia la izquierda muestra la acción **Eliminar** (swipe-to-delete).
6. El botón **Borrar todos** (con confirmación en `AlertDialog`) elimina todos los
   favoritos de la tabla.

---

## Estados y salidas

| Estado    | Condición                             | Widget mostrado                                           |
| --------- | ------------------------------------- | --------------------------------------------------------- |
| `data`    | Hay favoritos en `drift`              | `ListView` con ítems eliminables por swipe                |
| `empty`   | Tabla `favorites` vacía               | Ilustración + "Aún no tienes favoritos — guarda planetas desde su detalle" |

---

## Widgets / Providers asociados

| Nombre                    | Tipo                    | Descripción                                              |
| ------------------------- | ----------------------- | -------------------------------------------------------- |
| `FavoritesScreen`         | `ConsumerWidget`        | Pantalla de gestión de favoritos                         |
| `favoritesListProvider`   | `StreamProvider`        | Stream reactivo de la tabla `favorites` en drift         |
| `favoriteToggleProvider`  | `StateNotifierProvider` | Toggle add/remove para un `bodyId` dado                  |
| `FavoriteItem`            | `StatelessWidget`       | Ítem con `Dismissible` para swipe-to-delete              |
| `AppDatabase`             | `class` (drift)         | Tabla `favorites` con columnas `id`, `name`, `type`, `savedAt` |

---

## Reglas de negocio

- **RN-005.1:** Los favoritos son locales y no se sincronizan con Supabase en esta
  versión; son independientes de la sesión de autenticación.
- **RN-005.2:** No hay límite máximo de favoritos; el usuario puede guardar todos
  los cuerpos del catálogo si lo desea.
- **RN-005.3:** La operación de toggle es atómica (transacción drift) para evitar
  duplicados incluso si el usuario toca rápidamente el botón varias veces.
- **RN-005.4:** Al eliminar un favorito mediante swipe se muestra un `SnackBar`
  con acción **Deshacer** durante 3 segundos.
