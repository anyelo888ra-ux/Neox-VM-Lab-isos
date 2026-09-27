#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="${ROOT}/build/live"
OUTPUT_DIR="${ROOT}/dist"

rm -rf "${BUILD_DIR}" "${OUTPUT_DIR}"
mkdir -p "${BUILD_DIR}" "${OUTPUT_DIR}"
cd "${BUILD_DIR}"

echo "[NEOX] Configuring live-build..."
lb config \
  --distribution bookworm \
  --architectures amd64 \
  --binary-images iso-hybrid \
  --archive-areas "main" \
  --apt-indices false \
  --apt-recommends true \
  --bootappend-live "boot=live components quiet splash" \
  --debian-installer false

cp -a "${ROOT}/config/package-lists/." config/package-lists/
cp -a "${ROOT}/config/includes.chroot/." config/includes.chroot/

echo "[NEOX] Building ISO..."
lb build

ISO="$(find "${BUILD_DIR}" -maxdepth 1 -type f -name '*.iso' -print -quit)"
if [[ -z "${ISO}" ]]; then
  echo "[NEOX] ERROR: no ISO was generated."
  exit 1
fi

VERSION="0.1.0"
OUT="${OUTPUT_DIR}/neox-v${VERSION}-amd64.iso"
cp "${ISO}" "${OUT}"
sha256sum "${OUT}" > "${OUT}.sha256"

echo "[NEOX] Generated: ${OUT}"
cat "${OUT}.sha256"
