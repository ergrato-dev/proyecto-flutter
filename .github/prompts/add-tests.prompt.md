---
mode: agent
description: Añade tests a un módulo existente hasta alcanzar cobertura ≥ 80%
---

# Añadir tests al módulo Flutter

Analiza el módulo `${input:moduleName}` en `lib/modules/${input:moduleName}/` y genera
los tests faltantes para alcanzar una cobertura ≥ 80 % de líneas y ramas.

## Proceso

1. Leer todos los archivos del módulo (providers, widgets, utils).
2. Identificar qué está cubierto y qué falta (`flutter test --coverage` + genhtml si disponible).
3. Generar los archivos de test en `test/modules/${input:moduleName}/`.

## Convenciones

- Framework: **flutter_test** (nativo) + **mocktail** para mocks.
- Mocks: usar `class MockXxx extends Mock implements Xxx {}` con mocktail.
- Nomenclatura: `<nombre>_test.dart` para todos los archivos.
- Comentarios de test en **español**.

## Qué cubrir por tipo

| Tipo         | Casos obligatorios                                                                 |
| ------------ | ---------------------------------------------------------------------------------- |
| Provider     | estado inicial, transición loading→data, transición loading→error, dispose         |
| Widget       | render con parámetros mínimos, interacción del usuario, estado de error, semántica |
| Función util | caso normal, límites (0, null, string vacío), error esperado                       |
| Integración  | flujo completo de pantalla con repositorios mockeados                              |

## Ejemplo de estructura esperada

```
test/modules/${input:moduleName}/
  ${input:moduleName}_provider_test.dart
  ${input:moduleName}_screen_test.dart
  (utils si existen)
```

## Patrón base para widget test

```dart
testWidgets('descripción del test en español', (WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        someProvider.overrideWith((_) => mockValue),
      ],
      child: const MaterialApp(home: ${input:moduleName}Screen()),
    ),
  );
  await tester.pumpAndSettle();

  expect(find.text('texto esperado'), findsOneWidget);
});
```
