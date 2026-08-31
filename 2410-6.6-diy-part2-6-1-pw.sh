#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# 1. 修改默认 IP 为 192.168.6.1
sed -i 's/192.168.1.1/192.168.6.1/g' package/base-files/files/bin/config_generate

# 2. 修改主机名 (修复 Makefile 语法误用，改为标准 Shell 变量)
CURRENT_DATE=$(TZ="Asia/Shanghai" date +"%Y%m%d")
sed -i "s/ImmortalWrt/ImmortalWrt-24.10-6.6-${CURRENT_DATE}/g" package/base-files/files/bin/config_generate

# 3. 修改固件输出文件名，添加日期前缀
sed -i 's|IMG_PREFIX:=|IMG_PREFIX:=$(shell TZ="Asia/Shanghai" date +"%Y%m%d")-24.10-6.6-|' include/image.mk

# -------------------------------------------------------------------
# 4. 物理删除不需要的软件包目录（防止 make defconfig 自动补全依赖）
# -------------------------------------------------------------------
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/packages/net/passwall
rm -rf feeds/packages/net/sing-box
rm -rf feeds/packages/net/xray-core
rm -rf feeds/packages/net/v2ray-core
rm -rf feeds/packages/net/ddns-go
rm -rf feeds/luci/applications/luci-app-ddns-go
rm -rf feeds/luci/applications/luci-app-vlmcsd
rm -rf feeds/packages/net/vlmcsd

# -------------------------------------------------------------------
# 5. 防错修正：强行清除所有 x86/x86_64 残留并锁定 360T7 目标架构
# -------------------------------------------------------------------
if [ -f .config ]; then
    sed -i '/CONFIG_TARGET_x86/d' .config
    sed -i '/CONFIG_TARGET_x86_64/d' .config
    echo "CONFIG_TARGET_mediatek=y" >> .config
    echo "CONFIG_TARGET_mediatek_filogic=y" >> .config
    echo "CONFIG_TARGET_mediatek_filogic_DEVICE_qihoo_360t7=y" >> .config
fi
