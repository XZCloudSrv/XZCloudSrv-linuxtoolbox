#!/bin/bash
# ============================================================
# 模块: menu.sh —— 欢迎动画 / 标题头 / 主菜单
# 说明: 全部菜单文案集中在本模块，加载器(xzyun-tool.sh)本身不含任何菜单数据
# 小战云Linux超级工具箱
# ============================================================

# 🎪 欢迎动画
function welcome_animation() {
    clear
    echo -e "\n\n"
    animate_text "🚀 欢迎使用小战云Linux超级工具箱" "$GOLD" 0.05
    sleep 0.5
    animate_text "✨ 版本 v$TOOLBOX_VERSION - 强大 · 高效 · 安全" "$CYAN" 0.03
    sleep 0.5
    echo -e "\n"
    gradient_border
    sleep 1
}

# 🎪 显示炫酷标题 - 终极质感增强版
function show_header() {
    clear
    # 🎨 定义高阶配色
    local PURPLE="\033[1;38;5;135m"    # 深紫（带光泽）
    local CYAN="\033[1;38;5;80m"      # 墨青（高级冷色）
    local GREEN="\033[1;38;5;76m"     # 祖母绿（低饱和不刺眼）
    local YELLOW="\033[1;38;5;220m"   # 香槟金
    local BLUE="\033[1;38;5;69m"      # 藏蓝（沉稳）
    local ORANGE="\033[1;38;5;208m"   # 橙黄色
    local GOLD="\033[1;38;5;178m"     # 金色
    local NC="\033[0m"                # 重置

    # 📏 动态居中
    local term_width=$(tput cols)
    local header=(
        '$$$$$$$$\  $$$$$$\  $$\     $$\ $$\   $$\ $$\   $$\'
        '\____$$  |$$  __$$\ \$$\   $$  |$$ |  $$ |$$$\  $$ |'
        '    $$  / $$ /  \__| \$$\ $$  / $$ |  $$ |$$$$\ $$ |'
        '   $$  /  $$ |        \$$$$  /  $$ |  $$ |$$ $$\$$ |'
        '  $$  /   $$ |         \$$  /   $$ |  $$ |$$ \$$$$ |'
        ' $$  /    $$ |  $$\     $$ |    $$ |  $$ |$$ |\$$$ |'
        '$$$$$$$$\\$$$$$$   |   $$ |    \$$$$$$  |$$ | \$$ |'
        '\________|   \______/      \__|     \______/ \__|  \__|'
    )

    # 🎬 显示加载动画
    echo -e "\n\n"
    echo -ne "${CYAN}🚀 正在加载小战云工具箱"
    for i in {1..3}; do
        echo -ne "."
        sleep 0.2
    done
    echo -e "${NC}\n"

    # ✨ 输出带动画的ASCII标题
    for line in "${header[@]}"; do
        local line_len=$(echo -n "$line" | sed 's/\\\[.*?\\\]//g' | wc -m)
        local pad=$(( (term_width - line_len) / 2 ))
        # 阴影层
        printf "%${pad}s\033[2;38;5;240m%s\033[0m\n" " " "$line"
        # 主标题层（带颜色渐变）
        printf "%${pad}s${PURPLE}%s${NC}\n" "" "$line"
        sleep 0.03  # 逐行显示动画
    done

    # 🎨 质感边框与信息区
    local border_len=$(( term_width - 12 ))
    local border_top="╭$(printf '─%.0s' $(seq 1 $border_len))╮"
    local border_bottom="╰$(printf '─%.0s' $(seq 1 $border_len))╯"

    echo -e "\n${CYAN}${border_top}${NC}"

    # 🎯 标题文字居中（带闪烁效果）
    local tool_title="小战云Linux超级工具箱 v$TOOLBOX_VERSION - 强大 · 高效 · 安全"
    local title_len=$(echo -n "$tool_title" | wc -m)
    local title_pad=$(( (border_len - title_len) / 2 ))

    echo -ne "${CYAN}│${NC}$(printf ' %.0s' $(seq 1 $title_pad))"
    animate_text "$tool_title" "$GREEN" 0.02
    echo -e "${CYAN}│${NC}"
    echo -e "${CYAN}${border_bottom}${NC}\n"

    # 🌐 链接与状态区
    local link_prefix=$(printf ' %.0s' $(seq 1 $(( (term_width - 56) / 2 )) ))
    echo -e "${link_prefix}${YELLOW}🌐 官网: ${CYAN}https://xzy.xzyun.sbs/tools/${NC}"
    echo -e "${link_prefix}${YELLOW}🚦 当前线路: ${CYAN}$(get_current_line_name)${NC}\n"

    # 🔧 运行模式提示
    local mode_prefix=$(printf ' %.0s' $(seq 1 $(( (term_width - 42) / 2 )) ))
    if $INSTALLED; then
        echo -e "${mode_prefix}${BLUE}🔧 运行模式: ${GREEN}已安装 (使用命令: xzyun-tool)${NC}"
    else
        echo -e "${mode_prefix}${ORANGE}⚡ 运行模式: ${YELLOW}直接运行${NC}"
    fi

    # 📏 底部分割线（渐变效果）
    echo -e "\n"
    gradient_border
    echo
}

