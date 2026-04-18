<!--
  ¿Qué? Requisito no funcional que define los estándares de usabilidad y
  accesibilidad de la app.
  ¿Para qué? Garantizar que la app sea usable por la mayor cantidad de personas,
  incluyendo usuarios con discapacidades visuales o motoras.
  ¿Impacto? Afecta a todos los widgets de presentación; especialmente a listas,
  formularios y pantallas de detalle.
-->

# RNF-004 — Usabilidad y accesibilidad

## Identificación

| Campo         | Valor                           |
| ------------- | ------------------------------- |
| **ID**        | RNF-004                         |
| **Nombre**    | Usabilidad y accesibilidad      |
| **Categoría** | Usability / Accessibility       |
| **Prioridad** | Media                           |
| **Estado**    | Pendiente                       |

---

## Requisitos

### RNF-004.1 — Contraste de color WCAG AA

Todos los textos sobre fondos coloreados deben cumplir el ratio de contraste
mínimo de **4.5:1** para texto normal y **3:1** para texto grande (≥ 18 pt bold
o ≥ 24 pt regular), según WCAG 2.1 nivel AA. El tema oscuro también debe cumplir
estos ratios.

**Verificación:** `flutter test` con plugin `accessibility_tools` + revisión manual
con el Color Contrast Analyzer.

### RNF-004.2 — Tamaños mínimos de área táctil

Todos los botones, chips, ítems de lista y controles interactivos deben tener un
área mínima de **44 × 44 dp** para garantizar facilidad de uso en pantallas táctiles,
según Material Design y las Human Interface Guidelines de Apple.

**Verificación:** Test de widget verificando `SizeOf(widget) >= Size(44, 44)` para
todos los widgets interactivos.

### RNF-004.3 — Soporte de lectores de pantalla (TalkBack / VoiceOver)

Todos los widgets interactivos y de contenido deben tener etiquetas semánticas
con `Semantics(label: ...)` en español. Los iconos sin texto adyacente deben
tener `semanticLabel`. Las listas deben declarar `SemanticsProperties.liveRegion`
cuando se actualizan dinámicamente.

**Verificación:** Tests con `find.bySemanticsLabel('...')` + prueba manual en
Android con TalkBack activo.

### RNF-004.4 — Soporte de tema claro y oscuro

La app implementa `ThemeData` claro y oscuro en `lib/shared/theme/`. Respeta
la preferencia del sistema (`Brightness.dark` / `Brightness.light`). El usuario
puede forzar el tema desde los ajustes de la app. El modo noche del Star Map
(RF-012) es independiente del tema global.

**Verificación:** Test de widget con `MediaQuery` de brightness oscura verificando
que los colores del tema oscuro se aplican.

### RNF-004.5 — Texto redimensionable

La app respeta el `textScaleFactor` del sistema (tamaño de texto del usuario).
Los textos no se truncan ni se solapan cuando el `textScaleFactor` es 1.3 (accesibilidad
grande). Se usan `FittedBox` o `maxLines + overflow: TextOverflow.ellipsis`
donde el espacio es limitado.

**Verificación:** Test de widget con `MediaQuery(data: data.copyWith(textScaleFactor: 1.3))`.

### RNF-004.6 — Mensajes de error en español

Todos los mensajes visibles al usuario (errores de formulario, errores de red,
estados vacíos) están en español, son concisos y accionables. No se exponen
códigos internos de error ni stack traces al usuario.

**Verificación:** Revisión de código; búsqueda de strings en inglés en los widgets
de error.
