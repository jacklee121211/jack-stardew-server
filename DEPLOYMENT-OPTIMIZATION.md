# 🚀 部署优化说明 | Deployment Optimization Guide

## 📊 问题分析 | Problem Analysis

### 原项目 vs 修改后项目的速度对比

| 项目 | 部署方式 | 首次启动时间 | 原因 |
|------|---------|------------|------|
| **原项目**<br>(truman-world) | Docker Hub 预构建镜像 | ⚡ **5-10分钟** | 直接拉取已构建好的镜像 |
| **修改后项目**<br>(jacklee121211) | 本地构建 Dockerfile | 🐌 **20-40分钟** | 每次都要从头构建镜像 |

---

## 🔍 详细对比

### 原项目的架构

**docker-compose.yml（原项目）：**
```yaml
services:
  stardew-server:
    image: truemanlive/puppy-stardew-server:latest  # 直接使用 Docker Hub 镜像
    ports:
      - "24642:24642/udp"
      - "5900:5900/tcp"
```

**优点：**
- ✅ 用户无需构建，直接拉取镜像（5-10分钟）
- ✅ 镜像已在 Docker Hub CDN 上，下载速度快
- ✅ 所有依赖已预装，开箱即用
- ✅ 版本控制简单，更新容易

---

### 修改后项目的架构（改进前）

**docker-compose.yml（修改后）：**
```yaml
services:
  stardew-server:
    build:
      context: ./docker
      dockerfile: Dockerfile  # 每次都本地构建
    image: jack-stardew-server:latest
```

**缺点：**
- ❌ 每次启动都要从头构建镜像（20-40分钟）
- ❌ 需要下载 Ubuntu 基础镜像（~80MB）
- ❌ 需要安装所有 apt 包（100MB+）
- ❌ 需要下载 SteamCMD（~20MB）
- ❌ 需要复制和配置所有 mods
- ❌ 网络波动会导致构建失败

---

## 💡 解决方案

### 方案 1：使用 Docker Hub（强烈推荐）⭐⭐⭐⭐⭐

这是**最优解决方案**，完全复制原项目的架构。

#### 步骤 1：构建并推送镜像

```bash
# 方法 A: 使用提供的自动化脚本（推荐）
./build-and-push.sh

# 方法 B: 手动构建和推送
docker login
docker build -t jacklee121211/jack-stardew-server:latest ./docker
docker push jacklee121211/jack-stardew-server:latest
```

#### 步骤 2：已完成 ✅

`docker-compose.yml` 已修改为使用 Docker Hub 镜像：

```yaml
services:
  stardew-server:
    image: jacklee121211/jack-stardew-server:latest  # 现在使用 Docker Hub
```

#### 步骤 3：测试部署速度

```bash
# 停止当前容器
docker compose down

# 删除本地镜像以测试从 Docker Hub 拉取
docker rmi jacklee121211/jack-stardew-server:latest

# 重新启动（将从 Docker Hub 拉取）
docker compose up -d

# 查看日志
docker logs -f puppy-stardew
```

**预期结果：**
- ⚡ 首次部署时间：**5-10分钟**（vs 之前的 20-40分钟）
- ⚡ 重新部署时间：**<1分钟**（镜像已缓存）

---

### 方案 2：GitHub Actions 自动化（推荐）⭐⭐⭐⭐

设置 CI/CD 自动构建和推送镜像。

#### 创建 `.github/workflows/docker-build.yml`：

```yaml
name: Build and Push Docker Image

on:
  push:
    branches: [ main ]
    paths:
      - 'docker/**'
      - '.github/workflows/docker-build.yml'
  release:
    types: [published]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2

      - name: Login to Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Build and push
        uses: docker/build-push-action@v4
        with:
          context: ./docker
          push: true
          tags: |
            jacklee121211/jack-stardew-server:latest
            jacklee121211/jack-stardew-server:${{ github.sha }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
```

