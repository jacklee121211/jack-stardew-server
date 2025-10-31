#!/bin/bash
# 更换Git远程仓库为国内镜像源（阿里、清华等）

cd /jack-stardew-server

echo "==================================="
echo "更换为国内Git镜像源"
echo "==================================="
echo ""

# 显示当前远程仓库
echo "当前远程仓库："
git remote -v
echo ""

# 列出可用的国内镜像源
echo "可用的国内镜像源："
echo "1. FastGit (推荐，速度快)"
echo "2. GitClone (备用)"
echo "3. ghproxy (GitHub代理)"
echo "4. 阿里云 (如已配置)"
echo ""

# 默认使用方法1
METHOD=1
if [ -n "$1" ]; then
    METHOD=$1
fi

case $METHOD in
    1)
        echo "使用镜像源: FastGit"
        git remote set-url origin https://hub.fastgit.xyz/jacklee121211/jack-stardew-server.git
        ;;
    2)
        echo "使用镜像源: GitClone"
        git remote set-url origin https://gitclone.com/github.com/jacklee121211/jack-stardew-server.git
        ;;
    3)
        echo "使用镜像源: GitHub Proxy"
        git remote set-url origin https://ghproxy.com/github.com/jacklee121211/jack-stardew-server.git
        ;;
    4)
        echo "使用镜像源: 直接GitHub（如有代理）"
        git remote set-url origin https://github.com/jacklee121211/jack-stardew-server.git
        ;;
    *)
        echo "未知选项，使用方法1"
        git remote set-url origin https://hub.fastgit.xyz/jacklee121211/jack-stardew-server.git
        ;;
esac

echo ""
echo "✓ 已更换镜像源"
echo ""

# 拉取代码
echo "拉取最新代码..."
if git pull origin main; then
    echo ""
    echo "==================================="
    echo "✓ 拉取成功！"
    echo "==================================="
    echo ""
    echo "如需重启容器应用更改："
    echo "  docker compose restart stardew-server"
else
    echo ""
    echo "==================================="
    echo "✗ 当前镜像源拉取失败"
    echo "==================================="
    echo ""
    echo "请尝试其他镜像源："
    echo "  bash $0 2  # 尝试GitClone"
    echo "  bash $0 3  # 尝试GitHub Proxy"
fi

