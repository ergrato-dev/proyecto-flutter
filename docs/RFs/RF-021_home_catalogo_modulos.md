<!--
  ¿Qué? Requisito funcional que define la pantalla Home (catálogo de módulos del
  showcase) como punto de entrada principal de la app.
  ¿Para qué? Documentar cómo la pantalla raíz comunica el propósito académico de
  la app y el estado de implementación de cada módulo.
  ¿Impacto? Afecta a HU-015 y al módulo navigation/ (RF-019).
-->

# RF-021 — Catálogo de módulos del showcase (Home)

## Identificación

| Campo           | Valor                                      |
| --------------- | ------------------------------------------ |
| **ID**          | RF-021                                     |
| **Nombre**      | Catálogo de módulos del showcase (Home)    |
| **Módulo**      | `lib/modules/navigation/`                  |
| **Prioridad**   | Alta                                       |
| **Estado**      | Pendiente                                  |
| **Fecha**       | Abril 2026                                 |
| **HU asociada** | HU-015                                     |
| **RF asociado** | RF-019 (navegación)                        |

---

## Descripción

La pantalla `HomeScreen` es la raíz de la app y muestra una cuadrícula de tarjetas
con los módulos disponibles del showcase. Cada tarjeta indica el nombre del módulo,
la tecnología Flutter demostrada, el caso de uso astronómico y el estado de soporte
por plataforma (Android ✓ / Web ✓ / iOS pendiente). Al tocar una tarjeta, se navega
al módulo correspondiente.

---

## Parámetros de entrada

| Parámetro | Tipo Dart | Obligatorio | Validaciones / Notas                         |
| --------- | --------- | ----------- | -------------------------------------------- |
| —         | —         | —           | La lista de módulos es estática              |

---

## Flujo

1. Al iniciar la app, `go_router` resuelve la ruta inicial `/`.
2. `HomeScreen` muestra la cabecera: nombre "CosmosFlutter" + tagline
   "Showcase de Flutter con temática astronómica".
3. Un `SliverGrid` de 2 columnas renderiza una `ModuleCard` por cada módulo.
4. Cada `ModuleCard` contiene:
   - Icono representativo del caso de uso.
   - Nombre del módulo (ej. "Órbitas Animadas").
   - Tag de tecnología Flutter (ej. "AnimationController + CustomPainter").
   - Indicadores de plataforma: ✓ Android, ✓ Web, ⏳ iOS.
5. Al pulsar una tarjeta: `context.push` navega a la ruta del módulo.
6. Un `SearchBar` en el `AppBar` filtra los módulos por nombre o tecnología.
7. El `FloatingActionButton` "?" abre un `BottomSheet` con instrucciones de uso
   del showcase.

---

## Estados y salidas

| Estado    | Condición                    | Widget mostrado                                           |
| --------- | ---------------------------- | --------------------------------------------------------- |
| `data`    | Siempre (lista estática)     | `SliverGrid` con todas las `ModuleCard`                   |
| `filtered`| Búsqueda activa con texto    | `SliverGrid` filtrado; si vacío → "Sin resultados para X" |

---

## Widgets / Providers asociados

| Nombre                  | Tipo                    | Descripción                                               |
| ----------------------- | ----------------------- | --------------------------------------------------------- |
| `HomeScreen`            | `ConsumerWidget`        | Pantalla raíz con el catálogo de módulos                  |
| `ModuleCard`            | `StatelessWidget`       | Tarjeta de módulo con icono, nombre y badges              |
| `moduleFilterProvider`  | `StateProvider`         | String de filtro del `SearchBar`                          |
| `filteredModulesProvider` | `Provider`            | Lista filtrada de módulos según el filtro activo          |

---

## Reglas de negocio

- **RN-021.1:** La lista de módulos es estática y se define en
  `lib/modules/navigation/data/modules.dart`; no se obtiene de ninguna API.
- **RN-021.2:** Los indicadores de plataforma en las tarjetas son informativos y
  no deshabilitan la navegación; el módulo destino maneja su propia degradación.
- **RN-021.3:** La búsqueda es insensible a mayúsculas y acentos; "animacion" debe
  encontrar "Animaciones Orbitales".
