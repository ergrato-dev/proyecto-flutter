---
mode: ask
description: Auditoría de dependencias antes de hacer commit (Flutter / pub)
---

# Auditoría de dependencias Flutter

Ejecuta la auditoría completa de seguridad del proyecto antes de commitear.

## Pasos

1. Verificar que no haya rangos flotantes en `pubspec.yaml`:

   ```bash
   grep -E ':\s+\^|:\s+>=|:\s+any' pubspec.yaml
   ```

   Si hay resultados → **corregir a versión exacta antes de continuar**.

2. Ejecutar auditoría CVE:

   ```bash
   dart pub audit
   ```

3. Verificar dependencias desactualizadas:

   ```bash
   flutter pub outdated
   ```

4. Interpretar resultados de `dart pub audit`:
   - **Sin vulnerabilidades** → listo para commit.
   - **Vulnerabilidad reportada** → **BLOQUEA el commit**. Opciones:
     a. Actualizar el paquete a versión parcheada: editar `pubspec.yaml` con la nueva versión exacta y ejecutar `flutter pub get`.
     b. Buscar alternativa sin CVE activo en [pub.dev](https://pub.dev).
     c. Si no hay fix disponible, abrir issue y documentar decisión.

5. Si se actualizó algún paquete, verificar que la versión en `pubspec.yaml` sea exacta (sin `^` ni `>=`).

6. Confirmar que `pubspec.lock` está commiteado (garantiza builds reproducibles).

## Criterio de paso

- ✅ `dart pub audit` sin vulnerabilidades reportadas
- ✅ `grep -E ':\s+\^' pubspec.yaml` sin resultados
- ✅ `flutter test --coverage` con cobertura ≥ 80 % por módulo
- ✅ `dart analyze` sin errores ni warnings
- ✅ `pubspec.lock` incluido en el commit
