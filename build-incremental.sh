#!/bin/bash
# =============================================================================
# 增量构建脚本 - 基于原作者镜像添加您的修改
# Incremental Build Script - Add your modifications on top of original image
# =============================================================================

set -e

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

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  🔨 增量构建脚本 | Incremental Build Script${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

TARGET_IMAGE="jacklee121211/jack-stardew-server:latest"

log_step "步骤 1: 检查 Docker 登录"
if ! docker info | grep -q "Username"; then
    log_info "未登录，正在登录 Docker Hub..."
    docker login
fi

log_step "步骤 2: 拉取原作者镜像作为基础"
log_info "这样可以节省大量构建时间..."
docker pull truemanlive/puppy-stardew-server:latest

log_step "步骤 3: 增量构建（添加您的修改）"
log_info "构建镜像: ${TARGET_IMAGE}"
docker build -f docker/Dockerfile.incremental -t ${TARGET_IMAGE} .

log_step "步骤 4: 推送到 Docker Hub"
docker push ${TARGET_IMAGE}

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  🎉 增量构建完成！${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
log_info "镜像地址: ${TARGET_IMAGE}"
log_info "Docker Hub: https://hub.docker.com/r/jacklee121211/jack-stardew-server"
echo ""


