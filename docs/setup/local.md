# Configuración local (sin Docker) — CosmosFlutter

> Útil si necesitas probar en emuladores físicos conectados por USB,
> usar el perfil de rendimiento de Android Studio, o si Docker no está disponible.

---

## Requisitos previos

| Herramienta | Versión requerida | Instalación |
|---|---|---|
| Flutter SDK | **3.29.3** exacto | [flutter.dev/docs/get-started/install](https://docs.flutter.dev/get-started/install) |
| Dart | **3.7.2** | Incluido con Flutter 3.29.3 |
| Android Studio | Flamingo o superior | [developer.android.com/studio](https://developer.android.com/studio) |
| Android SDK | API 34 (build-tools 34.0.0) | SDK Manager de Android Studio |
| Java (JDK) | 17 LTS | `sudo apt install openjdk-17-jdk` |
| Git | 2.40+ | `sudo apt install git` |
| Chrome | 100+ | Para flutter run en Web |

---

## 1. Instalar Flutter 3.29.3

```bash
# Descargar el SDK en la versión exacta
cd ~/development
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.29.3-stable.tar.xz

# Descomprimir
tar -xf flutter_linux_3.29.3-stable.tar.xz

# Agregar al PATH (añadir al final de ~/.zshrc o ~/.bashrc)
export PATH="$PATH:$HOME/development/flutter/bin"

# Recargar el shell
source ~/.zshrc
```

### Verificar instalación

```bash
flutter --version
# Flutter 3.29.3 • channel stable • ...
# Dart 3.7.2 • DevTools ...

flutter doctor
```

`flutter doctor` no debe mostrar errores críticos (✗). Los warnings de iOS
son esperados en Linux y pueden ignorarse.

---

## 2. Configurar Android SDK

```bash
# Aceptar licencias de Android SDK
flutter doctor --android-licenses
# Responder 'y' a todas las preguntas

# Verificar que el dispositivo/emulador es reconocido
flutter devices
```

Para crear un emulador desde línea de comandos:

```bash
# Listar imágenes disponibles
avdmanager list target

# Crear AVD (Pixel 6, API 34)
avdmanager create avd \
  --name "Pixel6_API34" \
  --package "system-images;android-34;google_apis;x86_64" \
  --device "pixel_6"
```

---

## 3. Clonar y preparar el proyecto

```bash
# Clonar el repositorio
git clone git@github.com:ergrato-dev/proyecto-flutter.git
cd proyecto-flutter

# Copiar variables de entorno
cp .env.example .env
# Editar .env con NASA_API_KEY, SUPABASE_URL y SUPABASE_ANON_KEY

# Instalar dependencias (sin versiones flotantes — pubspec.lock committeado)
flutter pub get

# Auditoría de CVEs (obligatoria antes de ejecutar)
dart pub audit
```

---

## 4. Ejecutar la app

```bash
# Listar dispositivos disponibles
flutter devices

# Web (Chrome)
flutter run -d chrome --dart-define-from-file=.env

# Android (dispositivo físico o emulador)
flutter run -d <device-id> --dart-define-from-file=.env

# Android — modo release
flutter build apk --release
```

---

## 5. Análisis y tests

```bash
# Análisis estático (cero errores ni warnings)
dart analyze

# Formateo (falla si hay cambios pendientes)
dart format --set-exit-if-changed lib/ test/

# Tests con cobertura
flutter test --coverage

# Ver reporte HTML de cobertura
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html   # o xdg-open en Linux
```

---

## 6. Configuración de VS Code

Extensiones recomendadas:

| Extensión | ID |
|---|---|
| Flutter | `Dart-Code.flutter` |
| Dart | `Dart-Code.dart-code` |
| GitHub Copilot | `GitHub.copilot` |

Ajustes sugeridos en `.vscode/settings.json` (no commitear si contiene rutas personales):

```json
{
  "[dart]": {
    "editor.formatOnSave": true,
    "editor.formatOnType": true,
    "editor.rulers": [80],
    "editor.selectionHighlight": false,
    "editor.suggest.snippetsPreventQuickSuggestions": false,
    "editor.suggestSelection": "first",
    "editor.tabCompletion": "onlySnippets",
    "editor.wordBasedSuggestions": "off"
  }
}
```

---

## Diferencias frente al entorno Docker

| Aspecto | Docker | Local |
|---|---|---|
| Reproducibilidad | ✅ idéntico en todos los hosts | ⚠️ depende del PATH y SDK instalado |
| Emulador físico USB | ❌ no soportado | ✅ |
| Profiler / DevTools completo | ⚠️ limitado | ✅ |
| Flutter Web hot reload | ✅ | ✅ |
| Build APK | ✅ (android SDK incluido en imagen) | ✅ |
| Tiempo de arranque (primera vez) | ~3-5 min (build imagen) | ~2-3 min (descarga pub) |
