#!/bin/bash
# Armbian customize-image.sh hook — 薄 wrapper
# 参数: $RELEASE $LINUXFAMILY $BOARD $BUILD_DESKTOP
PXVDI_DIR=/tmp/pxvdi
exec "$PXVDI_DIR/buildrootfs.sh" armbian "$@"
