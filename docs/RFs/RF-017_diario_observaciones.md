<!--
  ¿Qué? Requisito funcional que define el diario personal de observaciones
  astronómicas persistido en Supabase con RLS.
  ¿Para qué? Documentar el módulo auth/ en su caso de uso CRUD autenticado
  con Supabase Postgres + Row Level Security.
  ¿Impacto? Afecta a HU-013. Requiere sesión activa de RF-015.
-->

# RF-017 — Diario personal de observaciones

## Identificación

| Campo           | Valor                                 |
| --------------- | ------------------------------------- |
| **ID**          | RF-017                                |
| **Nombre**      | Diario personal de observaciones      |
| **Módulo**      | `lib/modules/auth/`                   |
| **Prioridad**   | Media                                 |
| **Estado**      | Pendiente                             |
| **Fecha**       | Abril 2026                            |
| **HU asociada** | HU-013                                |
| **RF previo**   | RF-015                                |

---

## Descripción

El módulo permite al usuario autenticado crear, listar, editar y eliminar entradas
de su diario de observaciones astronómicas. Cada entrada registra: fecha, objeto
observado (nombre libre), notas, condiciones atmosféricas (seeing 1-5 estrellas) y
una foto opcional. Los datos se almacenan en la tabla `observations` de Supabase
con RLS activado para que cada usuario solo acceda a sus propias entradas.

---

## Parámetros de entrada

| Parámetro         | Tipo Dart  | Obligatorio | Validaciones                                        |
| ----------------- | ---------- | ----------- | --------------------------------------------------- |
| `observationDate` | `DateTime` | Sí          | No puede ser futura                                 |
| `objectName`      | `String`   | Sí          | 2–100 caracteres                                    |
| `notes`           | `String?`  | No          | Máx. 2000 caracteres                                |
| `seeing`          | `int`      | Sí          | 1–5 (calidad del cielo)                             |
| `photoPath`       | `String?`  | No          | Ruta local o URL de Supabase Storage                |

---

## Flujo

### Crear entrada
1. El usuario accede a **Mi Diario** desde el perfil.
2. `ObservationsListScreen` muestra la lista de entradas previas ordenadas por
   fecha descendente.
3. Botón `+` (FAB): navega a `ObservationFormScreen`.
4. El formulario usa `reactive_forms` con los campos del modelo.
5. Campo foto: `ImagePicker` abre galería; la imagen se sube a Supabase Storage
   en el bucket `observation-photos/{userId}/{timestamp}.jpg`.
6. Al guardar: `observationsRepository.create(entry)` hace un `INSERT` en la tabla
   `observations`.
7. El provider `observationsListProvider` se invalida y recarga.

### Listar entradas
1. `observationsListProvider` (FutureProvider) hace `SELECT * FROM observations
   ORDER BY observation_date DESC` (RLS filtra automáticamente por `auth.uid()`).
2. Cada ítem muestra: fecha, objeto, seeing (estrellas) y miniatura de foto si existe.

### Editar entrada
1. El usuario toca una entrada → `ObservationFormScreen` pre-rellena el formulario.
2. Edición y guardado: `observationsRepository.update(id, entry)` hace `UPDATE`.

### Eliminar entrada
1. Swipe-to-delete o botón en el formulario.
2. `AlertDialog` de confirmación.
3. `observationsRepository.delete(id)` hace `DELETE`.
4. Si hay foto asociada, se elimina también del bucket de Supabase Storage.

---

## Estados y salidas

| Estado    | Condición                    | Widget mostrado                                            |
| --------- | ---------------------------- | ---------------------------------------------------------- |
| `loading` | Cargando lista desde Supabase | Skeleton de 3 tarjetas                                    |
| `data`    | Entradas disponibles          | `ListView` de `ObservationCard`                           |
| `empty`   | Sin observaciones aún         | Ilustración + "Registra tu primera observación astronómica" |
| `error`   | Error de red o Supabase       | Mensaje de error + botón reintentar                        |

---

## Widgets / Providers asociados

| Nombre                       | Tipo                    | Descripción                                              |
| ---------------------------- | ----------------------- | -------------------------------------------------------- |
| `ObservationsListScreen`     | `ConsumerWidget`        | Lista de entradas del diario                             |
| `ObservationFormScreen`      | `ConsumerWidget`        | Formulario de creación/edición                           |
| `observationsListProvider`   | `FutureProvider`        | SELECT de observaciones del usuario autenticado          |
| `ObservationsRepository`     | `class`                 | CRUD contra Supabase `observations` table                |
| `ImagePicker`                | `class`                 | Selección de foto desde galería o cámara                 |

---

## Reglas de negocio

- **RN-017.1:** La tabla `observations` tiene RLS habilitado con política:
  `USING (auth.uid() = user_id)` en `SELECT`, `INSERT`, `UPDATE` y `DELETE`.
- **RN-017.2:** Las fotos se guardan en Supabase Storage en el bucket privado
  `observation-photos`; las URLs incluyen un token firmado con expiración de 1 hora.
- **RN-017.3:** Si la foto supera 5 MB, se comprime con `flutter_image_compress`
  antes de subirla.
- **RN-017.4:** El formulario solo es accesible si `authSessionProvider` tiene
  sesión activa; de lo contrario, go_router redirige a `SignInScreen`.
