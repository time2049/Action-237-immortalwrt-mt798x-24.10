#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
#

# ==========================================================
# 360 T7 / ImmortalWrt 24.10 / Kernel 6.6
# ==========================================================

# ----------------------------------------------------------
# 默认 LAN IP
# ----------------------------------------------------------
sed -i 's/192.168.1.1/192.168.6.1/g' \
package/base-files/files/bin/config_generate


# ----------------------------------------------------------
# 主机名
# ----------------------------------------------------------
HOST_DATE=$(TZ="Asia/Shanghai" date +"%Y%m%d")

sed -i "s/ImmortalWrt/ImmortalWrt-24.10-6.6-${HOST_DATE}/g" \
package/base-files/files/bin/config_generate


# ----------------------------------------------------------
# 固件输出文件名
# ----------------------------------------------------------
sed -i "s|IMG_PREFIX:=|IMG_PREFIX:=${HOST_DATE}-24.10-6.6-|" \
include/image.mk


# ----------------------------------------------------------
# 自动修复 Kernel 6.6 联发科网卡驱动缺失宏定义的编译错误
# ----------------------------------------------------------
find target/linux/mediatek/ -name "mtk_eth_soc.h" -exec sed -i '/#define __MTK_ETH_SOC_H/a \
#ifndef MTK_FE_RESET_DONE\n#define MTK_FE_RESET_DONE 0x01\n#endif\n\
#ifndef MTK_WIFI_RESET_DONE\n#define MTK_WIFI_RESET_DONE 0x02\n#endif\n\
#ifndef MTK_WIFI_CHIP_ONLINE\n#define MTK_WIFI_CHIP_ONLINE 0x03\n#endif\n\
#ifndef MTK_WIFI_CHIP_OFFLINE\n#define MTK_WIFI_CHIP_OFFLINE 0x04\n#endif' {} +
