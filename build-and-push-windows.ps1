# =============================================================================
# Jack Stardew Server - Windows 构建和推送脚本
# Build and Push Script for Windows
# =============================================================================

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "  🐳 Jack Stardew Server - 构建和推送脚本 (Windows)" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

# 配置
$TARGET_IMAGE = "jacklee121211/jack-stardew-server:latest"
$DOCKER_DIR = "./docker"

# 检查 Docker 是否运行
Write-Host "[步骤 1] 检查 Docker Desktop 是否运行..." -ForegroundColor Blue
Write-Host ""

try {
    docker info | Out-Null
    Write-Host "✅ Docker Desktop 正在运行" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker Desktop 未运行或未安装！" -ForegroundColor Red
    Write-Host ""
    Write-Host "请先启动 Docker Desktop，或访问以下网址安装：" -ForegroundColor Yellow
    Write-Host "https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

# 检查登录状态
Write-Host ""
Write-Host "[步骤 2] 检查 Docker Hub 登录状态..." -ForegroundColor Blue
Write-Host ""

$dockerInfo = docker info 2>&1 | Out-String
if ($dockerInfo -match "Username") {
    Write-Host "✅ 已登录 Docker Hub" -ForegroundColor Green
} else {
    Write-Host "⚠️  未登录 Docker Hub，正在登录..." -ForegroundColor Yellow
    Write-Host ""
    docker login
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ 登录失败！" -ForegroundColor Red
        exit 1
    }
    Write-Host "✅ 登录成功！" -ForegroundColor Green
}

# 构建镜像
Write-Host ""
Write-Host "[步骤 3] 开始构建 Docker 镜像..." -ForegroundColor Blue
Write-Host ""
Write-Host "镜像名称: $TARGET_IMAGE" -ForegroundColor Cyan
Write-Host "构建目录: $DOCKER_DIR" -ForegroundColor Cyan
Write-Host ""
Write-Host "⏱️  预计时间: 20-30 分钟（首次构建）" -ForegroundColor Yellow
Write-Host "💡 您可以去喝杯咖啡，等待构建完成..." -ForegroundColor Yellow
Write-Host ""

$buildStartTime = Get-Date

docker build -t $TARGET_IMAGE $DOCKER_DIR

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "❌ 镜像构建失败！" -ForegroundColor Red
    Write-Host ""
    Write-Host "常见问题排查：" -ForegroundColor Yellow
    Write-Host "1. 检查网络连接" -ForegroundColor Yellow
    Write-Host "2. 确保 docker 目录下文件完整" -ForegroundColor Yellow
    Write-Host "3. 检查磁盘空间是否充足" -ForegroundColor Yellow
    Write-Host "4. 尝试重新运行此脚本" -ForegroundColor Yellow
    exit 1
}

$buildEndTime = Get-Date
$buildDuration = $buildEndTime - $buildStartTime

Write-Host ""
Write-Host "✅ 镜像构建成功！" -ForegroundColor Green
Write-Host "⏱️  构建耗时: $($buildDuration.ToString('mm\:ss'))" -ForegroundColor Cyan

# 查看镜像信息
Write-Host ""
Write-Host "镜像信息：" -ForegroundColor Cyan
docker images $TARGET_IMAGE

# 推送镜像
Write-Host ""
Write-Host "[步骤 4] 推送镜像到 Docker Hub..." -ForegroundColor Blue
Write-Host ""
Write-Host "⏱️  预计时间: 5-10 分钟（取决于上传速度）" -ForegroundColor Yellow
Write-Host ""

$pushStartTime = Get-Date

docker push $TARGET_IMAGE

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "❌ 镜像推送失败！" -ForegroundColor Red
    Write-Host ""
    Write-Host "常见问题排查：" -ForegroundColor Yellow
    Write-Host "1. 检查网络连接" -ForegroundColor Yellow
    Write-Host "2. 确认已登录 Docker Hub" -ForegroundColor Yellow
    Write-Host "3. 确认镜像名称与 Docker Hub 用户名匹配" -ForegroundColor Yellow
    exit 1
}

$pushEndTime = Get-Date
$pushDuration = $pushEndTime - $pushStartTime

Write-Host ""
Write-Host "✅ 镜像推送成功！" -ForegroundColor Green
Write-Host "⏱️  推送耗时: $($pushDuration.ToString('mm\:ss'))" -ForegroundColor Cyan

# 总结
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host "  🎉 构建和推送完成！" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host ""
Write-Host "镜像地址: $TARGET_IMAGE" -ForegroundColor Cyan
Write-Host "Docker Hub: https://hub.docker.com/r/jacklee121211/jack-stardew-server" -ForegroundColor Cyan
Write-Host ""
Write-Host "总耗时: $($buildDuration.TotalMinutes + $pushDuration.TotalMinutes) 分钟" -ForegroundColor Cyan
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "  📝 下一步操作" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""
Write-Host "在您的服务器上执行以下命令部署：" -ForegroundColor Yellow
Write-Host ""
Write-Host "  ssh user@your-server-ip" -ForegroundColor White
Write-Host "  cd jack-stardew-server" -ForegroundColor White
Write-Host "  docker compose pull" -ForegroundColor White
Write-Host "  docker compose up -d" -ForegroundColor White
Write-Host ""
Write-Host "⚡ 服务器部署只需 5-10 分钟（不需要梯子）！" -ForegroundColor Green
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green

# 询问是否清理本地镜像
Write-Host ""
$cleanup = Read-Host "是否删除本地镜像以节省磁盘空间？(y/n)"
if ($cleanup -eq "y" -or $cleanup -eq "Y") {
    Write-Host ""
    Write-Host "正在清理本地镜像..." -ForegroundColor Yellow
    docker rmi $TARGET_IMAGE
    Write-Host "✅ 清理完成" -ForegroundColor Green
}

Write-Host ""
Write-Host "🎉 全部完成！" -ForegroundColor Green
Write-Host ""


