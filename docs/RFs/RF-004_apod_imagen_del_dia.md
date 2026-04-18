<!--
  ¿Qué? Requisito funcional que define la visualización de la imagen astronómica
  del día (APOD) de la NASA.
  ¿Para qué? Documentar el caso de uso del módulo storage/ que combina fetching,
  caché local offline y Share API nativa.
  ¿Impacto? Afecta a HU-004, HU-005 y al sistema de caché local RF-008.
-->

# RF-004 — Imagen astronómica del día (APOD)

## Identificación

| Campo           | Valor                                    |
| --------------- | ---------------------------------------- |
| **ID**          | RF-004                                   |
| **Nombre**      | Imagen astronómica del día (APOD)        |
| **Módulo**      | `lib/modules/storage/`                   |
| **Prioridad**   | Alta                                     |
| **Estado**      | Pendiente                                |
| **Fecha**       | Abril 2026                               |
| **HU asociada** | HU-004, HU-005                           |
| **RF asociado** | RF-008 (caché offline)                   |

---

## Descripción

La pantalla `ApodScreen` consulta la API NASA APOD
(`https://api.nasa.gov/planetary/apod`) y muestra la imagen o vídeo astronómico
del día junto a su título, fecha, descripción y créditos de autor. El usuario
puede navegar hasta 30 días hacia atrás usando un selector de fecha. La imagen del
día actual se persiste en `shared_preferences` para acceso offline. El usuario
puede compartir la imagen usando el `Share` nativo de Flutter.

---

## Parámetros de entrada

| Parámetro    | Tipo Dart   | Obligatorio | Validaciones / Notas                                     |
| ------------ | ----------- | ----------- | -------------------------------------------------------- |
| `date`       | `DateTime?` | No          | Si nulo, usa la fecha actual; no puede ser futura        |
| `hdImage`    | `bool`      | No          | Si `true`, carga la versión HD (mayor peso y tiempo)     |

---

## Flujo

1. El usuario navega a la sección **APOD** desde el tab o el Drawer.
2. `ApodScreen` monta el widget; `apodProvider(date)` inicia la petición a la API
   con la fecha actual si `date` es nulo.
3. Mientras carga: placeholder animado con las dimensiones del área de imagen.
4. Al recibir la respuesta:
   - Si `media_type == "image"`: se muestra con `CachedNetworkImage` con la URL
     estándar; tapping abre la URL HD en `InteractiveViewer`.
   - Si `media_type == "video"`: se muestra un thumbnail con ícono de play;
     tapping abre la URL en el navegador externo (`url_launcher`).
5. La APOD del día actual se serializa y guarda en `shared_preferences` con la
   clave `apod_cache_{yyyy-MM-dd}` para acceso offline.
6. Botón **Compartir** (icono en `AppBar`): llama a `Share.shareXFiles` con la
   imagen y el texto "🌌 {title} — NASA APOD {date}".
7. Botón **Fecha anterior / siguiente**: cambia `date`; los datos de fechas ya
   visitadas se sirven desde caché Riverpod sin nueva petición.
8. Botón **Elegir fecha**: abre `showDatePicker` con rango desde 1995-06-16 hasta
   hoy (fecha de la primera APOD publicada).

---

## Estados y salidas

| Estado      | Condición                                  | Widget mostrado                                                     |
| ----------- | ------------------------------------------ | ------------------------------------------------------------------- |
| `loading`   | Petición en curso                          | Placeholder de imagen + skeleton de título y descripción            |
| `data`      | Datos recibidos                            | Imagen/vídeo + título, fecha, descripción, créditos, botón compartir |
| `error`     | Fallo de red o API error                   | Último APOD cacheado si existe + banner "Sin conexión"              |
| `offline`   | Sin red y sin caché para esa fecha         | `ErrorWidget` con icono nube + "No hay datos offline para esta fecha" |

---

## Widgets / Providers asociados

| Nombre                | Tipo                    | Descripción                                                      |
| --------------------- | ----------------------- | ---------------------------------------------------------------- |
| `ApodScreen`          | `ConsumerWidget`        | Pantalla principal del APOD                                      |
| `apodProvider`        | `FutureProvider.family` | Petición a NASA APOD por fecha con caché Riverpod                |
| `ApodMediaWidget`     | `StatelessWidget`       | Renderiza imagen con `CachedNetworkImage` o vídeo con play icon  |
| `ApodDetailSection`   | `StatelessWidget`       | Título, fecha, descripción y créditos                            |
| `apodCacheService`    | `class`                 | Lee/escribe APOD en `shared_preferences`                         |
| `NasaRepository`      | `class`                 | `getApod(DateTime date)` en `nasa_repository.dart`               |

---

## Reglas de negocio

- **RN-004.1:** Solo se cachea offline la APOD de la fecha actual; los APODs de
  fechas anteriores se sirven desde el caché en memoria de Riverpod durante la
  sesión, pero no se persisten en disco de forma indefinida.
- **RN-004.2:** La función Share solo está disponible en Android e iOS; en Flutter
  Web se muestra el botón pero copia el link al portapapeles con aviso.
- **RN-004.3:** Si el copyright del APOD restringe el uso comercial, se debe mostrar
  el crédito completo junto a la imagen; este campo nunca se omite.
- **RN-004.4:** La clave de la NASA API se carga de `.env` como `NASA_API_KEY`;
  ante ausencia de clave se usa `DEMO_KEY` solo en modo debug (límite: 30 req/hora).
- **RN-004.5:** El botón de fecha siguiente se desactiva si la fecha actual ya es
  el día de hoy (no se puede pedir APOD futuro).
