#!/bin/bash
# =============================================================================
# Jack Stardew Server - 构建并推送 Docker 镜像
# Build and Push Docker Image
# =============================================================================

set -e

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Docker Hub 用户名和镜像名
DOCKER_USERNAME="jacklee121211"
IMAGE_NAME="jack-stardew-server"
VERSION=${1:-"latest"}

log_step "步骤 1: 检查 Docker 登录状态"
if ! docker info | grep -q "Username"; then
    log_warn "未登录 Docker Hub，正在登录..."
    docker login
else
    log_info "已登录 Docker Hub"
fi

log_step "步骤 2: 构建 Docker 镜像"
log_info "构建版本: ${VERSION}"
log_info "这可能需要 10-20 分钟..."

docker build \
    -t ${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION} \
    -t ${DOCKER_USERNAME}/${IMAGE_NAME}:latest \
    ./docker

if [ $? -eq 0 ]; then
    log_info "✅ 镜像构建成功！"
else
    log_error "❌ 镜像构建失败！"
    exit 1
fi

log_step "步骤 3: 推送镜像到 Docker Hub"
log_info "推送版本: ${VERSION}"

docker push ${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}
docker push ${DOCKER_USERNAME}/${IMAGE_NAME}:latest

if [ $? -eq 0 ]; then
    log_info "✅ 镜像推送成功！"
else
    log_error "❌ 镜像推送失败！"
    exit 1
fi

log_step "步骤 4: 清理本地镜像（可选）"
echo ""
read -p "是否清理本地构建的镜像以节省空间？(y/n): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    docker rmi ${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}
    log_info "✅ 本地镜像已清理"
fi

echo ""
log_info "=========================================="
log_info "🎉 构建和推送完成！"
log_info "=========================================="
log_info "镜像地址: ${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}"
log_info "Docker Hub: https://hub.docker.com/r/${DOCKER_USERNAME}/${IMAGE_NAME}"
log_info ""
log_info "用户现在可以使用以下命令快速部署："
echo ""
echo "  curl -sSL https://raw.githubusercontent.com/jacklee121211/jack-stardew-server/main/quick-start-zh.sh | bash"
echo ""
log_info "=========================================="

