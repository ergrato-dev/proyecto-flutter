<!--
  ¿Qué? Requisito no funcional que define los estándares de calidad, mantenibilidad
  y convenciones de código del proyecto.
  ¿Para qué? Garantizar que el código sea legible, testeable y libre de deuda técnica,
  cumpliendo los estándares académicos del showcase.
  ¿Impacto? Afecta a todo el codebase. Verificado en CI/CD antes de cada merge.
-->

# RNF-005 — Mantenibilidad y calidad de código

## Identificación

| Campo         | Valor                              |
| ------------- | ---------------------------------- |
| **ID**        | RNF-005                            |
| **Nombre**    | Mantenibilidad y calidad de código |
| **Categoría** | Maintainability                    |
| **Prioridad** | Alta                               |
| **Estado**    | Pendiente                          |

---

## Requisitos

### RNF-005.1 — Análisis estático sin errores

`dart analyze` no debe reportar errores ni warnings en ningún commit que se
incorpore a la rama principal. Se usa el conjunto de reglas del paquete
`flutter_lints` con reglas adicionales personalizadas en `analysis_options.yaml`.

**Verificación:** CI/CD ejecuta `dart analyze --fatal-infos`; falla ante cualquier
diagnóstico.

### RNF-005.2 — Cobertura de tests ≥ 80 %

Cada módulo en `lib/modules/` debe mantener una cobertura mínima del **80 %** de
líneas y ramas, verificada con `flutter test --coverage`. Los archivos de datos
estáticos y de modelos simples (solo getters) se excluyen del cálculo de cobertura.

**Verificación:** CI/CD genera el reporte lcov y falla si la cobertura total baja
del umbral. El reporte se publica como artefacto del pipeline.

### RNF-005.3 — Versiones de dependencias exactas

Todas las dependencias en `pubspec.yaml` usan versiones exactas sin `^`, `~`,
`>=`, `any` ni `latest`. El archivo `pubspec.lock` se commitea siempre para
garantizar builds reproducibles.

**Verificación:** Script pre-commit que verifica ausencia de operadores de rango
en `pubspec.yaml` con `grep -E '[\^~>]' pubspec.yaml`.

### RNF-005.4 — Documentación Dartdoc obligatoria

Todo provider público (`@riverpod`), todo widget reutilizable en `shared/widgets/`
y toda función pública en los repositories deben tener Dartdoc con el esquema
**¿Qué? → ¿Para qué? → ¿Impacto?**. Los comentarios Dartdoc se escriben en
**español**.

**Verificación:** `dart doc --validate-links`; revisión en PRs.

### RNF-005.5 — Null safety estricto

Todo el código usa Dart sound null safety. Prohibido:
- `dynamic` implícito (siempre tipar).
- `late` sin justificación documentada en un comentario.
- `!` (null assertion) sin comentario que explique por qué es seguro.
- `// ignore:` sin comentario justificativo y issue abierto.

**Verificación:** `dart analyze` + revisión de código.

### RNF-005.6 — Arquitectura de módulos

Cada módulo en `lib/modules/<nombre>/` debe ser autónomo: sus widgets, providers
y tests no importan directamente de otros módulos. Las dependencias cruzadas
pasan únicamente por `lib/shared/` (repositories, providers globales, widgets
reutilizables).

**Verificación:** `dart pub deps` + revisión de imports en PRs; ausencia de
`import '../otro_modulo/...'` en los módulos.
