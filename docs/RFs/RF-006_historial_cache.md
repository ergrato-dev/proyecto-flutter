<!--
  ¿Qué? Requisito funcional que define el historial local de búsquedas de asteroides
  y la gestión de caché con pantalla de administración.
  ¿Para qué? Documentar el uso combinado de shared_preferences (historial liviano) y
  drift (caché estructurado), con UX de gestión de almacenamiento.
  ¿Impacto? Depende de RF-003 (búsquedas) y RF-004 (caché APOD). Afecta a HU-005.
-->

# RF-006 — Historial de búsquedas y gestión de caché

## Identificación

| Campo           | Valor                                         |
| --------------- | --------------------------------------------- |
| **ID**          | RF-006                                        |
| **Nombre**      | Historial de búsquedas y gestión de caché     |
| **Módulo**      | `lib/modules/storage/`                        |
| **Prioridad**   | Media                                         |
| **Estado**      | Pendiente                                     |
| **Fecha**       | Abril 2026                                    |
| **HU asociada** | HU-005                                        |
| **RF asociado** | RF-003, RF-004                                |

---

## Descripción

El sistema persiste las últimas 10 búsquedas de asteroides (parámetros de fecha y
distancia) en `shared_preferences`. Desde la pantalla de búsqueda (RF-003) el
usuario puede recuperar una búsqueda reciente con un toque. Además, la pantalla
`StorageManagementScreen` muestra el espacio ocupado por la caché (imágenes APOD
y datos de cuerpos solares) y permite borrarlo.

---

## Flujo

### Historial de búsquedas
1. Cada búsqueda exitosa en RF-003 serializa sus parámetros como JSON y los
   prepende a la lista en `shared_preferences` (clave `search_history`).
2. Si la lista supera 10 elementos, se elimina el más antiguo.
3. Al entrar a `AsteroidSearchScreen`, `searchHistoryProvider` lee la lista y
   la muestra bajo el formulario como chips horizontales desplazables.
4. El usuario toca un chip → los campos del formulario se rellenan con esos
   parámetros → puede editar y buscar directamente.
5. El usuario puede borrar una entrada individual (toque en ✕ del chip) o
   limpiar todo el historial desde la pantalla de gestión de caché.

### Gestión de caché
1. El usuario accede a **Caché** desde el Drawer → `StorageManagementScreen`.
2. La pantalla calcula y muestra:
   - Espacio de caché de imágenes APOD (`shared_preferences` serializado): en KB.
   - Espacio de la BD `drift` (cuerpos solares + favoritos): en KB.
   - Total combinado.
3. Botones de acción individual:
   - **Borrar caché APOD**: elimina todas las entradas `apod_cache_*` de
     `shared_preferences`.
   - **Borrar datos de cuerpos**: vacía las tablas `bodies` y `body_details` en
     drift pero conserva `favorites`.
   - **Borrar historial**: limpia `search_history` en `shared_preferences`.
4. Botón **Borrar todo**: solicita confirmación en `AlertDialog` antes de proceder.
5. Tras borrar, los contadores de espacio se actualizan inmediatamente.

---

## Estados y salidas

| Estado    | Condición                  | Widget mostrado                                       |
| --------- | -------------------------- | ----------------------------------------------------- |
| `data`    | Historial no vacío         | Chips horizontales con las últimas búsquedas          |
| `empty`   | Sin historial              | No se muestra la sección de chips                     |
| `loading` | Calculando espacio de caché | `CircularProgressIndicator` en tarjetas de espacio    |

---

## Widgets / Providers asociados

| Nombre                      | Tipo                    | Descripción                                              |
| --------------------------- | ----------------------- | -------------------------------------------------------- |
| `StorageManagementScreen`   | `ConsumerWidget`        | Pantalla de gestión de caché                             |
| `searchHistoryProvider`     | `StateNotifierProvider` | Lee/escribe historial en `shared_preferences`            |
| `cacheStatsProvider`        | `FutureProvider`        | Calcula tamaño de cada caché                             |
| `SearchHistoryChips`        | `StatelessWidget`       | Fila horizontal de chips de historial                    |
| `CacheStatCard`             | `StatelessWidget`       | Tarjeta con tamaño y botón de borrar por categoría       |

---

## Reglas de negocio

- **RN-006.1:** El historial se limita a 10 entradas; la décimo-primera entrada
  desplaza a la más antigua (FIFO).
- **RN-006.2:** El espacio mostrado es aproximado (tamaño de los datos serializados);
  no se usa una API nativa de sistema de archivos para mayor portabilidad Web.
- **RN-006.3:** Borrar la caché de cuerpos solares no elimina los favoritos del
  usuario (tabla `favorites` se conserva siempre).
- **RN-006.4:** Tras borrar el caché, la próxima apertura de las pantallas afectadas
  desencadena una nueva petición a la API correspondiente.
