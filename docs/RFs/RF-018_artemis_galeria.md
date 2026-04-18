<!--
  ¿Qué? Requisito funcional que define la galería de misiones del programa Artemis
  con datos estáticos enriquecidos y galería de imágenes NASA.
  ¿Para qué? Documentar el módulo artemis/ con la NASA Images API y galería
  deslizable de alta calidad.
  ¿Impacto? Módulo independiente; no tiene dependencias con otros módulos.
-->

# RF-018 — Misiones Artemis y galería NASA

## Identificación

| Campo           | Valor                                |
| --------------- | ------------------------------------ |
| **ID**          | RF-018                               |
| **Nombre**      | Misiones Artemis y galería NASA      |
| **Módulo**      | `lib/modules/artemis/`               |
| **Prioridad**   | Baja                                 |
| **Estado**      | Pendiente                            |
| **Fecha**       | Abril 2026                           |
| **HU asociada** | HU-016                               |

---

## Descripción

La pantalla `ArtemisScreen` presenta las misiones del programa Artemis (I, II, III)
con datos estáticos: objetivo, tripulación, fecha planeada y estado. Además, una
galería de imágenes relacionadas se carga desde la NASA Images API
(`https://images-api.nasa.gov/search?q=artemis&media_type=image`). Las imágenes
se muestran en una cuadrícula desplazable (`SliverGrid`) con caché de 6 horas.

---

## Parámetros de entrada

| Parámetro  | Tipo Dart | Obligatorio | Validaciones / Notas                               |
| ---------- | --------- | ----------- | -------------------------------------------------- |
| `query`    | `String`  | No          | Término de búsqueda; default `"artemis"`           |
| `page`     | `int`     | No          | Paginación; default 1; incrementa al llegar al fin |

---

## Flujo

1. El usuario navega a **Artemis** desde el catálogo de módulos o el Drawer.
2. `ArtemisScreen` muestra la tarjeta de cada misión (datos estáticos) en un
   `PageView` horizontal en la parte superior.
3. Bajo el `PageView`, un `SliverGrid` de 2 columnas carga imágenes de la NASA
   Images API mediante `artemisImagesProvider` (FutureProvider con caché 6h).
4. El usuario puede buscar términos específicos en la galería con un `SearchBar`
   flotante.
5. Al pulsar una imagen: se abre en pantalla completa con `InteractiveViewer` y
   se muestra el título y descripción de la imagen.
6. Al llegar al final de la cuadrícula, `artemisImagesProvider` carga la página
   siguiente (paginación infinita).

---

## Estados y salidas

| Estado    | Condición                    | Widget mostrado                                             |
| --------- | ---------------------------- | ----------------------------------------------------------- |
| `loading` | Primera carga de imágenes    | Grid de placeholders grises animados                        |
| `data`    | Imágenes disponibles         | `SliverGrid` con miniaturas de `CachedNetworkImage`         |
| `error`   | Error de red o API           | Tarjetas de misión estáticas + banner "Galería no disponible" |
| `loadingMore` | Cargando página siguiente | Spinner al final del grid                                   |

---

## Widgets / Providers asociados

| Nombre                   | Tipo                    | Descripción                                               |
| ------------------------ | ----------------------- | --------------------------------------------------------- |
| `ArtemisScreen`          | `ConsumerWidget`        | Pantalla con `PageView` de misiones y galería             |
| `MissionCard`            | `StatelessWidget`       | Tarjeta de misión Artemis con datos estáticos             |
| `artemisImagesProvider`  | `FutureProvider`        | Galería de imágenes de NASA Images API con caché 6h       |
| `NasaImagesRepository`   | `class`                 | `searchImages(query, page)` en `nasa_images_repository.dart` |
| `ImageFullScreen`        | `StatelessWidget`       | Visor a pantalla completa con `InteractiveViewer`         |

---

## Reglas de negocio

- **RN-018.1:** Los datos de las misiones Artemis I, II y III son estáticos y
  no dependen de ninguna API; se definen en `lib/modules/artemis/data/missions.dart`.
- **RN-018.2:** La caché de imágenes tiene TTL de 6 horas; tras expirar, la galería
  re-fetcha en silencio (sin interrumpir al usuario).
- **RN-018.3:** Solo se cargan las imágenes de tipo `media_type=image`; no se
  incluyen videos ni audios de la NASA Images API.
- **RN-018.4:** La paginación carga 20 imágenes por página; el usuario debe llegar
  al final del scroll para cargar la siguiente.
