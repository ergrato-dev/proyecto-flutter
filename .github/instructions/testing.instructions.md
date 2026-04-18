---
applyTo: "test/**"
---

# Instructions — tests

## Framework

- **flutter_test** (nativo) + **mocktail** para mocks.
- Cobertura mínima: **80 % de líneas y ramas** por módulo.
- Ejecutar siempre antes de commit: `flutter test --coverage`.

## Convenciones de archivos

```
test/modules/<nombre>/
  <nombre>_provider_test.dart    ← providers Riverpod
  <nombre>_screen_test.dart      ← pantallas / widgets
  <nombre>_utils_test.dart       ← funciones utilitarias
test/shared/
  repositories/
    <nombre>_repository_test.dart
```

## Qué cubrir obligatoriamente

### Providers (Riverpod)

- Estado inicial (antes de resolver el Future/Stream).
- Transición `loading → data` (mock de respuesta exitosa).
- Transición `loading → error` (mock de error de red).
- Limpieza de recursos (dispose del provider).

### Widgets / pantallas

- Render mínimo sin parámetros opcionales.
- Interacción del usuario (`tap`, `enterText`, `drag`).
- Estado de error con mensaje visible en pantalla.
- Accesibilidad: al menos un `find.bySemanticsLabel` o `find.byTooltip` por elemento interactivo.

### Funciones utilitarias

- Caso normal.
- Valores límite: `0`, `null`, string vacío.
- Error esperado: verificar que se lanza con el mensaje correcto.

## Mocks estándar con mocktail

```dart
// mock de repositorio
class MockNasaRepository extends Mock implements NasaRepository {}

// mock de Supabase client
class MockSupabaseClient extends Mock implements SupabaseClient {}

// mock de sensores (sensors_plus)
class MockGyroscopeEvent extends Mock implements GyroscopeEvent {}
```

## Patrón de test de provider con ProviderContainer

```dart
test('retorna estado de carga inicial', () async {
  final container = ProviderContainer(
    overrides: [
      nasaRepositoryProvider.overrideWithValue(MockNasaRepository()),
    ],
  );
  addTearDown(container.dispose);

  final state = container.read(apodProvider);
  expect(state, const AsyncValue<Apod>.loading());
});
```

## Patrón de widget test

```dart
testWidgets('muestra indicador de carga mientras carga el APOD', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [apodProvider.overrideWith((_) => const AsyncValue.loading())],
      child: const MaterialApp(home: ApodScreen()),
    ),
  );

  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});
```

## Idioma en tests

- Descripciones de `group` y `test`/`testWidgets`: **español**.
- Variables y funciones auxiliares: **inglés**.

```dart
group('ApodProvider', () {
  test('retorna estado de carga inicial', () { ... });
  test('retorna los datos de la imagen del día', () { ... });
  test('maneja errores de red correctamente', () { ... });
});
```
