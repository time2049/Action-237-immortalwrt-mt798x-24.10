#!/bin/bash

set -e

echo "========================================"
echo "DIY Part 1: Start"
echo "========================================"

# 清理 Windows 换行
sed -i 's/\r$//' feeds.conf.default 2>/dev/null || true

# 删除空行
if [ -f feeds.conf.default ]; then
    sed -i '/^[[:space:]]*$/d' feeds.conf.default
fi

# ==========================================================
# 删除不需要的 telephony feed
# 360T7 纯净版不需要电话/VoIP软件
# ==========================================================

sed -i '/^[[:space:]]*src-git[[:space:]]\+telephony[[:space:]]/d' \
    feeds.conf.default

sed -i '/^[[:space:]]*src-git-full[[:space:]]\+telephony[[:space:]]/d' \
    feeds.conf.default

echo "========== feeds.conf.default =========="

cat feeds.conf.default

echo "========================================"
echo "DIY Part 1: Completed"
echo "========================================"
