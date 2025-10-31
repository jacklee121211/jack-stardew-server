#!/bin/bash
# =============================================================================
# Jack Stardew Server - 服务器更新脚本
# Server Update Script
# =============================================================================

set -e

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

echo ""
echo "==========================================================================="
echo "  Jack Stardew Server - 更新脚本"
echo "==========================================================================="
echo ""

log_step "步骤 1: 检查 Git 状态"
if git status --porcelain | grep -q '^'; then
    log_warn "检测到本地修改，将自动保存"
    git stash save "Auto-stashed before update at $(date)"
fi

log_step "步骤 2: 拉取最新代码"
git pull origin main

log_step "步骤 3: 停止服务"
docker compose down

log_step "步骤 4: 拉取最新镜像"
log_info "从 Docker Hub 拉取最新镜像..."
docker compose pull

log_step "步骤 5: 启动服务"
docker compose up -d

log_info "等待服务启动..."
sleep 5

log_step "步骤 6: 检查服务状态"
if docker ps | grep -q puppy-stardew; then
    log_info "✅ 服务器更新成功！"
else
    log_warn "⚠️  服务器可能未正常启动，请检查日志"
fi

echo ""
echo "==========================================================================="
echo "  更新完成！"
echo "==========================================================================="
echo ""
log_info "查看日志: docker logs -f puppy-stardew"
echo ""

# 询问是否查看日志
read -p "是否查看服务器日志？(y/n): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    docker logs -f puppy-stardew
fi

