#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# 强行去除可能存在的 Windows 回车符 (\r)
sed -i 's/\r$//' "$0" 2>/dev/null || true

set -e

echo "========================================"
echo "DIY Part 1: Start Executing"
echo "========================================"

# 清理 feeds.conf.default 多余空行
if [ -f feeds.conf.default ]; then
    sed -i '/^[[:space:]]*$/d' feeds.conf.default
fi

echo "Current feeds.conf.default content:"
if [ -f feeds.conf.default ]; then
    cat feeds.conf.default
fi

echo "========================================"
echo "DIY Part 1: Completed"
echo "========================================"
