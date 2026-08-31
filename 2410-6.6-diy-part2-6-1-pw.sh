```bash
#!/bin/bash
#
# 360 T7 / MT7981
# ImmortalWrt 24.10 / Kernel 6.6
#
# DIY script part 2
#

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
# 4. 显示当前目标
# ==========================================================

echo ""
echo "========== Target =========="

grep '^CONFIG_TARGET.*=y' .config || true

echo ""
echo "========== Device =========="

grep '^CONFIG_TARGET.*DEVICE.*=y' .config || true

echo ""
echo "========== Kernel =========="

grep '^CONFIG_LINUX_' .config || true

echo ""
echo "========================================"

# ==========================================================
# 5. MTK 驱动只检查，不修改
# ==========================================================

echo ""
echo "========== MTK Driver Check =========="

if [ -d target/linux/mediatek ]; then

    echo ""
    echo "--- MTK_WIFI_CHIP_ONLINE ---"
    grep -R -n \
        "MTK_WIFI_CHIP_ONLINE" \
        target/linux/mediatek \
        2>/dev/null || true

    echo ""
    echo "--- MTK_WIFI_CHIP_OFFLINE ---"
    grep -R -n \
        "MTK_WIFI_CHIP_OFFLINE" \
        target/linux/mediatek \
        2>/dev/null || true

    echo ""
    echo "--- MTK_WED_RESET_IDX ---"
    grep -R -n \
        "MTK_WED_RESET_IDX" \
        target/linux/mediatek \
        2>/dev/null || true

fi

echo ""
echo "MTK driver will NOT be modified."
echo "========================================"

echo ""
echo "DIY Part 2 completed."
```
