<!--
  ¿Qué? Requisito funcional que define el broadcast en tiempo real de la posición
  ISS mediante Supabase Realtime como alternativa al polling.
  ¿Para qué? Documentar el módulo realtime/ que demuestra Supabase Realtime channels
  con Riverpod StreamProvider y reconexión automática.
  ¿Impacto? Complementa RF-007 (polling) con un enfoque push. Afecta a HU-007.
-->

# RF-009 — Broadcast realtime de posición ISS

## Identificación

| Campo           | Valor                                    |
| --------------- | ---------------------------------------- |
| **ID**          | RF-009                                   |
| **Nombre**      | Broadcast realtime de posición ISS       |
| **Módulo**      | `lib/modules/realtime/`                  |
| **Prioridad**   | Media                                    |
| **Estado**      | Pendiente                                |
| **Fecha**       | Abril 2026                               |
| **HU asociada** | HU-007                                   |
| **RF previo**   | RF-007                                   |

---

## Descripción

El módulo `realtime/` demuestra el uso de Supabase Realtime como alternativa al
polling de Open-Notify. Un proceso servidor (o un Supabase Edge Function de ejemplo)
publica la posición ISS en un canal de broadcast `iss-position`. La app se suscribe
a ese canal y recibe actualizaciones push. La pantalla `IssRealtimeScreen` visualiza
el stream y el estado de la conexión del canal.

---

## Parámetros de entrada

| Parámetro | Tipo Dart | Obligatorio | Validaciones / Notas                                         |
| --------- | --------- | ----------- | ------------------------------------------------------------ |
| —         | —         | —           | La suscripción es automática al montar el widget             |

---

## Flujo

1. El usuario activa el toggle **Modo Realtime** en `IssMapScreen` (o navega a la
   pantalla dedicada `IssRealtimeScreen`).
2. `issRealtimeProvider` (Riverpod `StreamProvider`) crea un canal Supabase
   `supabase.channel('iss-position')` y llama a `.on(RealtimeListenTypes.broadcast, ...)`.
3. La pantalla muestra el indicador de estado del canal:
   - `CONNECTING` → spinner azul.
   - `SUBSCRIBED` → indicador verde pulsante.
   - `CLOSED` / `CHANNEL_ERROR` → indicador rojo con opción de reconectar.
4. Cada evento broadcast lleva el payload `{lat: double, lon: double, timestamp: int}`.
5. Al recibir un evento, el mapa actualiza el marcador ISS (igual que RF-007).
6. Si el canal se cierra inesperadamente (timeout o pérdida de red), el provider
   implementa reconexión exponencial (1 s → 2 s → 4 s, máximo 30 s).
7. Al desmontar el widget, `supabase.removeChannel(channel)` se ejecuta en
   `ref.onDispose` del provider.

---

## Estados y salidas

| Estado         | Condición                      | Widget mostrado                                               |
| -------------- | ------------------------------ | ------------------------------------------------------------- |
| `connecting`   | Canal no suscrito aún          | Spinner + "Conectando al canal ISS…"                          |
| `subscribed`   | Canal activo y recibiendo datos | Indicador verde + últimas coordenadas recibidas               |
| `error`        | Canal en error / reconectando  | Indicador rojo + contador de reintentos + "Reconectando…"     |
| `disconnected` | Canal cerrado por el usuario   | Mensaje "Realtime detenido"                                   |

---

## Widgets / Providers asociados

| Nombre                 | Tipo                    | Descripción                                                      |
| ---------------------- | ----------------------- | ---------------------------------------------------------------- |
| `IssRealtimeScreen`    | `ConsumerWidget`        | Pantalla de demostración del canal broadcast                     |
| `issRealtimeProvider`  | `StreamProvider`        | Suscripción Supabase Realtime con reconexión exponencial         |
| `RealtimeStatusBadge`  | `StatelessWidget`       | Indicador de color del estado del canal                          |
| `SupabaseClient`       | `class` (supabase_flutter) | Instancia global inicializada en `main.dart`                  |

---

## Reglas de negocio

- **RN-009.1:** El canal de broadcast `iss-position` es de solo lectura para el
  cliente; la app nunca publica mensajes, solo se suscribe.
- **RN-009.2:** Las credenciales Supabase (`SUPABASE_URL`, `SUPABASE_ANON_KEY`) se
  leen siempre de `.env` mediante `flutter_dotenv`; nunca se hardcodean.
- **RN-009.3:** El módulo realtime y el módulo de polling (RF-007) son mutuamente
  excluyentes en la UI: activar uno desactiva el otro.
- **RN-009.4:** Si Supabase Realtime no está disponible (cuota free tier agotada),
  la app cae back automáticamente al modo polling de RF-007.
