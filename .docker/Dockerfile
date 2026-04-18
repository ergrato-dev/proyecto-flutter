# ─── Imagen base Flutter SDK 3.29.3 / Dart 3.7.2 ──────────────────────────────
# cirruslabs es la imagen oficial usada por el CI de Flutter.
# Incluye Android SDK, herramientas de pub, dart analyze y flutter test.
FROM ghcr.io/cirruslabs/flutter:3.29.3

# ─── Usuario no-root para reducir superficie de ataque ─────────────────────────
# Flutter necesita $HOME escribible para el caché de pub (.pub-cache).
RUN useradd -m -s /bin/bash flutterdev \
  && mkdir -p /home/flutterdev/.pub-cache \
  && chown -R flutterdev:flutterdev /home/flutterdev \
  && chown -R flutterdev:flutterdev /opt/flutter

# ─── Pre-caché del SDK para acelerar el primer pub get ─────────────────────────
# Solo plataformas Android y Web (las prioridad 1 y 2 del proyecto).
RUN flutter precache --android --web \
  --no-ios --no-macos --no-windows --no-linux --no-fuchsia

# ─── Directorio de trabajo ──────────────────────────────────────────────────────
WORKDIR /app

# ─── Script de entrada ──────────────────────────────────────────────────────────
COPY .docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER flutterdev

ENTRYPOINT ["/entrypoint.sh"]
CMD ["flutter", "run", "-d", "web-server", "--web-port", "8080", "--web-hostname", "0.0.0.0"]
