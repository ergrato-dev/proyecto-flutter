---
mode: agent
description: Crea un repositorio + provider Riverpod que consume una API astronómica
---

# Crear repositorio y provider de API astronómica

Genera el repositorio y provider Riverpod para consumir el endpoint `${input:apiEndpoint}`.

## Parámetros

- **Nombre del repositorio**: `${input:repositoryName}` (sufijo `Repository`)
- **Nombre del provider**: `${input:providerName}` (camelCase)
- **Endpoint**: `${input:apiEndpoint}`
- **Propósito**: ${input:purpose}

## Estructura a generar

```
lib/shared/repositories/${input:repositoryName}_repository.dart
lib/modules/${input:moduleName}/providers/${input:providerName}_provider.dart
test/shared/repositories/${input:repositoryName}_repository_test.dart
test/modules/${input:moduleName}/${input:providerName}_provider_test.dart
```

## Repositorio

```dart
// lib/shared/repositories/${input:repositoryName}_repository.dart

/// Repositorio que gestiona las peticiones a ${input:apiEndpoint}.
///
/// @what Centraliza los métodos HTTP hacia la API astronómica.
/// @why Evita duplicar la lógica de URL, cabeceras y API key en cada feature.
/// @impact Todos los providers que consumen este endpoint dependen de este repositorio.
class ${input:repositoryName}Repository {
  final Dio _dio;

  const ${input:repositoryName}Repository(this._dio);

  Future<${input:returnType}> fetch${input:resourceName}(...) async { ... }
}
```

## Provider Riverpod

```dart
// lib/modules/${input:moduleName}/providers/${input:providerName}_provider.dart

/// @what  expone los datos de ${input:apiEndpoint} con gestión de estado async
/// @why   centraliza loading/error/data para todos los widgets del módulo
/// @impact pantallas y widgets que observan este provider
final ${input:providerName}Provider = FutureProvider.autoDispose<${input:returnType}>((ref) async {
  final repo = ref.watch(${input:repositoryName}RepositoryProvider);
  return repo.fetch${input:resourceName}();
});
```

## Requisitos técnicos

1. **Riverpod `FutureProvider` o `StreamProvider`** según sea dato puntual o continuo.
2. **Modelo de respuesta** definido como clase Dart con `fromJson` (sin `dynamic`).
3. **Error handling**: capturar y relanzar con mensaje legible en español.
4. **Cache duration** apropiada según la frecuencia de actualización:
   - Posición ISS → `StreamProvider` con polling cada 5 s
   - APOD → `keepAlive` con expiración de 1 h
   - Planetas / cuerpos → `keepAlive` con expiración de 24 h
5. **NASA API Key**: usar `dotenv.env['NASA_API_KEY'] ?? 'DEMO_KEY'` (nunca hardcodeada).

## Test requerido

Crear tests con:

- estado inicial (loading)
- respuesta exitosa (repositorio mockeado con mocktail)
- manejo de error de red
