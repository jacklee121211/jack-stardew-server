#!/bin/bash
# 更换Git远程仓库为国内镜像源

echo "正在更换Git镜像源..."

cd /jack-stardew-server

# 显示当前远程仓库
echo "当前远程仓库："
git remote -v
echo ""

# 尝试多个国内镜像源
# 方法1: hub.fastgit.xyz (推荐)
echo "尝试方法1: hub.fastgit.xyz"
git remote set-url origin https://hub.fastgit.xyz/jacklee121211/jack-stardew-server.git
if git pull origin main 2>/dev/null; then
    echo "✓ 方法1成功！"
    exit 0
fi

# 方法2: gitclone.com
echo "尝试方法2: gitclone.com"
git remote set-url origin https://gitclone.com/github.com/jacklee121211/jack-stardew-server.git
if git pull origin main 2>/dev/null; then
    echo "✓ 方法2成功！"
    exit 0
fi

# 方法3: gitee镜像（如果存在）
echo "尝试方法3: 直接使用GitHub（代理）"
git remote set-url origin https://github.com/jacklee121211/jack-stardew-server.git

# 如果本地有代理配置，尝试使用
if command -v proxychains &> /dev/null; then
    echo "使用proxychains代理..."
    proxychains git pull origin main
elif [ -n "$HTTP_PROXY" ]; then
    echo "使用环境变量代理: $HTTP_PROXY"
    git pull origin main
else
    echo "尝试直接拉取..."
    git pull origin main
fi

exit 0

