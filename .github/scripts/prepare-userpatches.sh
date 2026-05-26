#!/bin/bash
# 用法: ./prepare-userpatches.sh <armbian-build-dir>
# 把 pxvdi-thin-os 项目文件组装成 Armbian userpatches 结构
set -e

ARMBIAN_DIR="$1"
REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

USERPATCHES="$ARMBIAN_DIR/userpatches"
OVERLAY="$USERPATCHES/overlay"

mkdir -p "$OVERLAY"

# customize-image.sh wrapper → userpatches/
cp "$SCRIPT_DIR/customize-image.sh" "$USERPATCHES/"
chmod +x "$USERPATCHES/customize-image.sh"

# Armbian 把 userpatches/overlay/ bind-mount 到 chroot 的 /tmp/overlay/
# 所以这里的文件在 chroot 里通过 /tmp/overlay/ 访问
cp "$REPO_ROOT/buildrootfs.sh" "$OVERLAY/"
chmod +x "$OVERLAY/buildrootfs.sh"
cp "$REPO_ROOT/bizhi.jpg" "$OVERLAY/" 2>/dev/null || true
cp "$REPO_ROOT/rc.xml" "$OVERLAY/" 2>/dev/null || true
cp -r "$REPO_ROOT/config" "$OVERLAY/"
cp -r "$REPO_ROOT/loonggpu" "$OVERLAY/" 2>/dev/null || true
mkdir -p "$OVERLAY/.github/scripts"
cp "$SCRIPT_DIR/armbian-mali.json" "$OVERLAY/.github/scripts/"

echo "[prepare-userpatches] done → $USERPATCHES"
