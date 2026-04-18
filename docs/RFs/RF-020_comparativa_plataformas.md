<!--
  ¿Qué? Requisito funcional que define la pantalla de comparativa de comportamiento
  de la app en Android, iOS y Web.
  ¿Para qué? Documentar el módulo platform/ que demuestra las diferencias de UX
  y APIs nativas entre plataformas.
  ¿Impacto? Afecta a HU-014. No tiene dependencias externas.
-->

# RF-020 — Comparativa de plataformas

## Identificación

| Campo           | Valor                              |
| --------------- | ---------------------------------- |
| **ID**          | RF-020                             |
| **Nombre**      | Comparativa de plataformas         |
| **Módulo**      | `lib/modules/platform/`            |
| **Prioridad**   | Baja                               |
| **Estado**      | Pendiente                          |
| **Fecha**       | Abril 2026                         |
| **HU asociada** | HU-014                             |

---

## Descripción

La pantalla `PlatformShowcaseScreen` compara el comportamiento de la app en
Android, iOS y Web mediante demostraciones interactivas: diálogos nativos
(`AlertDialog` vs `CupertinoAlertDialog`), bottom sheets, gestión de permisos
y widgets adaptativos. Cada sección indica la plataforma actual y resalta las
diferencias visuales y de comportamiento.

---

## Parámetros de entrada

| Parámetro | Tipo Dart | Obligatorio | Validaciones / Notas                          |
| --------- | --------- | ----------- | --------------------------------------------- |
| —         | —         | —           | La plataforma se detecta automáticamente      |

---

## Flujo

1. El usuario navega a **Plataformas** desde el Drawer.
2. `PlatformShowcaseScreen` detecta la plataforma con `Platform.isAndroid`,
   `Platform.isIOS` o `kIsWeb`.
3. Un banner en la parte superior indica la plataforma activa:
   - Android: robot verde + "Android {versionStr}"
   - iOS: manzana + "iOS {versionStr}"
   - Web: globo + "Flutter Web"
4. La pantalla tiene cuatro secciones demostrativas:

   **A) Diálogos:**
   - En Android: muestra `AlertDialog` de Material 3.
   - En iOS: muestra `CupertinoAlertDialog`.
   - En Web: muestra `AlertDialog` de Material.

   **B) Bottom Sheets:**
   - En Android/Web: `showModalBottomSheet` con Material.
   - En iOS: `CupertinoActionSheet`.

   **C) Permisos:**
   - Tabla que muestra los permisos requeridos por módulo y si están disponibles
     en la plataforma actual.

   **D) Widgets adaptativos:**
   - Botones: `TextButton` vs `CupertinoButton`.
   - Switches: `Switch.adaptive`.
   - Sliders: `Slider.adaptive`.

5. Cada sección tiene un botón **Demo** que activa el comportamiento correspondiente.

---

## Estados y salidas

| Estado       | Condición          | Widget mostrado                                        |
| ------------ | ------------------ | ------------------------------------------------------ |
| `android`    | App en Android     | Componentes Material 3 con indicador Android           |
| `ios`        | App en iOS         | Componentes Cupertino con indicador iOS                |
| `web`        | App en Web         | Componentes Material + tabla de limitaciones Web       |

---

## Widgets / Providers asociados

| Nombre                      | Tipo                | Descripción                                             |
| --------------------------- | ------------------- | ------------------------------------------------------- |
| `PlatformShowcaseScreen`    | `StatelessWidget`   | Pantalla principal de comparativa                       |
| `PlatformBanner`            | `StatelessWidget`   | Badge superior con plataforma detectada                 |
| `AdaptiveDialogDemo`        | `StatelessWidget`   | Demo de diálogos según plataforma                       |
| `PermissionMatrix`          | `StatelessWidget`   | Tabla de permisos por módulo y disponibilidad           |

---

## Reglas de negocio

- **RN-020.1:** La detección de plataforma se hace en tiempo de ejecución con
  `Platform.isAndroid`, `Platform.isIOS` y `kIsWeb`; nunca en tiempo de compilación
  con directivas de plataforma (`dart.library`).
- **RN-020.2:** La pantalla es puramente demostrativa; no modifica ningún dato de
  la app ni tiene efectos secundarios persistentes.
- **RN-020.3:** La tabla de permisos refleja el estado real en tiempo de ejecución
  usando `permission_handler`; no es estática.
