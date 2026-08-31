```bash
#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

set -e

echo "========================================"
echo "DIY Part 1"
echo "========================================"

# 清理 feeds.conf.default 多余空行
if [ -f feeds.conf.default ]; then
    sed -i '/^[[:space:]]*$/d' feeds.conf.default
fi

echo "feeds.conf.default:"
cat feeds.conf.default

echo "========================================"
```
