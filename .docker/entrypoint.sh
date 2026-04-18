#!/bin/bash
# ─── Entrypoint del contenedor de desarrollo CosmosFlutter ────────────────────
# Ejecuta flutter pub get y dart pub audit antes de iniciar cualquier comando.
# Si hay CVEs moderados o superiores, el contenedor no arranca.
set -e

# ─── Instalar/sincronizar dependencias ─────────────────────────────────────────
echo "→ flutter pub get"
flutter pub get

# ─── Auditoría de CVEs (bloquea si hay vulnerabilidades moderadas o superiores) ─
echo "→ dart pub audit"
if ! dart pub audit; then
  echo ""
  echo "✗ dart pub audit falló — hay CVEs reportados en las dependencias."
  echo "  Resuelve los problemas en pubspec.yaml antes de continuar."
  exit 1
fi

echo "→ Entorno listo"
echo ""

# ─── Ejecutar el comando pasado al contenedor (CMD o docker run <comando>) ──────
exec "$@"
