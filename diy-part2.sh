#!/bin/bash
#
# 360 T7 ImmortalWrt 24.10 / Kernel 6.6
# DIY Part 2
#

set -e

echo "========================================"
echo "DIY Part 2: Start"
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
# 4. 删除不需要的软件包源码
# ==========================================================

echo "========== 删除不需要的软件包 =========="

# PassWall
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/luci/applications/luci-app-passwall2
rm -rf feeds/packages/net/passwall

# 代理核心
rm -rf feeds/packages/net/sing-box
rm -rf feeds/packages/net/xray-core
rm -rf feeds/packages/net/v2ray-core

# DDNS-Go
rm -rf feeds/packages/net/ddns-go
rm -rf feeds/luci/applications/luci-app-ddns-go

# VLMCSd
rm -rf feeds/packages/net/vlmcsd
rm -rf feeds/luci/applications/luci-app-vlmcsd

echo "========================================"
echo "DIY Part 2: Completed"
echo "========================================"