# 🏠 主菜单 - 终极质感增强版
main_menu() {
    show_header
    echo -e "${GREEN}🚀 1. 系统信息监控${NC}      ${GRAY}► 查看硬件和系统状态${NC}"
    echo -e "${BLUE}🔧 2. 高级系统工具${NC}      ${GRAY}► 清理、服务、用户管理${NC}"
    echo -e "${CYAN}🌐 3. 网络测试工具${NC}      ${GRAY}► 测速、端口、连通性${NC}"
    echo -e "${YELLOW}⚡ 4. 一键换源加速${NC}      ${GRAY}► 更换软件源提升速度${NC}"
    echo -e "${RED}🛡️ 5. 安全加固设置${NC}      ${GRAY}► SSH、防火墙、密码策略${NC}"
    echo -e "${PURPLE}🐳 6. Docker管理${NC}       ${GRAY}► 容器和镜像管理${NC}"
    echo -e "${ORANGE}⏰ 7. 定时任务管理${NC}      ${GRAY}► Cron任务管理${NC}"
    echo -e "${PINK}🎛️ 8. 面板安装${NC}         ${GRAY}► 宝塔、LNMP等面板${NC}"
    echo -e "${GOLD}🔄 9. 检查更新${NC}         ${GRAY}► 获取最新版本${NC}"
    echo -e "${GREEN}📦 10. 安装/卸载工具箱${NC}  ${GRAY}► 系统级安装${NC}"
    echo -e "${BLUE}⚙️  11. 自动检测更新设置${NC} ${GRAY}► 更新偏好设置${NC}"
    echo -e "${CYAN}🚦 12. 线路设置${NC}         ${GRAY}► 切换官方/GitHub/Gitee${NC}"
    echo -e "${RED}🚪 0. 退出${NC}             ${GRAY}► 退出工具箱${NC}"

    separator "━" "$CYAN"

    read -p "🎯 请输入选项 [0-12]: " choice

    case $choice in
        1) run_module "system_monitor" system_monitor ;;
        2) run_module "advanced_tools" advanced_tools ;;
        3) run_module "network_tools" network_tools ;;
        4) run_module "advanced_tools" change_source ;;
        5) run_module "security" security_harden ;;
        6) run_module "docker" docker_management ;;
        7) run_module "cron" cron_management ;;
        8) run_module "panel" panel_installation ;;
        9) run_module "update" manual_update_check; read -p "⏎ 按任意键继续..." -n1; main_menu ;;
        10) run_module "install_uninstall" install_menu ;;
        11) run_module "update" update_settings_menu; main_menu ;;
        12) run_module "line_settings" line_settings_menu; main_menu ;;
        0)
            echo -e "\n${CYAN}💫 感谢使用小战云Linux超级工具箱！${NC}"
            animate_text "👋 期待再次为您服务..." "$GOLD" 0.05
            progress_bar 1
            echo -e "${GRAY}🌐 官网: https://xzy.xzyun.sbs/tools/${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}❌ 无效选项，请重新输入${NC}"
            sleep 1
            main_menu
            ;;
    esac
}
