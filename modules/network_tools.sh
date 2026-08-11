#!/bin/bash
# ============================================================
# 模块: network_tools.sh —— 网络测试工具(ping/路由/测速/端口/HTTP/网络信息)
# 小战云Linux超级工具箱
# ============================================================

# 🌐 网络工具菜单 - 终极质感增强版
function network_tools() {
    show_header
    echo -e "${GOLD}🌐 ====== 网络测试工具 ======${NC}"
    gradient_border
    echo -e "${GREEN}📡  1. Ping测试${NC}          ${GRAY}► 测试网络连通性${NC}"
    echo -e "${BLUE}🛣️  2. Traceroute测试${NC}     ${GRAY}► 追踪网络路径${NC}"
    echo -e "${CYAN}🚀  3. 网速测试${NC}          ${GRAY}► 测试上下行速度${NC}"
    echo -e "${YELLOW}🔌  4. 端口测试${NC}         ${GRAY}► 检查端口状态${NC}"
    echo -e "${PURPLE}🌍  5. HTTP状态测试${NC}      ${GRAY}► 网站可用性检查${NC}"
    echo -e "${ORANGE}📊  6. 网络信息查看${NC}      ${GRAY}► 接口和连接信息${NC}"
    echo -e "${RED}↩️   7. 返回主菜单${NC}        ${GRAY}► 返回主界面${NC}"
    gradient_border
    
    read -p "🎯 请输入选项 [1-7]: " choice
    
    case $choice in
        1) ping_test ;;
        2) traceroute_test ;;
        3) speed_test ;;
        4) port_test ;;
        5) http_test ;;
        6) network_info ;;
        7) main_menu ;;
        *) 
            echo -e "${RED}❌ 无效选项，请重新输入${NC}"
            sleep 1
            network_tools 
            ;;
    esac
}

# 📡 Ping测试 - 增强质感版
function ping_test() {
    show_header
    echo -e "${GOLD}📡 ====== Ping测试 ======${NC}"
    gradient_border
    read -p "🎯 请输入要ping的地址(默认: www.baidu.com): " address
    address=${address:-"www.baidu.com"}
    
    echo -e "${CYAN}🔄 正在ping ${address} ...${NC}"
    separator "─" "$BLUE"
    
    # 使用彩色ping输出
    ping -c 5 $address | while read line; do
        if [[ $line == *"time="* ]]; then
            echo -e "  ${GREEN}✅ $line${NC}"
        elif [[ $line == *"packet loss"* ]]; then
            echo -e "  ${YELLOW}📊 $line${NC}"
        else
            echo -e "  ${GRAY}📋 $line${NC}"
        fi
    done
    
    gradient_border
    read -p "⏎ 按回车键返回..." dummy
    network_tools
}

# 🛣️ Traceroute测试 - 增强质感版
function traceroute_test() {
    show_header
    echo -e "${GOLD}🛣️ ====== Traceroute测试 ======${NC}"
    gradient_border
    
    if ! command -v traceroute &>/dev/null; then
        echo -e "${RED}❌ traceroute未安装${NC}"
        echo -e "${YELLOW}💡 是否立即安装? [Y/n]${NC}"
        read install_choice
        if [[ ! "$install_choice" =~ ^[Nn]$ ]]; then
            echo -e "${BLUE}📦 正在安装traceroute...${NC}"
            progress_bar 2
            if [ -f /usr/bin/apt ]; then
                sudo apt install -y traceroute
            elif [ -f /usr/bin/yum ]; then
                sudo yum install -y traceroute
            else
                echo -e "${RED}❌ 无法自动安装traceroute${NC}"
                read -p "⏎ 按回车键返回..." dummy
                network_tools
                return
            fi
        else
            read -p "⏎ 按回车键返回..." dummy
            network_tools
            return
        fi
    fi
    
    read -p "🎯 请输入要追踪的地址(默认: www.baidu.com): " address
    address=${address:-"www.baidu.com"}
    
    echo -e "${CYAN}🔍 正在追踪路由到 ${address} ...${NC}"
    separator "─" "$BLUE"
    
    traceroute $address | while read line; do
        if [[ $line == *"ms"* ]]; then
            echo -e "  ${GREEN}🟢 $line${NC}"
        else
            echo -e "  ${GRAY}⚪ $line${NC}"
        fi
    done
    
    gradient_border
    read -p "⏎ 按回车键返回..." dummy
    network_tools
}

