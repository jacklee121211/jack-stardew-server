#!/bin/bash
# 服务器端快速拉取Git代码 - 使用镜像源

cd /jack-stardew-server

echo "==================================="
echo "更换Git镜像源并拉取代码"
echo "==================================="
echo ""

# 显示当前配置
echo "当前远程仓库："
git remote -v
echo ""

# 更换为国内镜像源（推荐FastGit）
echo "更换为FastGit镜像源..."
git remote set-url origin https://hub.fastgit.xyz/jacklee121211/jack-stardew-server.git
echo "✓ 已更换为: hub.fastgit.xyz"

# 拉取代码
echo ""
echo "拉取最新代码..."
if git pull origin main; then
    echo ""
    echo "==================================="
    echo "✓ 拉取成功！"
    echo "==================================="
    
    # 如果需要重启容器
    read -p "是否立即重启容器以应用更改？(y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "重启容器..."
        docker compose restart stardew-server
        echo "查看日志..."
        docker compose logs --tail=50 stardew-server
    fi
else
    echo ""
    echo "==================================="
    echo "✗ 拉取失败"
    echo "==================================="
    echo ""
    echo "尝试备用镜像源..."
    git remote set-url origin https://gitclone.com/github.com/jacklee121211/jack-stardew-server.git
    git pull origin main
fi

