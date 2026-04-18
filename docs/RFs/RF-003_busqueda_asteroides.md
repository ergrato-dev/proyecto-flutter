<!--
  ¿Qué? Requisito funcional que define el formulario de búsqueda de asteroides
  cercanos a la Tierra mediante la API NASA NeoWs.
  ¿Para qué? Documentar la funcionalidad del módulo forms/, que demuestra reactive_forms
  con validadores personalizados, gestión de foco y resultados paginados.
  ¿Impacto? Afecta a HU-006 y al historial local RF-007. Depende de NasaRepository.
-->

# RF-003 — Búsqueda de asteroides por fecha

## Identificación

| Campo           | Valor                                        |
| --------------- | -------------------------------------------- |
| **ID**          | RF-003                                       |
| **Nombre**      | Búsqueda de asteroides por fecha             |
| **Módulo**      | `lib/modules/forms/`                         |
| **Prioridad**   | Alta                                         |
| **Estado**      | Pendiente                                    |
| **Fecha**       | Abril 2026                                   |
| **HU asociada** | HU-006                                       |
| **RF asociado** | RF-007 (historial de búsquedas)              |

---

## Descripción

La pantalla `AsteroidSearchScreen` presenta un formulario validado con `reactive_forms`
que permite al usuario definir un rango de fechas (inicio y fin) y una distancia
máxima en unidades astronómicas (UA). Al enviar el formulario, el sistema consulta
la API NASA NeoWs (`/neo/rest/v1/feed`) y muestra los asteroides que pasarán o
pasaron cerca de la Tierra en ese período. Los asteroides potencialmente peligrosos
(PHA) se destacan visualmente.

---

## Parámetros de entrada

| Parámetro       | Tipo Dart  | Obligatorio | Validaciones                                                              |
| --------------- | ---------- | ----------- | ------------------------------------------------------------------------- |
| `startDate`     | `DateTime` | Sí          | No puede ser posterior a `endDate`                                        |
| `endDate`       | `DateTime` | Sí          | No puede ser anterior a `startDate`; máximo 7 días después de `startDate` |
| `maxDistance`   | `double?`  | No          | En UA; si se provee, debe ser > 0 y ≤ 1.0                                |

---

## Flujo

1. El usuario navega a **Asteroides** desde el Drawer o tab.
2. `AsteroidSearchScreen` muestra el formulario con tres campos:
   - `startDate`: selector de fecha (campo tapeable que abre `showDatePicker`).
   - `endDate`: selector de fecha.
   - `maxDistance`: `TextFormField` numérico (opcional).
3. La validación ocurre en tiempo real al editar cada campo:
   - Si `endDate < startDate` → error inmediato bajo `endDate`.
   - Si rango > 7 días → error inmediato bajo `endDate`.
   - Si `maxDistance` no es numérico → error bajo el campo.
4. El botón **Buscar** permanece deshabilitado mientras el formulario tenga errores.
5. Al pulsar **Buscar** válido:
   a. El botón muestra `CircularProgressIndicator` y queda deshabilitado.
   b. `asteroidSearchProvider` ejecuta `NasaRepository.getNeoWs(startDate, endDate)`.
   c. La búsqueda (sin el filtro de distancia, que es local) se guarda en el
      historial `drift` (RF-007) antes de esperar la respuesta.
6. Al recibir la respuesta, la lista de resultados reemplaza al formulario (o aparece
   bajo él en pantallas anchas).
7. Cada ítem muestra: nombre, fecha de máxima aproximación, velocidad relativa (km/s),
   distancia mínima (km) y badge rojo **PHA** si es potencialmente peligroso.
8. El usuario puede pulsar **Nueva búsqueda** para limpiar el formulario y volver al
   estado inicial.

---

## Estados y salidas

| Estado       | Condición                          | Widget mostrado                                                    |
| ------------ | ---------------------------------- | ------------------------------------------------------------------ |
| `idle`       | Formulario sin enviar              | Formulario limpio con botón deshabilitado si hay errores           |
| `loading`    | Petición NASA NeoWs en curso       | Botón con spinner; formulario bloqueado                            |
| `data`       | Resultados recibidos               | `ListView` de `AsteroidCard` con resultados ordenados por fecha    |
| `error`      | Fallo de red o API 429/500         | Mensaje de error en español con botón **Reintentar**               |
| `empty`      | Sin asteroides en el rango         | Ilustración + "No se encontraron asteroides en ese período"        |

---

## Widgets / Providers asociados

| Nombre                      | Tipo                      | Descripción                                                   |
| --------------------------- | ------------------------- | ------------------------------------------------------------- |
| `AsteroidSearchScreen`      | `ConsumerStatefulWidget`  | Pantalla con formulario y resultados                          |
| `asteroidSearchProvider`    | `StateNotifierProvider`   | Estado de búsqueda (idle / loading / data / error)            |
| `AsteroidSearchForm`        | `StatelessWidget`         | Formulario `ReactiveForm` con los tres campos                 |
| `AsteroidCard`              | `StatelessWidget`         | Ítem de resultado con datos y badge PHA                       |
| `NasaRepository`            | `class`                   | `getNeoWs(DateTime start, DateTime end)` en `nasa_repository.dart` |
| `searchHistoryProvider`     | `StateNotifierProvider`   | Persiste y lee historial en `drift` (RF-007)                  |

---

## Reglas de negocio

- **RN-003.1:** El rango de fechas no puede superar 7 días; es un límite de la API
  NeoWs no modificable.
- **RN-003.2:** El filtro `maxDistance` se aplica localmente sobre los resultados
  recibidos; no se envía como parámetro a la API.
- **RN-003.3:** Los asteroides PHA (`is_potentially_hazardous_asteroid: true`) se
  muestran siempre al inicio de la lista, independientemente del orden cronológico.
- **RN-003.4:** Ante un error HTTP 429 de la NASA API, el mensaje es:
  "Límite de peticiones alcanzado — intenta de nuevo en una hora."
- **RN-003.5:** Las búsquedas se guardan en historial solo si devuelven resultados
  (`data` state), nunca si la búsqueda resulta en error o vacía.
- **RN-003.6:** La NASA API key se lee de `.env` como `NASA_API_KEY` a través de
  `flutter_dotenv`; nunca se hardcodea.
