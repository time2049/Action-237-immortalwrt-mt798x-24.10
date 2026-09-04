#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# 修改默认 IP 为 192.168.6.1
sed -i 's/192.168.1.1/192.168.6.1/g' package/base-files/files/bin/config_generate

# 修改主机名 (去除 PW 标识)
sed -i 's/ImmortalWrt/ImmortalWrt-24.10-6.6-$(shell TZ="Asia/Shanghai" date +"%Y%m%d")/g' package/base-files/files/bin/config_generate

# 修改固件输出文件名，添加日期前缀 (去除 PW 标识)
sed -i 's|IMG_PREFIX:=|IMG_PREFIX:=$(shell TZ="Asia/Shanghai" date +"%Y%m%d")-24.10-6.6-|' include/image.mk
