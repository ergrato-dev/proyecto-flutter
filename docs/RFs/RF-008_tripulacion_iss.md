<!--
  ¿Qué? Requisito funcional que define la pantalla de tripulación actual de la ISS
  con datos de Open-Notify y perfil de cada astronauta.
  ¿Para qué? Documentar el módulo maps/ en su caso de uso de listado estático enriquecido,
  complementario al rastreo en tiempo real (RF-007).
  ¿Impacto? Afecta a HU-008. Reutiliza IssRepository.
-->

# RF-008 — Tripulación de la ISS

## Identificación

| Campo           | Valor                              |
| --------------- | ---------------------------------- |
| **ID**          | RF-008                             |
| **Nombre**      | Tripulación de la ISS              |
| **Módulo**      | `lib/modules/maps/`                |
| **Prioridad**   | Media                              |
| **Estado**      | Pendiente                          |
| **Fecha**       | Abril 2026                         |
| **HU asociada** | HU-008                             |
| **RF asociado** | RF-007 (ISS map)                   |

---

## Descripción

La sub-pantalla `IssCrew` (integrada en la pantalla ISS como una pestaña o panel
inferior) muestra la lista de tripulantes actualmente en el espacio según la API
Open-Notify (`http://api.open-notify.org/astros.json`). Para cada tripulante se
muestra nombre, nave asignada y una imagen de perfil cargada desde la Wikipedia
API mediante el nombre. Los datos se cachean durante 1 hora.

---

## Parámetros de entrada

| Parámetro | Tipo Dart | Obligatorio | Validaciones / Notas                        |
| --------- | --------- | ----------- | ------------------------------------------- |
| —         | —         | —           | Sin parámetros; la lista es global          |

---

## Flujo

1. El usuario accede a la pestaña **Tripulación** dentro de la pantalla ISS.
2. `issCrewProvider` verifica si la caché local (TTL 1 hora) tiene datos válidos.
3. Si la caché es válida: los datos se sirven directamente sin petición de red.
4. Si la caché expiró: `IssRepository.getCrew()` llama a Open-Notify y recibe
   la lista `{people: [{name, craft}]}`.
5. Para cada tripulante, `wikiImageProvider(name)` hace una petición a la Wikipedia
   API para obtener la URL de la imagen de perfil; las peticiones son paralelas
   (pero agrupadas por lotes de 3 para no saturar la red).
6. La lista se renderiza con `ListView.builder`: avatar, nombre y nave.
7. Si la Wikipedia API no devuelve imagen, se muestra un avatar placeholder con
   las iniciales del astronauta.
8. El botón **Actualizar** fuerza la invalidación del caché y re-fetching.

---

## Estados y salidas

| Estado    | Condición                         | Widget mostrado                                           |
| --------- | --------------------------------- | --------------------------------------------------------- |
| `loading` | Petición en curso                 | Lista de 4 ítems skeleton (avatar + texto)                |
| `data`    | Lista recibida                    | `ListView` de `CrewMemberCard` con avatar, nombre y nave  |
| `error`   | Error de red                      | Mensaje "No se puede obtener la tripulación ahora"        |

---

## Widgets / Providers asociados

| Nombre               | Tipo                    | Descripción                                              |
| -------------------- | ----------------------- | -------------------------------------------------------- |
| `IssCrew`            | `ConsumerWidget`        | Lista de tripulantes de la ISS                           |
| `issCrewProvider`    | `FutureProvider`        | Fetching con TTL 1 hora; caché en `shared_preferences`   |
| `wikiImageProvider`  | `FutureProvider.family` | Obtiene URL de imagen de perfil de Wikipedia por nombre  |
| `CrewMemberCard`     | `StatelessWidget`       | Tarjeta con avatar `CachedNetworkImage`, nombre y nave   |
| `IssRepository`      | `class`                 | `getCrew()` en `lib/shared/repositories/iss_repository.dart` |

---

## Reglas de negocio

- **RN-008.1:** Los datos de tripulación se cachean 1 hora en `shared_preferences`;
  si la aplicación se cierra y reabre dentro de ese período, no se hace nueva petición.
- **RN-008.2:** La API Wikipedia se consulta solo por nombre; si no se encuentra
  resultado en los primeros 3 candidatos, se usa el avatar con iniciales.
- **RN-008.3:** La nave (`craft`) se muestra completa tal como viene de la API sin
  truncar.
