<!--
  ¿Qué? Requisito no funcional que define la estrategia de disponibilidad offline
  y gestión de caché de la app.
  ¿Para qué? Garantizar que el usuario tenga acceso a contenido relevante aunque
  pierda conectividad, con degradación visual informativa.
  ¿Impacto? Afecta a RF-022 (caché) y a todos los módulos que consumen APIs externas.
-->

# RNF-003 — Disponibilidad offline y caché

## Identificación

| Campo         | Valor                              |
| ------------- | ---------------------------------- |
| **ID**        | RNF-003                            |
| **Nombre**    | Disponibilidad offline y caché     |
| **Categoría** | Reliability / Availability         |
| **Prioridad** | Alta                               |
| **Estado**    | Pendiente                          |

---

## Requisitos

### RNF-003.1 — Cobertura mínima offline

Las siguientes funcionalidades deben estar disponibles sin conexión si se han
visitado previamente (caché existente):

| Funcionalidad                  | Fuente de caché            | TTL máximo |
| ------------------------------ | -------------------------- | ---------- |
| Catálogo de cuerpos solares    | drift                      | 24 horas   |
| Detalle de un cuerpo celeste   | drift                      | 24 horas   |
| APOD del día actual            | shared_preferences         | 1 día      |
| Lista de favoritos             | drift (permanente)         | Sin TTL    |
| Tripulación ISS                | shared_preferences         | 1 hora     |

**Verificación:** Tests de widget con `MockClient` desconectado y datos pre-cargados
en los almacenamientos locales.

### RNF-003.2 — Indicador visual de modo degradado

Cuando la app sirve datos desde caché expirada (modo "stale"), se muestra un badge
amarillo con la fecha de la última actualización. El badge no bloquea la
interacción del usuario.

**Verificación:** Test de widget verificando la presencia del `StaleBadge` cuando
`CacheService.isStale()` devuelve `true`.

### RNF-003.3 — Reconexión automática

Al recuperar conectividad, `connectivityProvider` emite un evento que invalida
automáticamente los providers con caché expirada. El usuario ve el contenido
actualizado sin necesidad de acción manual.

**Verificación:** Test de integración simulando ciclo offline → online y verificando
que el provider se invalida.

### RNF-003.4 — Degradación en Flutter Web

En Flutter Web, drift usa almacenamiento en memoria (no persistente entre sesiones).
El comportamiento degradado en Web es:
- Sin conexión y sin caché en memoria: `OfflineWidget` con mensaje explicativo.
- No se muestra contenido vacío silencioso.

**Verificación:** Test de widget con `kIsWeb = true` simulado y `MockDatabase` vacío.

### RNF-003.5 — Gestión de espacio

El sistema no debe acumular caché indefinidamente. La pantalla `StorageManagementScreen`
(RF-006) permite al usuario limpiar la caché. Adicionalmente, al iniciar la app,
se ejecuta una limpieza automática de entradas drift con TTL expirado hace más de
7 días para las tablas de datos de cuerpos solares.

**Verificación:** Test unitario de `CacheService.cleanExpiredEntries()`.
