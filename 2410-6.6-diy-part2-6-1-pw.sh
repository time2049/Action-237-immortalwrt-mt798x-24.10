```bash
#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# 360T7 / MT7981
# ImmortalWrt 24.10 / Kernel 6.6
#

set -e

echo "========================================"
echo "DIY Part 2 - 360T7"
echo "========================================"

# ==========================================================
# 1. 修改默认 LAN IP
# ==========================================================

if [ -f package/base-files/files/bin/config_generate ]; then
    sed -i 's/192\.168\.1\.1/192.168.6.1/g' \
        package/base-files/files/bin/config_generate
fi

# ==========================================================
# 2. 修改默认主机名
# ==========================================================

CURRENT_DATE=$(TZ="Asia/Shanghai" date +"%Y%m%d")

if [ -f package/base-files/files/bin/config_generate ]; then
    sed -i \
        "s/ImmortalWrt/ImmortalWrt-24.10-6.6-${CURRENT_DATE}/g" \
        package/base-files/files/bin/config_generate
fi

# ==========================================================
# 3. 修改固件文件名前缀
# ==========================================================

if [ -f include/image.mk ]; then
    sed -i \
        's|IMG_PREFIX:=|IMG_PREFIX:=$(shell TZ="Asia/Shanghai" date +"%Y%m%d")-24.10-6.6-|' \
        include/image.mk
fi

# ==========================================================
# 4. 删除不需要的软件包
#
# 注意：
# 这里不修改任何 MTK / WiFi / WED / Ethernet 驱动。
# ==========================================================

REMOVE_LIST="
feeds/luci/applications/luci-app-passwall
feeds/packages/net/passwall

feeds/packages/net/sing-box

feeds/packages/net/xray-core

feeds/packages/net/v2ray-core

feeds/packages/net/ddns-go
feeds/luci/applications/luci-app-ddns-go

feeds/luci/applications/luci-app-vlmcsd
feeds/packages/net/vlmcsd
"

for path in $REMOVE_LIST; do
    if [ -e "$path" ]; then
        echo "删除：$path"
        rm -rf "$path"
    fi
done

# ==========================================================
# 5. 清理可能残留的 package/feeds 软链接
#
# 防止删除 feeds 目录后 package/feeds 中仍然存在链接。
# ==========================================================

for pkg in \
    luci-app-passwall \
    passwall \
    sing-box \
    xray-core \
    v2ray-core \
    ddns-go \
    luci-app-ddns-go \
    luci-app-vlmcsd \
    vlmcsd
do
    find package/feeds -maxdepth 3 \
        \( -name "$pkg" -o -name "$pkg" \) \
        -type l \
        -delete 2>/dev/null || true
done

# ==========================================================
# 6. 显示目标配置
# ==========================================================

echo ""
echo "========== 当前目标配置 =========="

grep '^CONFIG_TARGET.*=y' .config || true

echo ""
echo "========== 当前设备配置 =========="

grep '^CONFIG_TARGET.*DEVICE.*=y' .config || true

echo ""
echo "========================================"

# ==========================================================
# 7. 检查 MTK 源码
#
# 这里只检查，不修改。
# ==========================================================

echo ""
echo "========== MTK 驱动检查 =========="

if [ -d target/linux/mediatek ]; then

    echo "--- mtk_eth_soc.c ---"

    find target/linux/mediatek \
        -name "mtk_eth_soc.c" \
        -print

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
echo "========================================"

# ==========================================================
# 8. 明确禁止修改 MTK 驱动
# ==========================================================

echo ""
echo "MTK driver patch: DISABLED"
echo "Do NOT inject MTK_WIFI_CHIP_ONLINE/OFFLINE"
echo "Do NOT modify mtk_eth_soc.c"
echo ""

echo "DIY Part 2 完成"
echo "========================================"
```
