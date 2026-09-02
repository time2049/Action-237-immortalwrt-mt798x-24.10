#!/bin/bash

set -e

echo "========================================"
echo "DIY Part 2: 360T7 / MT7981"
echo "ImmortalWrt 24.10 / Kernel 6.6"
echo "========================================"

# ==========================================================
# 1. 默认 LAN IP
# ==========================================================

if [ -f package/base-files/files/bin/config_generate ]; then
    sed -i 's/192.168.1.1/192.168.6.1/g' \
        package/base-files/files/bin/config_generate
fi

# ==========================================================
# 2. 默认主机名
# ==========================================================

CURRENT_DATE=$(TZ="Asia/Shanghai" date +"%Y%m%d")

if [ -f package/base-files/files/bin/config_generate ]; then
    sed -i \
        "s/ImmortalWrt/ImmortalWrt-24.10-6.6-${CURRENT_DATE}/g" \
        package/base-files/files/bin/config_generate
fi

# ==========================================================
# 3. 固件文件名前缀
# ==========================================================

if [ -f include/image.mk ]; then
    sed -i \
        's|IMG_PREFIX:=|IMG_PREFIX:=$(shell TZ="Asia/Shanghai" date +"%Y%m%d")-24.10-6.6-|' \
        include/image.mk
fi

# ==========================================================
# 4. 不删除 feeds 软件包
#
# 纯净版由 .config 控制，不直接 rm feeds
# ==========================================================

echo "保持 feeds 完整，不删除软件包源码。"

# ==========================================================
# 5. 检查 360T7 目标
# ==========================================================

echo "========== Target =========="

grep '^CONFIG_TARGET_mediatek=y' .config || true
grep '^CONFIG_TARGET_mediatek_filogic=y' .config || true
grep '^CONFIG_TARGET_mediatek_filogic_DEVICE_qihoo_360t7=y' .config || true

# ==========================================================
# 6. MTK 6.6 兼容性检查
# ==========================================================

echo "========================================"
echo "检查 MTK 6.6 驱动符号"
echo "========================================"

grep -R -n \
    "MTK_WIFI_CHIP_ONLINE" \
    target/linux/mediatek \
    2>/dev/null || true

grep -R -n \
    "MTK_WIFI_CHIP_OFFLINE" \
    target/linux/mediatek \
    2>/dev/null || true

grep -R -n \
    "MTK_WED_RESET_IDX" \
    target/linux/mediatek \
    2>/dev/null || true

echo "========================================"
echo "DIY Part 2 完成"
echo "========================================"
