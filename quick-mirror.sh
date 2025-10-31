#!/bin/bash
# =============================================================================
# 快速镜像复制脚本 - 从原作者镜像创建您的镜像
# Quick Mirror Script - Create your image from original author's image
# =============================================================================

set -e

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
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

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}  🐳 快速镜像镜像脚本 | Quick Mirror Script${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# 原作者镜像和您的镜像
SOURCE_IMAGE="truemanlive/puppy-stardew-server:latest"
TARGET_IMAGE="jacklee121211/jack-stardew-server:latest"

log_warn "📜 许可证说明 | License Notice"
echo ""
echo "  原项目使用 MIT 许可证，允许重新分发和修改。"
echo "  The original project uses MIT License, allowing redistribution and modification."
echo ""
echo "  原作者 | Original Author: truemanlive"
echo "  原项目 | Original Project: https://github.com/truman-world/puppy-stardew-server"
echo ""
echo "  根据 MIT 许可证，您可以："
echo "  Under MIT License, you can:"
echo "    ✅ 使用、复制、修改、合并、发布、分发"
echo "    ✅ Use, copy, modify, merge, publish, distribute"
echo ""
echo "  请保留原作者的版权声明。"
echo "  Please retain the original author's copyright notice."
echo ""

read -p "继续？(y/n) | Continue? (y/n): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    log_info "已取消 | Cancelled"
    exit 0
fi

log_step "步骤 1: 检查 Docker 登录状态 | Step 1: Check Docker login"
echo ""

if ! docker info | grep -q "Username"; then
    log_warn "未登录 Docker Hub，正在登录..."
    log_warn "Not logged in to Docker Hub, logging in..."
    echo ""
    docker login
    echo ""
else
    DOCKER_USERNAME=$(docker info | grep "Username" | awk '{print $2}')
    log_info "已登录 Docker Hub，用户名: ${DOCKER_USERNAME}"
    log_info "Already logged in to Docker Hub, username: ${DOCKER_USERNAME}"
    echo ""
fi

log_step "步骤 2: 拉取原作者镜像 | Step 2: Pull original image"
echo ""
log_info "镜像: ${SOURCE_IMAGE}"
log_info "大小约 1.5-2GB，需要几分钟..."
log_info "Size: ~1.5-2GB, will take a few minutes..."
echo ""

if docker pull ${SOURCE_IMAGE}; then
    log_info "✅ 镜像拉取成功！"
    log_info "✅ Image pulled successfully!"
else
    log_error "❌ 镜像拉取失败！"
    log_error "❌ Failed to pull image!"
    exit 1
fi

echo ""
log_step "步骤 3: 重新打标签 | Step 3: Re-tag image"
echo ""
log_info "源镜像 | Source: ${SOURCE_IMAGE}"
log_info "目标镜像 | Target: ${TARGET_IMAGE}"
echo ""

if docker tag ${SOURCE_IMAGE} ${TARGET_IMAGE}; then
    log_info "✅ 标签创建成功！"
    log_info "✅ Tag created successfully!"
else
    log_error "❌ 标签创建失败！"
    log_error "❌ Failed to create tag!"
    exit 1
fi

echo ""
log_step "步骤 4: 推送到您的 Docker Hub | Step 4: Push to your Docker Hub"
echo ""
log_info "推送镜像: ${TARGET_IMAGE}"
log_info "Pushing image: ${TARGET_IMAGE}"
log_info "这可能需要几分钟..."
log_info "This may take a few minutes..."
echo ""

if docker push ${TARGET_IMAGE}; then
    log_info "✅ 镜像推送成功！"
    log_info "✅ Image pushed successfully!"
else
    log_error "❌ 镜像推送失败！"
    log_error "❌ Failed to push image!"
    exit 1
fi

echo ""
log_step "步骤 5: 清理本地镜像（可选）| Step 5: Clean up local images (optional)"
echo ""
read -p "是否删除本地的原作者镜像以节省空间？(y/n) | Delete local original image to save space? (y/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    docker rmi ${SOURCE_IMAGE} 2>/dev/null || true
    log_info "✅ 已清理原作者镜像"
    log_info "✅ Original image cleaned up"
fi

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  🎉 镜像复制完成！| Mirror Complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
log_info "您的镜像地址 | Your image: ${TARGET_IMAGE}"
log_info "Docker Hub 页面 | Docker Hub page:"
echo "  https://hub.docker.com/r/jacklee121211/jack-stardew-server"
echo ""
log_info "现在用户可以快速部署了！| Users can now deploy quickly!"
echo ""
log_info "测试部署 | Test deployment:"
echo "  docker compose down"
echo "  docker rmi ${TARGET_IMAGE}"
echo "  docker compose up -d"
echo ""
log_warn "📝 重要提醒 | Important Reminder:"
echo "  请在 README 中保留原作者信息："
echo "  Please retain original author info in README:"
echo "    - 原作者: truemanlive"
echo "    - 原项目: https://github.com/truman-world/puppy-stardew-server"
echo "    - 许可证: MIT License"
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"


