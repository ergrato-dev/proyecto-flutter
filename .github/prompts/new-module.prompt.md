---
mode: agent
description: Andamiaje completo para un nuevo módulo del showcase astronómico en Flutter
---

# Crear nuevo módulo Flutter

Genera el andamiaje completo para el módulo `${input:moduleName}` del showcase de astronomía en Flutter.

## Estructura requerida

```
lib/modules/${input:moduleName}/
  ${input:moduleName}_module.dart       ← barrel export + comentario de módulo (@what/@why/@impact)
  screens/
    ${input:moduleName}_screen.dart     ← pantalla principal
  widgets/                              ← widgets locales del módulo
  providers/
    ${input:moduleName}_provider.dart   ← Riverpod provider
test/modules/${input:moduleName}/
  ${input:moduleName}_screen_test.dart
  ${input:moduleName}_provider_test.dart
```

## Reglas obligatorias

1. **Comentario de módulo** en `${input:moduleName}_module.dart`:

   ```dart
   /// @what  descripción de qué demuestra el módulo
   /// @why   por qué se eligió esta librería/enfoque
   /// @impact dependencias cruzadas y permisos requeridos
   ```

2. **Documentación dartdoc** en cada función, provider y widget con `@what`, `@why`, `@impact`.

3. **Idioma**: nomenclatura técnica en inglés, comentarios en español.

4. **Dart sound null safety**: sin `late` innecesario, sin `!` sin justificación, sin `dynamic`.

5. **Test mínimo** que cubra:
   - render correcto del widget principal
   - estado de carga (loading state)
   - estado de error (error state)
   - accesibilidad básica con `find.bySemanticsLabel`

6. **Compatibilidad de plataformas**: verificar con `Platform.isAndroid`, `Platform.isIOS` o `kIsWeb`
   antes de usar APIs nativas.

7. **Dependencias**: si el módulo requiere un paquete nuevo, indicarlo con versión exacta
   (consultar [pub.dev](https://pub.dev)) y ejecutar `dart pub audit` tras agregarlo.

## Contexto astronómico

Caso de uso del módulo: ${input:astronomicalUseCase}

API a consumir (si aplica): ${input:apiEndpoint}
