<!--
  ¿Qué? Requisito funcional que define la capa de caché local y el modo offline
  transversal de la app.
  ¿Para qué? Documentar la estrategia de caché con drift (datos estructurados) y
  shared_preferences (datos simples), y la detección de conectividad con
  connectivity_plus.
  ¿Impacto? Afecta a todos los módulos que consumen APIs (RF-001 al RF-010).
-->

# RF-022 — Caché local y modo offline

## Identificación

| Campo           | Valor                              |
| --------------- | ---------------------------------- |
| **ID**          | RF-022                             |
| **Nombre**      | Caché local y modo offline         |
| **Módulo**      | `lib/shared/`                      |
| **Prioridad**   | Alta                               |
| **Estado**      | Pendiente                          |
| **Fecha**       | Abril 2026                         |
| **HU asociada** | —                                  |
| **RF asociado** | RF-001 al RF-010                   |

---

## Descripción

El módulo compartido `lib/shared/` implementa una estrategia de caché en dos capas:

1. **drift (SQLite):** Datos estructurados de larga duración (catálogo solar, historial
   de observaciones).
2. **shared_preferences:** Datos simples y serialización JSON (APOD del día, historial
   de búsquedas, TTL timestamps).

El provider `connectivityProvider` detecta el estado de la red con `connectivity_plus`
y expone un stream de `ConnectivityResult`. Todos los repositories consultan este
provider para decidir si hacer petición de red o servir desde caché.

---

## Estrategia por tipo de dato

| Tipo de dato               | Almacenamiento | TTL         | Módulo         |
| -------------------------- | -------------- | ----------- | -------------- |
| Catálogo de cuerpos solares| drift          | 24 horas    | RF-001, RF-002 |
| APOD del día               | shared_preferences | 1 día   | RF-004         |
| Historial de búsquedas     | shared_preferences | Persistente | RF-006     |
| Favoritos del usuario      | drift          | Persistente | RF-005         |
| Tripulación ISS            | shared_preferences | 1 hora  | RF-008         |
| Imágenes Artemis           | CachedNetworkImage | 6 horas | RF-018       |

---

## Flujo

1. Cualquier repository comprueba primero el TTL en caché.
2. Si la caché es válida: devuelve los datos sin petición de red.
3. Si la caché expiró o no existe:
   a. `connectivityProvider.hasConnection` verifica si hay red.
   b. Si hay red: petición a la API → actualiza caché → devuelve datos.
   c. Si no hay red y hay caché expirada: devuelve la caché con flag `stale: true`.
   d. Si no hay red y no hay caché: emite `AsyncError` con mensaje offline.
4. El `connectivityProvider` emite un evento de reconexión cuando la red vuelve;
   los providers suscritos se invalidan automáticamente.

---

## Estados y salidas

| Estado      | Condición                                 | Widget mostrado                                         |
| ----------- | ----------------------------------------- | ------------------------------------------------------- |
| `fresh`     | Datos de caché válidos o respuesta de red | Datos sin indicador especial                            |
| `stale`     | Caché expirada sirviendo offline          | Badge amarillo "Datos desactualizados" + timestamp      |
| `offline`   | Sin red, sin caché                        | `OfflineWidget` con mensaje + botón Reintentar          |

---

## Widgets / Providers asociados

| Nombre                    | Tipo                    | Descripción                                              |
| ------------------------- | ----------------------- | -------------------------------------------------------- |
| `connectivityProvider`    | `StreamProvider`        | Estado de red en tiempo real con connectivity_plus       |
| `AppDatabase`             | `class` (drift)         | Base de datos SQLite con tablas de caché                 |
| `CacheService`            | `class`                 | Lógica de TTL compartida por todos los repositories      |
| `OfflineWidget`           | `StatelessWidget`       | Widget reutilizable para estado sin conexión             |

---

## Reglas de negocio

- **RN-022.1:** El TTL se compara contra un timestamp guardado junto a los datos
  en `shared_preferences`; la lógica de TTL no usa fechas del servidor.
- **RN-022.2:** La base de datos drift se inicializa una sola vez en `main.dart`
  y se pasa a los providers como dependencia; no se usan singletons globales.
- **RN-022.3:** En Flutter Web, drift usa una implementación en memoria; los datos
  no persisten entre sesiones del navegador; `shared_preferences` sí persiste
  vía `localStorage`.
- **RN-022.4:** Los datos de caché expirada se sirven en modo degradado pero siempre
  se indica visualmente al usuario con un badge; nunca se muestran sin información.