# 🚀 网速测试 - 增强质感版
function speed_test() {
    show_header
    echo -e "${GOLD}🚀 ====== 网速测试 ======${NC}"
    gradient_border
    
    if ! command -v speedtest-cli &>/dev/null; then
        echo -e "${RED}❌ speedtest-cli未安装${NC}"
        echo -e "${YELLOW}💡 是否立即安装? [Y/n]${NC}"
        read install_choice
        if [[ ! "$install_choice" =~ ^[Nn]$ ]]; then
            echo -e "${BLUE}📦 正在安装speedtest-cli...${NC}"
            progress_bar 2
            if [ -f /usr/bin/apt ]; then
                sudo apt install -y speedtest-cli
            elif [ -f /usr/bin/yum ]; then
                sudo yum install -y speedtest-cli
            else
                echo -e "${RED}❌ 无法自动安装speedtest-cli${NC}"
                read -p "⏎ 按回车键返回..." dummy
                network_tools
                return
            fi
        else
            read -p "⏎ 按回车键返回..." dummy
            network_tools
            return
        fi
    fi
    
    echo -e "${CYAN}🌐 正在测试网速，请稍候...${NC}"
    separator "─" "$BLUE"
    
    # 执行网速测试
    speedtest-cli --simple | while read line; do
        if [[ $line == *"Ping"* ]]; then
            echo -e "  ${GREEN}🏓 $line${NC}"
        elif [[ $line == *"Download"* ]]; then
            echo -e "  ${BLUE}⬇️  $line${NC}"
        elif [[ $line == *"Upload"* ]]; then
            echo -e "  ${CYAN}⬆️  $line${NC}"
        fi
    done
    
    # 网速评价
    separator "─" "$GREEN"
    echo -e "${YELLOW}💡 网速评价:${NC}"
    echo -e "  ${GREEN}✅ 优秀: 下载 > 100 Mbps${NC}"
    echo -e "  ${YELLOW}⚠️  一般: 下载 20-100 Mbps${NC}"
    echo -e "  ${RED}❌ 较差: 下载 < 20 Mbps${NC}"
    
    gradient_border
    read -p "⏎ 按回车键返回..." dummy
    network_tools
}

# 📊 网络信息查看
function network_info() {
    show_header
    echo -e "${GOLD}📊 ====== 网络信息查看 ======${NC}"
    gradient_border
    
    echo -e "${CYAN}🌐 网络接口信息:${NC}"
    separator "─" "$BLUE"
    ip addr show | grep -E "inet|ether" | while read line; do
        echo -e "  ${GREEN}🔗 $line${NC}"
    done
    
    echo -e "${CYAN}📡 路由表信息:${NC}"
    separator "─" "$BLUE"
    ip route | head -10 | while read line; do
        echo -e "  ${BLUE}🛣️  $line${NC}"
    done
    
    echo -e "${CYAN}🔗 当前连接:${NC}"
    separator "─" "$BLUE"
    ss -tuln | head -10 | while read line; do
        echo -e "  ${PURPLE}🔌 $line${NC}"
    done
    
    gradient_border
    read -p "⏎ 按回车键返回..." dummy
    network_tools
}

# 🔌 端口测试 - 新增实现
function port_test() {
    show_header
    echo -e "${GOLD}🔌 ====== 端口测试 ======${NC}"
    gradient_border
    read -p "🎯 请输入目标地址(默认: 127.0.0.1): " address
    address=${address:-"127.0.0.1"}
    read -p "🎯 请输入要测试的端口(如: 80 443 22 或范围如 1-1000): " port

    echo -e "${CYAN}🔄 正在测试 ${address} 的端口 ${port} ...${NC}"
    separator "─" "$BLUE"

    if [[ "$port" == *-* ]]; then
        local start_p=${port%-*}
        local end_p=${port#*-}
        for ((p=start_p; p<=end_p; p++)); do
            (timeout 1 bash -c "echo > /dev/tcp/$address/$p") 2>/dev/null && \
                echo -e "  ${GREEN}✅ 端口 $p 开放${NC}"
        done
    else
        for p in $port; do
            if (timeout 2 bash -c "echo > /dev/tcp/$address/$p") 2>/dev/null; then
                echo -e "  ${GREEN}✅ 端口 $p 开放${NC}"
            else
                echo -e "  ${RED}❌ 端口 $p 关闭或不可达${NC}"
            fi
        done
    fi

    gradient_border
    read -p "⏎ 按回车键返回..." dummy
    network_tools
}

# 🌍 HTTP状态测试 - 新增实现
function http_test() {
    show_header
    echo -e "${GOLD}🌍 ====== HTTP状态测试 ======${NC}"
    gradient_border
    read -p "🎯 请输入要检测的网址(如: https://www.xzyun.sbs): " url

    echo -e "${CYAN}🔄 正在检测 ${url} ...${NC}"
    separator "─" "$BLUE"

    local start_ts=$(date +%s%N)
    local http_code=$(curl -o /dev/null -s -m 10 -w "%{http_code}" "$url")
    local end_ts=$(date +%s%N)
    local elapsed_ms=$(( (end_ts - start_ts) / 1000000 ))

    if [ -z "$http_code" ] || [ "$http_code" = "000" ]; then
        echo -e "  ${RED}❌ 无法连接到目标地址${NC}"
    elif [[ "$http_code" =~ ^2 ]]; then
        echo -e "  ${GREEN}✅ HTTP状态码: $http_code (正常)${NC}"
    elif [[ "$http_code" =~ ^3 ]]; then
        echo -e "  ${YELLOW}↪️  HTTP状态码: $http_code (重定向)${NC}"
    else
        echo -e "  ${RED}⚠️  HTTP状态码: $http_code (异常)${NC}"
    fi
    echo -e "  ${CYAN}⏱️  响应耗时: ${elapsed_ms} ms${NC}"

    gradient_border
    read -p "⏎ 按回车键返回..." dummy
    network_tools
}
