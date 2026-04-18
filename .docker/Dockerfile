# ─── Imagen base Flutter SDK 3.29.3 / Dart 3.7.2 ──────────────────────────────
# cirruslabs es la imagen oficial usada por el CI de Flutter.
# Incluye Android SDK, herramientas de pub, dart analyze y flutter test.
FROM ghcr.io/cirruslabs/flutter:3.29.3

# ─── Pre-caché del SDK (corre como root para evitar problemas de permisos) ──────
# Ejecutar ANTES de crear el usuario no-root para que el SDK quede totalmente
# precacheado y los artefactos binarios sean accesibles en modo lectura.
# Solo plataformas Android y Web (prioridad 1 y 2 del proyecto).
# bin/cache necesita escritura para lockfiles y version stamps del CLI de Flutter.
RUN flutter precache --android --web \
  --no-ios --no-macos --no-windows --no-linux --no-fuchsia \
  && chmod -R a+rw /sdks/flutter/bin/cache

# ─── Usuario no-root para reducir superficie de ataque ─────────────────────────
# Solo chown del HOME del usuario — NO del SDK completo (evita chown -R 1.3GB).
# En la imagen cirruslabs el SDK está en /sdks/flutter.
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
