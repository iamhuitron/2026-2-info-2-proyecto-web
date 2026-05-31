#!/usr/bin/env bash
set -euo pipefail
# Decodifica img/ia-concept.b64 -> img/ia-concept.jpg
# Genera tamaños 400,800,1600 y WebP equivalentes.

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
IMG_DIR="$ROOT_DIR/img"
B64_FILE="$IMG_DIR/ia-concept.b64"
OUT_BASENAME="ia-concept"

if [ ! -f "$B64_FILE" ]; then
  echo "Error: $B64_FILE no encontrado. Asegúrate de que existe." >&2
  exit 1
fi

if ! command -v base64 >/dev/null 2>&1; then
  echo "Instala 'base64' para decodificar (coreutils)." >&2
  exit 1
fi

if ! command -v cwebp >/dev/null 2>&1; then
  echo "Instala 'cwebp' (libwebp) para generar WebP." >&2
  exit 1
fi

if ! command -v convert >/dev/null 2>&1; then
  echo "Instala 'convert' (ImageMagick) para redimensionar imágenes." >&2
  exit 1
fi

mkdir -p "$IMG_DIR"

echo "Decodificando $B64_FILE -> $IMG_DIR/$OUT_BASENAME.jpg"
base64 --decode "$B64_FILE" > "$IMG_DIR/$OUT_BASENAME.jpg"

for w in 400 800 1600; do
  echo "Creando ${OUT_BASENAME}-${w}.jpg"
  convert "$IMG_DIR/$OUT_BASENAME.jpg" -resize ${w} "$IMG_DIR/$OUT_BASENAME-${w}.jpg"
  echo "Creando ${OUT_BASENAME}-${w}.webp"
  cwebp -q 80 "$IMG_DIR/$OUT_BASENAME-${w}.jpg" -o "$IMG_DIR/$OUT_BASENAME-${w}.webp"
done

echo "Generación completada. Archivos en: $IMG_DIR"

# Sugerencia: luego actualizar el cache-busting si usas un build pipeline.
