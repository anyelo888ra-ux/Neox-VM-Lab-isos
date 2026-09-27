#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "\${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="\${ROOT}/build/live"
OUTPUT_DIR="\${ROOT}/dist"

rm -rf "\${BUILD_DIR}" "\${OUTPUT_DIR}"
mkdir -p "\${BUILD_DIR}" "\${OUTPUT_DIR}"
cd "\${BUILD_DIR}"

DEBIAN_MIRROR="https://deb.debian.org/debian/"
DEBIAN_SECURITY_MIRROR="https://security.debian.org/debian-security/"

echo "[NEOX] Configuring live-build in Debian mode..."
lb config \\
  --mode debian \\
  --distribution bookworm \\
  --architectures amd64 \\
  --binary-images iso-hybrid \\
  --archive-areas "main" \\
  --mirror-bootstrap "\${DEBIAN_MIRROR}" \\
  --mirror-binary "\${DEBIAN_MIRROR}" \\
  --mirror-binary-security "\${DEBIAN_SECURITY_MIRROR}" \\
  --mirror-chroot "\${DEBIAN_MIRROR}" \\
  --mirror-chroot-security "\${DEBIAN_SECURITY_MIRROR}" \\
  --mirror-debian-installer "\${DEBIAN_MIRROR}" \\
  --parent-mirror-bootstrap "\${DEBIAN_MIRROR}" \\
  --parent-mirror-binary "\${DEBIAN_MIRROR}" \\
  --parent-mirror-binary-security "\${DEBIAN_SECURITY_MIRROR}" \\
  --parent-mirror-chroot "\${DEBIAN_MIRROR}" \\
  --parent-mirror-chroot-security "\${DEBIAN_SECURITY_MIRROR}" \\
  --parent-mirror-debian-installer "\${DEBIAN_MIRROR}" \\
  --security false \\
  --apt-indices false \\
  --apt-recommends true \\
  --bootappend-live "boot=live components quiet splash" \\
  --debian-installer false

echo "[NEOX] Checking generated repository configuration..."
if grep -RqsE 'archive\\.ubuntu\\.com|security\\.ubuntu\\.com' config; then
  echo "[NEOX] ERROR: Ubuntu repository detected in live-build configuration."
  grep -RInE 'archive\\.ubuntu\\.com|security\\.ubuntu\\.com' config || true
  exit 1
fi

mkdir -p config/archives
cp -a "\${ROOT}/config/archives/." config/archives/
cp -a "\${ROOT}/config/package-lists/." config/package-lists/
cp -a "\${ROOT}/config/includes.chroot/." config/includes.chroot/
chmod +x config/includes.chroot/usr/local/bin/neox

echo "[NEOX] Building ISO..."
lb build

ISO="$(find "\${BUILD_DIR}" -maxdepth 1 -type f -name '*.iso' -print -quit)"
if [[ -z "\${ISO}" ]]; then
  echo "[NEOX] ERROR: no ISO was generated."
  exit 1
fi

VERSION="0.1.0"
OUT="\${OUTPUT_DIR}/neox-v\${VERSION}-amd64.iso"
cp "\${ISO}" "\${OUT}"
sha256sum "\${OUT}" > "\${OUT}.sha256"

echo "[NEOX] Generated: \${OUT}"
cat "\${OUT}.sha256"
