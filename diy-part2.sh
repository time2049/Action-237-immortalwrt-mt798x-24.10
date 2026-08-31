#!/bin/bash
#
# 360 T7 / MT7981
# ImmortalWrt 24.10 / Kernel 6.6
#
# DIY script part 2
#

# 强行去除 Windows 换行符 (\r)，防止 CRLF 导致报错
sed -i 's/\r$//' "$0" 2>/dev/null || true

set -e

echo "========================================"
echo "DIY Part 2 - 360T7"
echo "========================================"

# ==========================================================
# 1. 默认 LAN IP
# ==========================================================

CONFIG_GENERATE="package/base-files/files/bin/config_generate"

if [ -f "$CONFIG_GENERATE" ]; then
    sed -i 's/192\.168\.1\.1/192.168.6.1/g' "$CONFIG_GENERATE"
fi

# ==========================================================
# 2. 默认主机名
# ==========================================================

CURRENT_DATE=$(TZ="Asia/Shanghai" date +"%Y%m%d")

if [ -f "$CONFIG_GENERATE" ]; then
    sed -i \
        "s/ImmortalWrt/ImmortalWrt-24.10-6.6-${CURRENT_DATE}/g" \
        "$CONFIG_GENERATE"
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
# 4. 显示当前目标 (若 .config 尚未生成则跳过，不阻断流程)
# ==========================================================

echo ""
echo "========== Target =========="

if [ -f .config ]; then
    grep '^CONFIG_TARGET.*=y' .config || true
    echo ""
    echo "========== Device =========="
    grep '^CONFIG_TARGET.*DEVICE.*=y' .config || true
    echo ""
    echo "========== Kernel =========="
    grep '^CONFIG_LINUX_' .config || true
else
    echo ".config file not generated yet, skipping config debug output."
fi

echo ""
echo "========================================"

# ==========================================================
# 5. MTK 驱动检查与内核未定义常量注入 (修复 Linux 6.6 编译挂掉)
# ==========================================================

echo ""
echo "========== MTK Driver Patch & Check =========="

if [ -d target/linux/mediatek ]; then

    # 1. 安全注入宏定义（置顶注入，不改变原文件结构）
    find target/linux/mediatek/ -type f \( -name "mtk_eth_soc.h" -o -name "mtk_eth_soc.c" \) | while read -r file; do
        if ! grep -q "MTK_WIFI_CHIP_ONLINE" "$file"; then
            sed -i '1i#ifndef MTK_WIFI_CHIP_ONLINE\n#define MTK_WIFI_CHIP_ONLINE 1\n#endif\n#ifndef MTK_WIFI_CHIP_OFFLINE\n#define MTK_WIFI_CHIP_OFFLINE 0\n#endif' "$file"
            echo "Patched: $file"
        fi
    done

    # 2. 检查注入后的状态
    echo ""
    echo "--- MTK_WIFI_CHIP_ONLINE ---"
    grep -R -n "MTK_WIFI_CHIP_ONLINE" target/linux/mediatek 2>/dev/null || true

    echo ""
    echo "--- MTK_WIFI_CHIP_OFFLINE ---"
    grep -R -n "MTK_WIFI_CHIP_OFFLINE" target/linux/mediatek 2>/dev/null || true

    echo ""
    echo "--- MTK_WED_RESET_IDX ---"
    grep -R -n "MTK_WED_RESET_IDX" target/linux/mediatek 2>/dev/null || true

fi

echo ""
echo "MTK driver patch process completed."
echo "========================================"

echo ""
echo "DIY Part 2 completed."
