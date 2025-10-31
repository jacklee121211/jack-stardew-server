#!/bin/bash
# =============================================================================
# 代理性能测试脚本 - Proxy Performance Test Script
# =============================================================================
# 测试代理速度、延迟和连通性
# =============================================================================

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# 代理配置
PROXY_HOST="${PROXY_HOST:-127.0.0.1}"
PROXY_PORT="${PROXY_PORT:-7890}"
PROXY_URL="http://${PROXY_HOST}:${PROXY_PORT}"

# 测试网站列表
SITES=(
    "Google:https://www.google.com"
    "GitHub:https://www.github.com"
    "YouTube:https://www.youtube.com"
    "Steam:https://store.steampowered.com"
    "Docker Hub:https://hub.docker.com"
    "Wikipedia:https://www.wikipedia.org"
    "Facebook:https://www.facebook.com"
    "Twitter:https://www.twitter.com"
    "Discord:https://discord.com"
    "Netflix:https://www.netflix.com"
)

print_header() {
    echo ""
    echo -e "${CYAN}${BOLD}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}${BOLD}  🚀 代理性能测试工具 - Proxy Performance Test${NC}"
    echo -e "${CYAN}${BOLD}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
}

print_section() {
    echo ""
    echo -e "${BLUE}${BOLD}📊 $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

test_proxy_connectivity() {
    print_section "1. 代理连通性测试"
    
    echo -e "${YELLOW}测试代理: ${PROXY_URL}${NC}"
    echo ""
    
    if curl -s --proxy "$PROXY_URL" --connect-timeout 5 http://www.google.com > /dev/null 2>&1; then
        echo -e "${GREEN}✅ 代理连通性: 正常${NC}"
        return 0
    else
        echo -e "${RED}❌ 代理连通性: 失败${NC}"
        return 1
    fi
}

test_site_with_proxy() {
    local name=$1
    local url=$2
    
    local start_time=$(date +%s%N)
    local http_code=$(curl -s --proxy "$PROXY_URL" "$url" -I --connect-timeout 10 --max-time 15 -o /dev/null -w "%{http_code}" 2>/dev/null)
    local end_time=$(date +%s%N)
    local duration=$(( (end_time - start_time) / 1000000 )) # 转换为毫秒
    
    if [ "$http_code" -ge 200 ] && [ "$http_code" -lt 400 ]; then
        printf "  ${GREEN}✅${NC} %-20s ${GREEN}成功${NC} (HTTP %s) ${CYAN}%6d ms${NC}\n" "$name" "$http_code" "$duration"
        return 0
    else
        printf "  ${RED}❌${NC} %-20s ${RED}失败${NC} (HTTP %s) ${CYAN}%6d ms${NC}\n" "$name" "$http_code" "$duration"
        return 1
    fi
}

test_site_direct() {
    local name=$1
    local url=$2
    
    local start_time=$(date +%s%N)
    local http_code=$(curl -s "$url" -I --connect-timeout 10 --max-time 15 -o /dev/null -w "%{http_code}" 2>/dev/null)
    local end_time=$(date +%s%N)
    local duration=$(( (end_time - start_time) / 1000000 ))
    
    if [ "$http_code" -ge 200 ] && [ "$http_code" -lt 400 ]; then
        printf "  ${GREEN}✅${NC} %-20s ${GREEN}成功${NC} (HTTP %s) ${CYAN}%6d ms${NC}\n" "$name" "$http_code" "$duration"
        return 0
    else
        printf "  ${RED}❌${NC} %-20s ${RED}失败${NC} (HTTP %s) ${CYAN}%6d ms${NC}\n" "$name" "$http_code" "$duration"
        return 1
    fi
}

test_all_sites_proxy() {
    print_section "2. 通过代理访问国际网站（延迟测试）"
    
    echo -e "${YELLOW}测试网站: 共 ${#SITES[@]} 个${NC}"
    echo ""
    printf "  ${BOLD}%-20s %-10s %-15s %-10s${NC}\n" "网站" "状态" "HTTP代码" "延迟"
    echo "  ──────────────────────────────────────────────────────────────"
    
    local success=0
    local total=0
    local total_time=0
    
    for site in "${SITES[@]}"; do
        name=$(echo $site | cut -d: -f1)
        url=$(echo $site | cut -d: -f2-)
        
        total=$((total + 1))
        start_time=$(date +%s%N)
        http_code=$(curl -s --proxy "$PROXY_URL" "$url" -I --connect-timeout 10 --max-time 15 -o /dev/null -w "%{http_code}" 2>/dev/null)
        end_time=$(date +%s%N)
        duration=$(( (end_time - start_time) / 1000000 ))
        total_time=$((total_time + duration))
        
        if [ "$http_code" -ge 200 ] && [ "$http_code" -lt 400 ]; then
            printf "  ${GREEN}✅${NC} %-20s ${GREEN}成功${NC} (HTTP %s) ${CYAN}%6d ms${NC}\n" "$name" "$http_code" "$duration"
            success=$((success + 1))
        else
            printf "  ${RED}❌${NC} %-20s ${RED}失败${NC} (HTTP %s) ${CYAN}%6d ms${NC}\n" "$name" "$http_code" "$duration"
        fi
    done
    
    echo ""
    if [ $total -gt 0 ]; then
        local avg_time=$((total_time / total))
        echo -e "  成功率: ${CYAN}$success/$total${NC} ($((success * 100 / total))%)"
        echo -e "  平均延迟: ${CYAN}${avg_time} ms${NC}"
    fi
}

test_all_sites_direct() {
    print_section "3. 直连访问测试（对比基准）"
    
    echo -e "${YELLOW}测试直连速度（不通过代理）${NC}"
    echo ""
    printf "  ${BOLD}%-20s %-10s %-15s %-10s${NC}\n" "网站" "状态" "HTTP代码" "延迟"
    echo "  ──────────────────────────────────────────────────────────────"
    
    local success=0
    local total=0
    local total_time=0
    
    for site in "${SITES[@]}"; do
        name=$(echo $site | cut -d: -f1)
        url=$(echo $site | cut -d: -f2-)
        
        total=$((total + 1))
        start_time=$(date +%s%N)
        http_code=$(curl -s "$url" -I --connect-timeout 10 --max-time 15 -o /dev/null -w "%{http_code}" 2>/dev/null)
        end_time=$(date +%s%N)
        duration=$(( (end_time - start_time) / 1000000 ))
        total_time=$((total_time + duration))
        
        if [ "$http_code" -ge 200 ] && [ "$http_code" -lt 400 ]; then
            printf "  ${GREEN}✅${NC} %-20s ${GREEN}成功${NC} (HTTP %s) ${CYAN}%6d ms${NC}\n" "$name" "$http_code" "$duration"
            success=$((success + 1))
        else
            printf "  ${RED}❌${NC} %-20s ${RED}失败${NC} (HTTP %s) ${CYAN}%6d ms${NC}\n" "$name" "$http_code" "$duration"
        fi
    done
    
    echo ""
    if [ $total -gt 0 ]; then
        local avg_time=$((total_time / total))
        echo -e "  成功率: ${CYAN}$success/$total${NC} ($((success * 100 / total))%)"
        echo -e "  平均延迟: ${CYAN}${avg_time} ms${NC}"
    fi
}

test_docker_proxy() {
    print_section "4. Docker 代理配置测试"
    
    if command -v docker &> /dev/null; then
        echo -e "${YELLOW}检查 Docker daemon 代理配置...${NC}"
        echo ""
        
        if docker info 2>/dev/null | grep -qi "HTTP Proxy"; then
            docker info 2>/dev/null | grep -i proxy | while read line; do
                echo -e "  ${GREEN}✅${NC} $line"
            done
        else
            echo -e "  ${RED}❌ Docker daemon 未配置代理${NC}"
        fi
        
        echo ""
        echo -e "${YELLOW}测试容器内代理访问...${NC}"
        if docker run --rm --env HTTP_PROXY="$PROXY_URL" --env HTTPS_PROXY="$PROXY_URL" \
           curlimages/curl:latest curl -I --proxy "$PROXY_URL" http://www.google.com --connect-timeout 5 2>/dev/null | grep -q "200\|301\|302"; then
            echo -e "  ${GREEN}✅ 容器内代理访问: 正常${NC}"
        else
            echo -e "  ${RED}❌ 容器内代理访问: 失败${NC}"
        fi
    else
        echo -e "${YELLOW}Docker 未安装，跳过测试${NC}"
    fi
}

test_clash_dashboard() {
    print_section "5. Clash Dashboard 信息"
    
    if command -v curl &> /dev/null; then
        echo -e "${YELLOW}获取 Clash Meta 当前配置...${NC}"
        echo ""
        
        # 获取当前模式
        mode=$(curl -s http://127.0.0.1:9090/configs 2>/dev/null | grep -o '"mode":"[^"]*"' | cut -d'"' -f4 || echo "未知")
        echo -e "  当前模式: ${CYAN}${mode}${NC}"
        
        # 获取当前使用的代理
        current_proxy=$(curl -s http://127.0.0.1:9090/proxies/节点选择 2>/dev/null | grep -o '"now":"[^"]*"' | cut -d'"' -f4 || echo "未知")
        echo -e "  当前代理: ${CYAN}${current_proxy}${NC}"
        
        echo ""
        echo -e "  Dashboard 地址: ${CYAN}http://${PROXY_HOST}:9090/ui${NC}"
    else
        echo -e "${YELLOW}curl 未安装，无法获取 Dashboard 信息${NC}"
    fi
}

test_stability() {
    print_section "6. 代理稳定性测试（10次）"
    
    echo -e "${YELLOW}测试代理稳定性，连续测试 10 次...${NC}"
    echo ""
    
    local success=0
    local fail=0
    local total_time=0
    
    for i in {1..10}; do
        start_time=$(date +%s%N)
        if curl -s --proxy "$PROXY_URL" http://www.google.com -I --connect-timeout 5 --max-time 10 -o /dev/null -w "%{http_code}" 2>/dev/null | grep -q "200\|301\|302"; then
            end_time=$(date +%s%N)
            duration=$(( (end_time - start_time) / 1000000 ))
            total_time=$((total_time + duration))
            echo -e "  ${GREEN}✅${NC} 测试 $i: 成功 (${duration} ms)"
            success=$((success + 1))
        else
            echo -e "  ${RED}❌${NC} 测试 $i: 失败"
            fail=$((fail + 1))
        fi
        sleep 1
    done
    
    echo ""
    if [ $success -gt 0 ]; then
        local avg_time=$((total_time / success))
        echo -e "  成功率: ${CYAN}$success/10${NC} ($((success * 100 / 10))%)"
        echo -e "  平均延迟: ${CYAN}${avg_time} ms${NC}"
        
        if [ $success -ge 9 ]; then
            echo -e "  ${GREEN}✅ 代理稳定性: 优秀${NC}"
        elif [ $success -ge 7 ]; then
            echo -e "  ${YELLOW}⚠️  代理稳定性: 良好${NC}"
        else
            echo -e "  ${RED}❌ 代理稳定性: 较差${NC}"
        fi
    fi
}

print_summary() {
    print_section "📋 测试总结"
    
    echo -e "${BOLD}代理地址:${NC} ${CYAN}${PROXY_URL}${NC}"
    echo ""
    echo -e "${BOLD}建议:${NC}"
    echo -e "  • 如果代理延迟 > 1000ms，建议切换到更快的节点"
    echo -e "  • 如果成功率 < 80%，检查代理配置或节点状态"
    echo -e "  • 如果直连更快，考虑禁用代理或优化规则"
    echo ""
}

# 主函数
main() {
    print_header
    
    # 检查代理是否可用
    if ! test_proxy_connectivity; then
        echo -e "${RED}${BOLD}错误：代理不可用！请检查代理服务是否运行。${NC}"
        echo ""
        echo "检查命令："
        echo "  systemctl status clash-meta"
        echo "  ss -tulpn | grep 7890"
        exit 1
    fi
    
    # 运行所有测试
    test_all_sites_proxy
    test_all_sites_direct
    test_docker_proxy
    test_clash_dashboard
    test_stability
    
    print_summary
    
    echo ""
    echo -e "${GREEN}${BOLD}✨ 测试完成！${NC}"
    echo ""
}

# 运行主函数
main

