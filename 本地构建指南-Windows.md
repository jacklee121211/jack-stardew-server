# 💻 本地构建指南 - Windows 版

## 🎯 适用场景

- ✅ 您的**本地电脑有梯子**，网络畅通
- ✅ 您的**服务器没有梯子**，无法访问国外网络
- ✅ 在本地构建，推送到 Docker Hub，服务器直接拉取

---

## 📋 前置准备

### 1. 安装 Docker Desktop

如果您还没安装：

1. 访问：https://www.docker.com/products/docker-desktop
2. 下载 Windows 版本
3. 安装并启动 Docker Desktop
4. 确保 Docker Desktop 图标显示为绿色（运行中）

### 2. 验证 Docker 安装

打开 **PowerShell** 或 **CMD**，执行：

```powershell
docker --version
```

应该显示类似：
```
Docker version 24.0.6, build ed223bc
```

---

## 🚀 方法一：使用自动化脚本（推荐）⭐

### 步骤 1：打开 PowerShell

在项目目录右键 → 选择 "在终端中打开"

或者：
```powershell
cd D:\GIT\jack-stardew-server
```

### 步骤 2：执行构建脚本

```powershell
# 如果提示执行策略限制，先执行此命令
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# 运行构建脚本
.\build-and-push-windows.ps1
```

### 步骤 3：等待完成

脚本会自动完成以下操作：
1. ✅ 检查 Docker Desktop 是否运行
2. ✅ 检查 Docker Hub 登录状态（未登录会提示登录）
3. ✅ 构建镜像（20-30 分钟）
4. ✅ 推送到 Docker Hub（5-10 分钟）
5. ✅ 显示完成信息

**总耗时：约 25-40 分钟**

---

## 🚀 方法二：手动执行命令

### 步骤 1：登录 Docker Hub

```powershell
docker login
```

输入：
- Username: 您的 Docker Hub 用户名
- Password: 您的 Docker Hub 密码

### 步骤 2：构建镜像

```powershell
docker build -t jacklee121211/jack-stardew-server:latest ./docker
```

**预计时间：20-30 分钟**

您会看到类似输出：
```
[+] Building 1234.5s (20/20) FINISHED
 => [internal] load build definition from Dockerfile
 => [internal] load .dockerignore
 => [1/15] FROM ubuntu:22.04
 => [2/15] RUN sed -i 's@http://.*archive.ubuntu.com@http://mirrors.aliyun.com@g'
 ...
 => exporting to image
 => => naming to jacklee121211/jack-stardew-server:latest
```

### 步骤 3：推送镜像

```powershell
docker push jacklee121211/jack-stardew-server:latest
```

**预计时间：5-10 分钟**

您会看到类似输出：
```
The push refers to repository [docker.io/jacklee121211/jack-stardew-server]
abc123def456: Pushed
def456ghi789: Pushed
...
latest: digest: sha256:abc123... size: 1234
```

---

## ✅ 验证推送成功

### 1. 在 Docker Hub 网站查看

访问：https://hub.docker.com/r/jacklee121211/jack-stardew-server

应该能看到：
- ✅ `latest` 标签
- ✅ 镜像大小（约 1.5-2GB）
- ✅ 最后推送时间

### 2. 测试拉取

```powershell
# 删除本地镜像
docker rmi jacklee121211/jack-stardew-server:latest

# 重新拉取
docker pull jacklee121211/jack-stardew-server:latest
```

如果能成功拉取，说明推送成功！

---

## 🖥️ 在服务器上部署

### 步骤 1：SSH 连接到服务器

```bash
ssh user@your-server-ip
```

### 步骤 2：进入项目目录

```bash
cd jack-stardew-server
```

### 步骤 3：拉取并启动

```bash
# 方法 A：先拉取再启动（推荐）
docker compose pull
docker compose up -d

# 方法 B：直接启动（会自动拉取）
docker compose up -d
```

### 步骤 4：查看日志

```bash
docker logs -f puppy-stardew
```

**预计时间：5-10 分钟** ⚡

**关键优势**：服务器从 Docker Hub 拉取，使用国内 CDN，**不需要梯子**！

---

## 📊 时间对比

| 操作 | 位置 | 耗时 | 需要梯子 |
|------|------|------|---------|
| **构建镜像** | 本地电脑 | 20-30 分钟 | ✅ 需要 |
| **推送到 Docker Hub** | 本地电脑 | 5-10 分钟 | ✅ 需要 |
| **拉取镜像** | 服务器 | 3-5 分钟 | ❌ 不需要 |
| **启动服务** | 服务器 | 2-5 分钟 | ❌ 不需要 |
| **服务器总耗时** | - | **5-10 分钟** | ❌ 不需要 |

---

## ⚠️ 常见问题

### Q1: PowerShell 提示 "无法加载脚本"

**原因**：PowerShell 执行策略限制

**解决**：
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

然后重新运行脚本。

### Q2: Docker Desktop 未运行

**现象**：执行命令提示 "error during connect"

**解决**：
1. 点击桌面的 Docker Desktop 图标启动
2. 等待图标变为绿色
3. 重新执行命令

### Q3: 构建速度很慢

**原因**：下载依赖包速度慢

**解决**：
- 确保梯子正常工作
- 或等待，首次构建确实需要较长时间
- Docker 会缓存，第二次构建会快很多

### Q4: 推送失败 "unauthorized"

**原因**：未登录或登录过期

**解决**：
```powershell
docker logout
docker login
```

重新输入用户名和密码。

### Q5: 磁盘空间不足

**现象**：构建过程中提示空间不足

**解决**：
```powershell
# 清理 Docker 缓存
docker system prune -a

# 检查磁盘空间
Get-PSDrive C
```

确保至少有 10GB 可用空间。

---

## 💡 优化建议

### 1. 使用 BuildKit 加速（可选）

```powershell
$env:DOCKER_BUILDKIT=1
docker build -t jacklee121211/jack-stardew-server:latest ./docker
```

### 2. 查看构建日志

如果构建出错，查看详细日志：

```powershell
docker build --progress=plain -t jacklee121211/jack-stardew-server:latest ./docker
```

### 3. 分步构建（调试用）

```powershell
# 只构建不推送
docker build -t jacklee121211/jack-stardew-server:latest ./docker

# 测试镜像是否正常
docker run --rm jacklee121211/jack-stardew-server:latest /bin/bash -c "echo 'Test OK'"

# 确认无误后再推送
docker push jacklee121211/jack-stardew-server:latest
```

---

## 🎯 完整流程总结

### 在本地电脑（有梯子）：

1. ✅ 安装 Docker Desktop
2. ✅ 执行 `.\build-and-push-windows.ps1`
3. ✅ 等待 25-40 分钟完成
4. ✅ 在 Docker Hub 验证镜像已上传

### 在服务器（无梯子）：

1. ✅ SSH 连接到服务器
2. ✅ 执行 `docker compose up -d`
3. ✅ 等待 5-10 分钟完成
4. ✅ 查看日志确认运行正常

---

## 🎉 成功标志

完成后，您应该能：

- ✅ 在 Docker Hub 看到您的镜像
- ✅ 服务器能快速拉取镜像（5-10 分钟）
- ✅ 服务器无需梯子就能部署
- ✅ 部署速度提升 4-5 倍

---

## 📞 需要帮助？

如果遇到问题：

1. 检查 Docker Desktop 是否正常运行
2. 检查网络连接（本地需要梯子）
3. 查看错误信息截图
4. 参考本文档的"常见问题"部分

---

**现在开始构建吧！** 🚀

在 PowerShell 中执行：
```powershell
.\build-and-push-windows.ps1
```


