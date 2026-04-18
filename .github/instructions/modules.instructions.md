---
applyTo: "lib/modules/**"
---

# Instructions — módulos del showcase

Cada módulo en `lib/modules/<nombre>/` demuestra una capacidad específica de Flutter
usando el cosmos como hilo narrativo.

## Estructura obligatoria por módulo

```
lib/modules/<nombre>/
  <nombre>_module.dart     ← barrel export con comentario @what/@why/@impact
  screens/                 ← una o más pantallas del módulo
  widgets/                 ← widgets privados del módulo
  providers/               ← providers Riverpod del módulo
test/modules/<nombre>/
  <nombre>_screen_test.dart
  <nombre>_provider_test.dart
```

## Documentación dartdoc — obligatoria

Cada función, provider y widget debe incluir:

```dart
/// @what  qué hace exactamente este elemento
/// @why   por qué existe en el contexto del módulo/app
/// @impact qué se rompe o cambia si se modifica
```

## Reglas de estilo

- Nomenclatura técnica en **inglés** (variables, funciones, clases, archivos).
- Comentarios en código en **español**.
- Sin `dynamic` implícito ni `// ignore:` sin justificación e issue asociado.
- Parámetros de widgets siempre tipados; sin `late` innecesario; sin `!` sin justificación.

## APIs astronómicas disponibles

Usar siempre el repositorio centralizado de `lib/shared/repositories/`:

```dart
// correcto — usar el repositorio configurado con la API key
final repo = ref.watch(nasaRepositoryProvider);
final solarRepo = ref.watch(solarSystemRepositoryProvider);

// incorrecto — HTTP directo sin repositorio
final response = await http.get(Uri.parse('https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY'));
```

## Compatibilidad de plataformas

Antes de usar cualquier API nativa, verificar disponibilidad:

```dart
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

if (!kIsWeb && Platform.isAndroid) {
  // lógica específica de Android
}
```

Para diferencias de UI entre plataformas, usar bloques condicionales en el mismo widget:

```dart
Widget buildActionButton() {
  if (Platform.isIOS) {
    return CupertinoButton(...);
  }
  return ElevatedButton(...);
}
```
