# 🐳 Docker Hub 推送完整指南

## 📋 准备工作清单

- [ ] 有 Docker Hub 账户（免费）
- [ ] 知道 Docker Hub 用户名和密码
- [ ] 服务器已安装 Docker
- [ ] 有网络连接

---

## 🚀 完整操作步骤

### 步骤 1：注册/登录 Docker Hub 网站

#### 如果您还没有账户：

1. **访问注册页面**：
   - 网址：https://hub.docker.com/signup
   
2. **填写注册信息**：
   - Docker ID（用户名）：建议使用 `jacklee121211`
   - Email：您的邮箱
   - Password：设置密码（至少 9 个字符）

3. **验证邮箱**：
   - 检查邮箱中的验证链接
   - 点击链接完成验证

#### 如果您已有账户：

- 访问：https://hub.docker.com/
- 点击右上角 "Sign In" 登录
- 确认能正常登录

---

### 步骤 2：在服务器上登录 Docker Hub

#### 2.1 连接到您的服务器

```bash
# 通过 SSH 连接到服务器
ssh user@your-server-ip

# 进入项目目录
cd jack-stardew-server
```

#### 2.2 执行 Docker 登录命令

```bash
docker login
```

#### 2.3 输入凭证

系统会提示您输入：

```
Login with your Docker ID to push and pull images from Docker Hub.
Username: [输入您的 Docker Hub 用户名]
Password: [输入您的密码，不会显示]
```

**示例：**
```bash
$ docker login
Username: jacklee121211
Password: ********
Login Succeeded

Logging in with your password grants your terminal complete access to your account. 
For better security, log in with a limited-privilege personal access token. 
Learn more at https://docs.docker.com/go/access-tokens/
```

#### 2.4 验证登录状态

```bash
# 查看登录信息
docker info | grep Username
# 应该显示：Username: jacklee121211
```

✅ **登录成功！** 凭证已保存在 `~/.docker/config.json`

---

### 步骤 3：确认镜像名称

**重要**：镜像名称必须与您的 Docker Hub 用户名匹配！

#### 检查当前配置：

```bash
grep "image:" docker-compose.yml
```

应该显示：
```
image: jacklee121211/jack-stardew-server:latest
```

#### 如果您的 Docker Hub 用户名不是 `jacklee121211`：

假设您的用户名是 `myusername`，需要修改：

```bash
# 修改 docker-compose.yml
sed -i 's/jacklee121211/myusername/g' docker-compose.yml

# 修改 build-and-push.sh
sed -i 's/jacklee121211/myusername/g' build-and-push.sh

# 修改 GitHub Actions（如果使用）
sed -i 's/jacklee121211/myusername/g' .github/workflows/docker-build.yml
```

---

### 步骤 4：构建并推送镜像

#### 方法 A：使用自动化脚本（推荐）⭐

```bash
# 赋予执行权限（仅首次需要）
chmod +x build-and-push.sh

# 执行构建和推送
./build-and-push.sh
```

**预计耗时：15-25 分钟**（首次构建）

#### 方法 B：手动执行

```bash
# 1. 构建镜像
docker build -t jacklee121211/jack-stardew-server:latest ./docker

# 2. 推送到 Docker Hub
docker push jacklee121211/jack-stardew-server:latest
```

---

### 步骤 5：验证推送成功

#### 5.1 在命令行验证

```bash
# 查看本地镜像
docker images | grep jack-stardew-server

# 应该显示类似：
# jacklee121211/jack-stardew-server   latest    abc123def456   5 minutes ago   1.5GB
```

#### 5.2 在 Docker Hub 网站验证

1. 访问您的仓库页面：
   - `https://hub.docker.com/r/jacklee121211/jack-stardew-server`
   
2. 检查：
   - ✅ 可以看到 `latest` 标签
   - ✅ 显示推送时间
   - ✅ 显示镜像大小（约 1.5-2GB）

#### 5.3 测试拉取镜像

```bash
# 删除本地镜像
docker rmi jacklee121211/jack-stardew-server:latest

# 从 Docker Hub 拉取
docker pull jacklee121211/jack-stardew-server:latest

# 应该能成功下载
```

---

### 步骤 6：测试部署速度

```bash
# 停止当前服务
docker compose down

# 清理本地镜像（测试从 Docker Hub 拉取）
docker rmi jacklee121211/jack-stardew-server:latest

# 记录开始时间并启动
time docker compose up -d

# 预期：5-10 分钟内完成（vs 之前的 20-40 分钟）

# 查看日志
docker logs -f puppy-stardew
```

---

## ⚠️ 常见问题

### Q1: 提示 "unauthorized: authentication required"

**原因**：未登录或登录失效

**解决**：
```bash
docker logout
docker login
# 重新输入用户名和密码
```

### Q2: 提示 "denied: requested access to the resource is denied"

**原因**：镜像名称与 Docker Hub 用户名不匹配

**解决**：
1. 确认您的 Docker Hub 用户名
2. 修改镜像名称使其匹配
3. 重新构建和推送

### Q3: 推送速度很慢

**原因**：网络速度限制

**解决**：
- 耐心等待（首次推送约 1.5-2GB）
- 考虑在网络好的时间段推送
- 或使用国内镜像加速（需要额外配置）

### Q4: 提示 "toomanyrequests: You have reached your pull rate limit"

**原因**：Docker Hub 免费账户有拉取限制

**解决**：
- 已登录的用户有更高的限制（200 次/6小时）
- 等待一段时间后重试
- 或考虑 Docker Hub Pro 账户

---

## 🔐 安全建议

### 使用 Access Token（推荐）

相比直接使用密码，使用 Access Token 更安全：

1. **创建 Token**：
   - 访问：https://hub.docker.com/settings/security
   - 点击 "New Access Token"
   - 权限选择 "Read, Write, Delete"
   - 复制 Token

2. **使用 Token 登录**：
   ```bash
   docker login -u jacklee121211
   Password: [粘贴 Token，不是密码]
   ```

3. **好处**：
   - ✅ 可以随时撤销
   - ✅ 可以设置有效期
   - ✅ 可以限制权限
   - ✅ 更安全

---

## 📊 速度对比

### 推送前（本地构建）：
```
首次部署：20-40 分钟 🐌
重新部署：15-30 分钟 🐌
```

### 推送后（Docker Hub）：
```
首次部署：5-10 分钟 ⚡
重新部署：<1 分钟 ⚡
```

**提升：4-5 倍！**

---

## ✅ 完成检查清单

- [ ] 已注册 Docker Hub 账户
- [ ] 在服务器上成功执行 `docker login`
- [ ] 确认镜像名称与用户名匹配
- [ ] 成功执行 `./build-and-push.sh`
- [ ] 在 Docker Hub 网站能看到镜像
- [ ] 测试部署速度，确认提升

---

## 🎉 下一步

完成推送后：

1. **更新 README**：
   - 添加 Docker Hub 镜像地址
   - 更新部署说明

2. **配置 GitHub Actions**（可选）：
   - 参考：`.github/SETUP-GITHUB-ACTIONS.md`
   - 实现自动化构建

3. **通知用户**：
   - 告知用户现在可以快速部署了
   - 分享新的部署速度

---

## 📞 需要帮助？

如果遇到问题：

1. 检查网络连接
2. 确认 Docker 版本：`docker --version`
3. 查看详细错误信息
4. 参考 Docker Hub 官方文档：https://docs.docker.com/docker-hub/

---

**现在开始推送，享受极速部署！** 🚀


