# Configuración con Docker — CosmosFlutter

> Método recomendado para el equipo. Garantiza que todos usan exactamente
> Flutter 3.29.3 / Dart 3.7.2, independientemente del sistema operativo del host.

---

## Requisitos previos

| Herramienta | Versión mínima | Verificación |
|---|---|---|
| Docker Engine | 26.x | `docker --version` |
| Docker Compose | v2.x (plugin) | `docker compose version` |
| Git | 2.40+ | `git --version` |

---

## Estructura Docker del proyecto

```
proyecto-flutter/
├── .docker/
│   ├── Dockerfile          ← imagen de desarrollo Flutter
│   └── entrypoint.sh       ← pre-start: flutter pub get + dart pub audit
├── docker-compose.yml      ← servicio principal + servicio test
├── .env                    ← variables locales (NO en git)
└── .env.example            ← plantilla de variables
```

---

## Dockerfile — `.docker/Dockerfile`

> **Nota de implementación:** en la imagen `ghcr.io/cirruslabs/flutter` el SDK
> está en `/sdks/flutter` (no en `/opt/flutter`). El `flutter precache` debe
> correr como root **antes** de crear el usuario no-root para evitar un
> `chown -R` de ~1.3 GB que tarda varios minutos sin beneficio real. Solo se
> necesita `chmod a+rw` en `bin/cache` para que el usuario no-root pueda
> escribir los lockfiles y version stamps del CLI.

```dockerfile
# ─── Imagen base oficial de Flutter SDK ────────────────────────────────────────
# cirruslabs/flutter incluye Dart 3.7.2, pub y herramientas de análisis.
# Flutter está instalado en /sdks/flutter dentro de esta imagen.
FROM ghcr.io/cirruslabs/flutter:3.29.3

# ─── Pre-caché del SDK (corre como root) ───────────────────────────────────────
# Se ejecuta ANTES de crear el usuario no-root para evitar chown -R del SDK.
# bin/cache necesita escritura para lockfiles y version stamps del CLI.
RUN flutter precache --android --web \
  --no-ios --no-macos --no-windows --no-linux --no-fuchsia \
  && chmod -R a+rw /sdks/flutter/bin/cache

# ─── Usuario no-root para reducir superficie de ataque ─────────────────────────
# Solo chown del HOME del usuario — NO del SDK completo.
RUN useradd -m -s /bin/bash flutterdev \
  && mkdir -p /home/flutterdev/.pub-cache \
  && chown -R flutterdev:flutterdev /home/flutterdev

# ─── Directorio de trabajo ──────────────────────────────────────────────────────
WORKDIR /app

# ─── Script de entrada ──────────────────────────────────────────────────────────
COPY .docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER flutterdev

ENTRYPOINT ["/entrypoint.sh"]
CMD ["flutter", "run", "-d", "web-server", "--web-port", "8080", "--web-hostname", "0.0.0.0"]
```

---

## Entrypoint — `.docker/entrypoint.sh`

```bash
#!/bin/bash
set -e

# ─── Instalar dependencias si pubspec.lock no coincide con el contenedor ────────
echo "→ flutter pub get"
flutter pub get

# ─── Auditoría de CVEs antes de servir ──────────────────────────────────────────
echo "→ dart pub audit"
dart pub audit

# ─── Ejecutar el comando pasado al contenedor ────────────────────────────────────
exec "$@"
```

---

## docker-compose.yml

```yaml
# ─── Servicios de desarrollo CosmosFlutter ─────────────────────────────────────
services:

  # ── Servidor de desarrollo Flutter Web ────────────────────────────────────────
  flutter_dev:
    build:
      context: .
      dockerfile: .docker/Dockerfile
    image: cosmos-flutter:dev
    container_name: cosmos_flutter_dev
    working_dir: /app
    volumes:
      # Código fuente — hot reload funciona porque el fichero es observado desde el host
      - .:/app
      # Caché de pub aislada del host para reproducibilidad
      - flutter_pub_cache:/home/flutterdev/.pub-cache
    ports:
      # Flutter Web: accesible en http://localhost:8080
      - "8080:8080"
    env_file:
      - .env
    command: >
      flutter run -d web-server
        --web-port 8080
        --web-hostname 0.0.0.0
        --dart-define-from-file=.env

  # ── Ejecución de tests con cobertura ──────────────────────────────────────────
  flutter_test:
    image: cosmos-flutter:dev
    container_name: cosmos_flutter_test
    working_dir: /app
    volumes:
      - .:/app
      - flutter_pub_cache:/home/flutterdev/.pub-cache
    env_file:
      - .env
    command: flutter test --coverage
    profiles:
      - test

volumes:
  flutter_pub_cache:
```

---

## Flujo de trabajo diario

### 1. Primera vez (o tras cambiar pubspec.yaml)

```bash
# Construir imagen y resolver dependencias
docker compose build

# Levantar el servidor de desarrollo Web
docker compose up flutter_dev
```

La app queda disponible en **http://localhost:8080**. El hot reload funciona
guardando cualquier archivo Dart — Flutter detecta los cambios a través del
volumen montado.

### 2. Días normales

```bash
docker compose up flutter_dev          # levanta y conecta a los logs
# Ctrl+C para detener (no elimina el contenedor)
```

### 3. Ejecutar tests

```bash
# Tests con cobertura (perfil "test")
docker compose run --rm --profile test flutter_test

# Ver reporte de cobertura en el host
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### 4. Comandos útiles dentro del contenedor

```bash
# Acceder a una shell interactiva en el contenedor dev
docker compose exec flutter_dev bash

# Dentro del contenedor:
flutter analyze                        # análisis estático
dart format --set-exit-if-changed lib/ test/   # formateo
dart pub audit                         # auditoría CVE
flutter build apk --release            # APK de Android (requiere Android SDK)
flutter build web --release            # bundle Web de producción
```

### 5. Limpiar entorno

```bash
# Detener y eliminar contenedores (preserva el volumen pub_cache)
docker compose down

# Eliminar también el volumen de caché (force clean)
docker compose down -v
```

---

## Construir el APK de Android desde Docker

El contenedor incluye el SDK de Android (vía la imagen cirrusci/flutter).
Para firmar el APK de release necesitas pasar el keystore:

```bash
docker compose run --rm \
  -v "$HOME/.android/keystore.jks:/keystore.jks:ro" \
  -e KEY_ALIAS=cosmosflutter \
  -e KEY_STORE_PASSWORD=*** \
  -e KEY_PASSWORD=*** \
  flutter_dev \
  flutter build apk --release
```

El APK generado queda en `build/app/outputs/flutter-apk/app-release.apk` del host
gracias al volumen montado.

---

## Notas de seguridad

- **Nunca** pasar la clave NASA ni las credenciales Supabase como `ARG` en el Dockerfile
  (quedarían en el historial de capas). Usar siempre `--env-file` o `env_file:` en Compose.
- El volumen `flutter_pub_cache` es local y no se sube al registry; no contiene secretos.
- `dart pub audit` en el entrypoint bloquea el arranque si hay CVEs moderados o superiores.
