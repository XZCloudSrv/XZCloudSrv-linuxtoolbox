#!/bin/bash
# ============================================================
# 模块: system_monitor.sh —— 系统信息监控
# 小战云Linux超级工具箱
# ============================================================

# 📊 系统监控功能 - 终极质感增强版
function system_monitor() {
    show_header
    echo -e "${GOLD}📊 ====== 系统信息监控 ======${NC}"
    gradient_border
    echo -e "${GRAY}💫 正在收集系统信息，请稍候...${NC}"
    echo
    
    # 🖥️ CPU信息
    echo -e "${CYAN}🖥️ === CPU信息 ===${NC}"
    separator "─" "$BLUE"
    lscpu | grep -E "Model name|Architecture|CPU\(s\)|Thread|MHz" | while read line; do
        echo -e "  ${GREEN}📌 ${line}${NC}"
    done
    echo
    
    # 💾 内存信息
    echo -e "${CYAN}💾 === 内存信息 ===${NC}"
    separator "─" "$BLUE"
    free -h | while read line; do
        if [[ $line == *"Mem"* ]] || [[ $line == *"Swap"* ]]; then
            echo -e "  ${BLUE}💿 ${line}${NC}"
        else
            echo -e "  ${GRAY}📋 ${line}${NC}"
        fi
    done
    echo
    
    # 💽 磁盘信息
    echo -e "${CYAN}💽 === 磁盘信息 ===${NC}"
    separator "─" "$BLUE"
    df -h | head -n 1 | while read line; do
        echo -e "  ${PURPLE}🗂️ ${line}${NC}"
    done
    df -h | tail -n +2 | while read line; do
        if [[ $line == *"%"* ]]; then
            usage=$(echo "$line" | awk '{print $5}' | tr -d '%')
            if [ "$usage" -gt 90 ]; then
                echo -e "  ${RED}⚠️  ${line}${NC}"
            elif [ "$usage" -gt 80 ]; then
                echo -e "  ${YELLOW}📈 ${line}${NC}"
            else
                echo -e "  ${GREEN}✅ ${line}${NC}"
            fi
        fi
    done
    echo
    
    # 📈 系统负载
    echo -e "${CYAN}📈 === 系统负载 ===${NC}"
    separator "─" "$BLUE"
    local load=$(uptime | sed 's/^.*load average: //')
    echo -e "  ${ORANGE}🔥 负载情况: ${load}${NC}"
    uptime | sed "s/^/  📅 /"
    echo
    
    # 🔄 进程占用
    echo -e "${CYAN}🔄 === 进程占用TOP5 ===${NC}"
    separator "─" "$BLUE"
    echo -e "  ${GRAY}PID\tPPID\tCPU%\tMEM%\t命令${NC}"
    ps -eo pid,ppid,%cpu,%mem,cmd --sort=-%cpu | head -n 6 | tail -n +2 | while read line; do
        echo -e "  ${CYAN}⚡ ${line}${NC}"
    done
    echo
    
    # 🌡️ 系统温度（如果可用）
    if command -v sensors &>/dev/null; then
        echo -e "${CYAN}🌡️ === 硬件温度 ===${NC}"
        separator "─" "$BLUE"
        sensors | grep -E "Core|temp" | head -n 3 | while read line; do
            echo -e "  ${RED}🔥 ${line}${NC}"
        done
        echo
    fi
    
    # 🕐 运行时间
    echo -e "${CYAN}🕐 === 系统运行时间 ===${NC}"
    separator "─" "$BLUE"
    echo -e "  ${GREEN}⏱️ $(uptime -p)${NC}"
    
    gradient_border
    echo -e "${YELLOW}💡 提示: 按回车键返回主菜单${NC}"
    read -p "⏎ " dummy
    main_menu
}
