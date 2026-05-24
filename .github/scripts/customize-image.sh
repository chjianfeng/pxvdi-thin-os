#!/bin/bash
# Armbian customize-image.sh hook — 薄 wrapper
# 参数: $RELEASE $LINUXFAMILY $BOARD $BUILD_DESKTOP $ARCH
# Armbian 把 userpatches/overlay/ bind-mount 到 chroot 的 /tmp/overlay/
set -e

PXVDI_DIR=/tmp/overlay

if [[ ! -x "$PXVDI_DIR/buildrootfs.sh" ]]; then
    echo "ERROR: $PXVDI_DIR/buildrootfs.sh not found!"
    echo "  Contents of /tmp/overlay/: $(ls /tmp/overlay/ 2>/dev/null)"
    exit 1
fi

exec "$PXVDI_DIR/buildrootfs.sh" armbian "$@"
