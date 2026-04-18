<!--
  ¿Qué? Requisito no funcional que define los estándares de seguridad de la app.
  ¿Para qué? Garantizar que no se expongan credenciales, que los datos del usuario
  estén protegidos y que la app no tenga vulnerabilidades conocidas.
  ¿Impacto? Afecta a todos los módulos que manejan credenciales, sesión o datos de usuario.
-->

# RNF-002 — Seguridad

## Identificación

| Campo         | Valor                     |
| ------------- | ------------------------- |
| **ID**        | RNF-002                   |
| **Nombre**    | Seguridad                 |
| **Categoría** | Security                  |
| **Prioridad** | Alta                      |
| **Estado**    | Pendiente                 |

---

## Requisitos

### RNF-002.1 — Almacenamiento seguro de credenciales

Las credenciales sensibles (tokens de sesión de Supabase, estado de biometría)
se almacenan exclusivamente en `flutter_secure_storage`, que usa el Keystore de
Android y el Keychain de iOS. **Nunca** se guardan en `shared_preferences`,
variables globales ni en el código fuente.

**Verificación:** Revisión de código; búsqueda de `SharedPreferences` en el
módulo `auth/`; ausencia de secrets en el repositorio con `git log --all -S 'key'`.

### RNF-002.2 — Variables de entorno

Las claves de API (NASA, Supabase URL, Supabase Anon Key) se cargan desde el
archivo `.env` con `flutter_dotenv`. El archivo `.env` está incluido en `.gitignore`
y **nunca** se commitea. Se provee un `.env.example` con los nombres de variables
pero sin valores.

**Verificación:** `git ls-files .env` no debe devolver ningún resultado.

### RNF-002.3 — Row Level Security en Supabase

Todas las tablas de Supabase (`observations`, `favorites` si se sincronizan)
tienen RLS habilitado. Las políticas aseguran que cada usuario solo accede a sus
propios registros (`USING (auth.uid() = user_id)`). La `service_role` key nunca
se incluye en el código cliente.

**Verificación:** Test de integración intentando leer registros de otro usuario con
un token válido de otro usuario → debe retornar vacío.

### RNF-002.4 — Auditoría de dependencias

Antes de cada commit se ejecuta `dart pub audit`. No se aceptan vulnerabilidades
de severidad `moderate` o superior sin resolución documentada.

**Verificación:** CI/CD ejecuta `dart pub audit --json` y falla si hay
vulnerabilidades ≥ moderate.

### RNF-002.5 — Comunicaciones HTTPS

Todas las comunicaciones de red usan HTTPS salvo la excepción documentada de
Open-Notify (HTTP). En Android ≥ 9, la excepción para `api.open-notify.org`
está declarada explícitamente en el `network_security_config.xml`; no se usa
`android:usesCleartextTraffic="true"` global.

**Verificación:** Inspección del `AndroidManifest.xml` y `network_security_config.xml`.

### RNF-002.6 — Protección contra inyección

Los parámetros enviados a Supabase usan siempre el cliente SDK (que parametriza
las queries) y nunca interpolación de strings en SQL. Las entradas de formulario
se validan con `reactive_forms` antes de enviarse.

**Verificación:** Revisión de código; ausencia de `.rpc()` con strings interpolados.