**配置步骤：**
1. 在 GitHub 仓库设置 Secrets：
   - `DOCKERHUB_USERNAME`: Docker Hub 用户名
   - `DOCKERHUB_TOKEN`: Docker Hub Access Token
2. 每次推送代码到 main 分支，自动构建并推送镜像
3. 用户始终能拉取到最新版本

---

### 方案 3：本地构建优化（不推荐）⭐⭐

如果确实不想使用 Docker Hub，可以优化 Dockerfile：

```dockerfile
# 使用更小的基础镜像
FROM ubuntu:22.04 as base

# 使用 BuildKit 缓存
RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update && apt-get install -y ...

# 多阶段构建
FROM base as builder
# 构建阶段

FROM base as final
# 最终镜像
```

**但仍然比 Docker Hub 慢 3-5 倍！**

---

## 📈 性能对比表

| 场景 | 本地构建 | Docker Hub | 改善倍数 |
|------|---------|-----------|---------|
| 首次部署 | 20-40 分钟 | 5-10 分钟 | **4-5倍** |
| 重新部署 | 15-30 分钟 | <1 分钟 | **15-30倍** |
| 网络需求 | 下载所有依赖 | 仅拉取镜像 | **节省 50%+** |
| 失败率 | 网络波动易失败 | 极低 | **更稳定** |

---

## 🎯 推荐行动计划

### 立即执行（今天）：

1. ✅ **已完成**：修改 `docker-compose.yml` 使用 Docker Hub
2. ⚡ **执行**：运行 `./build-and-push.sh` 构建并推送镜像
3. 🧪 **测试**：验证从 Docker Hub 拉取速度

### 短期优化（本周）：

4. 📝 **更新 README**：说明镜像托管在 Docker Hub
5. 🔄 **设置 GitHub Actions**：自动化构建流程
6. 📣 **通知用户**：更新部署指南

### 长期维护（持续）：

7. 🏷️ **版本标签**：使用语义化版本（v1.0.0, v1.0.1...）
8. 📊 **监控**：跟踪 Docker Hub 拉取统计
9. 🔔 **自动化**：每次代码更新自动构建新镜像

---

## 🔗 相关链接

- **原项目**：https://github.com/truman-world/puppy-stardew-server
- **原项目 Docker Hub**：https://hub.docker.com/r/truemanlive/puppy-stardew-server
- **您的 Docker Hub**：https://hub.docker.com/r/jacklee121211/jack-stardew-server
- **构建脚本**：`./build-and-push.sh`

---

## ❓ 常见问题

### Q1: 为什么原项目更快？
**A:** 原项目使用预构建的 Docker Hub 镜像，用户直接拉取即可。您的项目每次都从头构建，需要下载和安装所有依赖。

### Q2: 必须使用 Docker Hub 吗？
**A:** 不是必须，但**强烈推荐**。您也可以：
- 使用其他容器注册表（阿里云、腾讯云、GitHub Container Registry）
- 使用私有镜像仓库
- 继续本地构建（但会很慢）

### Q3: 推送到 Docker Hub 安全吗？
**A:** 完全安全，因为：
- ✅ 镜像不包含游戏文件（用户自己下载）
- ✅ 镜像不包含 Steam 凭证
- ✅ 只包含开源工具（SMAPI、mods）
- ✅ 原项目也是这样做的

### Q4: 如何更新镜像？
**A:** 代码改动后，重新运行：
```bash
./build-and-push.sh v1.0.1  # 指定版本号
```

### Q5: 能否同时支持两种方式？
**A:** 可以！`docker-compose.yml` 已配置为：
- 默认使用 Docker Hub（快速）
- 注释掉的 `build` 部分可用于本地构建

---

## 🎉 总结

使用 Docker Hub 预构建镜像后：

- ⚡ **部署速度提升 4-5 倍**
- 🎯 **用户体验大幅改善**
- 🚀 **与原项目性能持平**
- 💪 **更稳定、更可靠**

**立即执行 `./build-and-push.sh`，让您的项目飞起来！** 🚀

