# GitHub Actions 自动化构建设置指南

## 🎯 目的

自动构建并推送 Docker 镜像到 Docker Hub，让用户始终能拉取到最新版本。

---

## 📋 配置步骤

### 步骤 1：创建 Docker Hub Access Token

1. 登录 [Docker Hub](https://hub.docker.com/)
2. 点击右上角头像 → **Account Settings**
3. 左侧菜单选择 **Security**
4. 点击 **New Access Token**
5. 设置名称（如：`github-actions`），权限选择 **Read, Write, Delete**
6. 点击 **Generate**
7. **立即复制 Token**（关闭后无法再查看）

### 步骤 2：在 GitHub 仓库配置 Secrets

1. 打开您的 GitHub 仓库：https://github.com/jacklee121211/jack-stardew-server
2. 点击 **Settings** → 左侧菜单 **Secrets and variables** → **Actions**
3. 点击 **New repository secret**
4. 添加以下两个 Secrets：

#### Secret 1: DOCKERHUB_USERNAME
- **Name**: `DOCKERHUB_USERNAME`
- **Value**: `jacklee121211`（您的 Docker Hub 用户名）

#### Secret 2: DOCKERHUB_TOKEN
- **Name**: `DOCKERHUB_TOKEN`
- **Value**: 粘贴步骤 1 中复制的 Access Token

### 步骤 3：启用 GitHub Actions

1. 在仓库中，点击 **Actions** 标签
2. 如果显示禁用状态，点击 **I understand my workflows, go ahead and enable them**
3. 现在工作流已启用！

---

## 🚀 自动触发条件

GitHub Actions 会在以下情况自动构建并推送镜像：

### 1. 推送代码到 main 分支（且修改了 docker/ 目录）
```bash
git add docker/
git commit -m "Update Dockerfile"
git push origin main
```

### 2. 创建新的 Release
1. 在 GitHub 仓库点击 **Releases** → **Create a new release**
2. 设置版本号（如：`v1.0.1`）
3. 点击 **Publish release**
4. 自动构建并推送镜像，带版本标签

### 3. 手动触发
1. 进入 **Actions** 标签
2. 选择 **Build and Push Docker Image**
3. 点击 **Run workflow** → **Run workflow**

---

## 📊 构建过程

一旦触发，GitHub Actions 会：

1. ✅ 检出代码
2. ✅ 设置 Docker Buildx
3. ✅ 登录 Docker Hub
4. ✅ 构建 Docker 镜像
5. ✅ 推送到 Docker Hub
6. ✅ 更新 Docker Hub 仓库描述

**预计时间：10-15 分钟**

---

## 🏷️ 镜像标签策略

构建后会生成以下标签：

| 标签 | 说明 | 示例 |
|------|------|------|
| `latest` | 最新的 main 分支版本 | `jacklee121211/jack-stardew-server:latest` |
| `main` | main 分支最新版本 | `jacklee121211/jack-stardew-server:main` |
| `v1.0.0` | Release 版本号 | `jacklee121211/jack-stardew-server:v1.0.0` |
| `sha-abc123` | Git commit SHA | `jacklee121211/jack-stardew-server:sha-abc123` |

---

## 🧪 测试 GitHub Actions

### 方法 1：手动触发（推荐）
1. 进入 **Actions** 标签
2. 选择 **Build and Push Docker Image**
3. 点击 **Run workflow**
4. 查看构建日志

### 方法 2：修改文件触发
```bash
# 修改任意 docker/ 目录下的文件
echo "# Test" >> docker/Dockerfile

# 提交并推送
git add docker/Dockerfile
git commit -m "Test GitHub Actions"
git push origin main
```

### 方法 3：创建测试 Release
1. 在 GitHub 创建新 Release，版本号设为 `v1.0.0-test`
2. 观察 Actions 自动运行

---

## 🔍 查看构建状态

### 实时查看构建日志：
1. 进入 **Actions** 标签
2. 点击最新的工作流运行
3. 点击 **build-and-push** 查看详细日志

### 验证镜像是否成功推送：
```bash
# 拉取最新镜像
docker pull jacklee121211/jack-stardew-server:latest

# 查看镜像信息
docker images | grep jack-stardew-server
```

### 在 Docker Hub 查看：
访问：https://hub.docker.com/r/jacklee121211/jack-stardew-server

---

## ⚠️ 常见问题

### Q1: Actions 显示 "bad credentials"
**原因**：Docker Hub Token 配置错误

**解决**：
1. 检查 Secrets 名称是否正确（`DOCKERHUB_USERNAME` 和 `DOCKERHUB_TOKEN`）
2. 重新生成 Docker Hub Access Token
3. 更新 GitHub Secrets

### Q2: 构建失败 "permission denied"
**原因**：Token 权限不足

**解决**：
1. 确保 Docker Hub Token 有 **Read, Write, Delete** 权限
2. 重新生成 Token

### Q3: Actions 不自动运行
**原因**：
- Actions 未启用
- 修改的文件不在 `docker/` 目录下

**解决**：
1. 确认 Actions 已启用
2. 确保修改了 `docker/` 目录下的文件
3. 或使用手动触发

---

## 📈 效果对比

| 方式 | 构建频率 | 用户体验 | 维护成本 |
|------|---------|---------|---------|
| **手动构建** | 需要手动执行 | 可能拉取到旧版本 | 高 |
| **GitHub Actions** | 自动化 | 始终最新版本 | 低 |

---

## 🎉 完成！

配置完成后，您的项目将：

- ✅ 代码更新后自动构建镜像
- ✅ 用户始终能拉取最新版本
- ✅ 版本管理更规范
- ✅ 部署速度提升 4-5 倍

**下一步**：推送一些代码变更，测试自动化构建是否正常工作！

