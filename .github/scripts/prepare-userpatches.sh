#!/bin/bash
# 用法: ./prepare-userpatches.sh <armbian-build-dir>
# 把 pxvdi-thin-os 项目文件组装成 Armbian userpatches 结构
set -e

ARMBIAN_DIR="$1"
REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

USERPATCHES="$ARMBIAN_DIR/userpatches"
PXVDI_OVERLAY="$USERPATCHES/overlay/tmp/pxvdi"

mkdir -p "$PXVDI_OVERLAY"

# customize-image.sh wrapper → userpatches/
cp "$SCRIPT_DIR/customize-image.sh" "$USERPATCHES/"
chmod +x "$USERPATCHES/customize-image.sh"

# Armbian 会把 userpatches/overlay/ 的内容 rsync 到 rootfs /
# 所以 overlay/tmp/pxvdi/ → chroot 内 /tmp/pxvdi/
cp "$REPO_ROOT/buildrootfs.sh" "$PXVDI_OVERLAY/"
chmod +x "$PXVDI_OVERLAY/buildrootfs.sh"
cp "$REPO_ROOT/bizhi.jpg" "$PXVDI_OVERLAY/" 2>/dev/null || true
cp "$REPO_ROOT/rc.xml" "$PXVDI_OVERLAY/" 2>/dev/null || true
cp -r "$REPO_ROOT/config" "$PXVDI_OVERLAY/"
cp -r "$REPO_ROOT/loonggpu" "$PXVDI_OVERLAY/" 2>/dev/null || true

echo "[prepare-userpatches] done → $USERPATCHES"
