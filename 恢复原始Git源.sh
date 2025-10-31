#!/bin/bash
# 恢复Git原始GitHub源

cd /jack-stardew-server

echo "恢复为原始GitHub源..."

git remote set-url origin https://github.com/jacklee121211/jack-stardew-server.git

echo "✓ 已恢复"
echo ""
echo "当前远程仓库："
git remote -v
echo ""
echo "拉取最新代码..."
git pull origin main

