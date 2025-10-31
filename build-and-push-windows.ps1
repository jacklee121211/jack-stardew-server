# =============================================================================
# Jack Stardew Server - Windows Build and Push Script
# Build and Push Script for Windows
# =============================================================================

Write-Host ""
Write-Host "==========================================================================" -ForegroundColor Cyan
Write-Host "  Docker Build and Push Script (Windows)" -ForegroundColor Cyan
Write-Host "==========================================================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$TARGET_IMAGE = "jacklee121211/jack-stardew-server:latest"
$DOCKER_DIR = "./docker"

# Step 1: Check if Docker Desktop is running
Write-Host "[Step 1] Checking Docker Desktop status..." -ForegroundColor Blue
Write-Host ""

try {
    docker info | Out-Null
    Write-Host "Docker Desktop is running" -ForegroundColor Green
} catch {
    Write-Host "Docker Desktop is not running or not installed!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please start Docker Desktop or install it from:" -ForegroundColor Yellow
    Write-Host "https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

# Step 2: Check Docker Hub login status
Write-Host ""
Write-Host "[Step 2] Checking Docker Hub login status..." -ForegroundColor Blue
Write-Host ""

$dockerInfo = docker info 2>&1 | Out-String
if ($dockerInfo -match "Username") {
    Write-Host "Already logged in to Docker Hub" -ForegroundColor Green
} else {
    Write-Host "Not logged in, logging in to Docker Hub..." -ForegroundColor Yellow
    Write-Host ""
    docker login
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Login failed!" -ForegroundColor Red
        exit 1
    }
    Write-Host "Login successful!" -ForegroundColor Green
}

# Step 3: Build Docker image
Write-Host ""
Write-Host "[Step 3] Starting Docker image build..." -ForegroundColor Blue
Write-Host ""
Write-Host "Image name: $TARGET_IMAGE" -ForegroundColor Cyan
Write-Host "Build directory: $DOCKER_DIR" -ForegroundColor Cyan
Write-Host ""
Write-Host "Estimated time: 20-30 minutes (first build)" -ForegroundColor Yellow
Write-Host "You can go grab a coffee while it builds..." -ForegroundColor Yellow
Write-Host ""

$buildStartTime = Get-Date

docker build -t $TARGET_IMAGE $DOCKER_DIR

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Image build failed!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Common issues:" -ForegroundColor Yellow
    Write-Host "1. Check network connection" -ForegroundColor Yellow
    Write-Host "2. Ensure all files in docker directory are complete" -ForegroundColor Yellow
    Write-Host "3. Check if disk space is sufficient" -ForegroundColor Yellow
    Write-Host "4. Try running this script again" -ForegroundColor Yellow
    exit 1
}

$buildEndTime = Get-Date
$buildDuration = $buildEndTime - $buildStartTime

Write-Host ""
Write-Host "Image build successful!" -ForegroundColor Green
Write-Host "Build time: $($buildDuration.ToString('mm\:ss'))" -ForegroundColor Cyan

# Show image info
Write-Host ""
Write-Host "Image information:" -ForegroundColor Cyan
docker images $TARGET_IMAGE

# Step 4: Push image to Docker Hub
Write-Host ""
Write-Host "[Step 4] Pushing image to Docker Hub..." -ForegroundColor Blue
Write-Host ""
Write-Host "Estimated time: 5-10 minutes (depends on upload speed)" -ForegroundColor Yellow
Write-Host ""

$pushStartTime = Get-Date

docker push $TARGET_IMAGE

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Image push failed!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Common issues:" -ForegroundColor Yellow
    Write-Host "1. Check network connection" -ForegroundColor Yellow
    Write-Host "2. Ensure you are logged in to Docker Hub" -ForegroundColor Yellow
    Write-Host "3. Verify image name matches Docker Hub username" -ForegroundColor Yellow
    exit 1
}

$pushEndTime = Get-Date
$pushDuration = $pushEndTime - $pushStartTime

Write-Host ""
Write-Host "Image push successful!" -ForegroundColor Green
Write-Host "Push time: $($pushDuration.ToString('mm\:ss'))" -ForegroundColor Cyan

# Summary
Write-Host ""
Write-Host "==========================================================================" -ForegroundColor Green
Write-Host "  Build and Push Complete!" -ForegroundColor Green
Write-Host "==========================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Image address: $TARGET_IMAGE" -ForegroundColor Cyan
Write-Host "Docker Hub: https://hub.docker.com/r/jacklee121211/jack-stardew-server" -ForegroundColor Cyan
Write-Host ""
Write-Host "Total time: $([math]::Round(($buildDuration.TotalMinutes + $pushDuration.TotalMinutes), 1)) minutes" -ForegroundColor Cyan
Write-Host ""
Write-Host "==========================================================================" -ForegroundColor Cyan
Write-Host "  Next Steps" -ForegroundColor Cyan
Write-Host "==========================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "On your server, run the following commands to deploy:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  ssh user@your-server-ip" -ForegroundColor White
Write-Host "  cd jack-stardew-server" -ForegroundColor White
Write-Host "  docker compose pull" -ForegroundColor White
Write-Host "  docker compose up -d" -ForegroundColor White
Write-Host ""
Write-Host "Server deployment takes only 5-10 minutes (no VPN needed)!" -ForegroundColor Green
Write-Host ""
Write-Host "==========================================================================" -ForegroundColor Green

# Ask if cleanup is needed
Write-Host ""
$cleanup = Read-Host "Delete local image to save disk space? (y/n)"
if ($cleanup -eq "y" -or $cleanup -eq "Y") {
    Write-Host ""
    Write-Host "Cleaning up local image..." -ForegroundColor Yellow
    docker rmi $TARGET_IMAGE
    Write-Host "Cleanup complete" -ForegroundColor Green
}

Write-Host ""
Write-Host "All done!" -ForegroundColor Green
Write-Host ""
