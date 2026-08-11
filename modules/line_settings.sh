#!/bin/bash
# ============================================================
# 模块: line_settings.sh —— 线路设置(新增功能)
# 说明: 允许用户在 官方 / GitHub(海外) / Gitee(国内) / 自动选择 之间切换
#       依赖加载器提供的 LINE / test_line_speed / get_mirror_name / set_config_value 等
# 小战云Linux超级工具箱
# ============================================================

# 🚦 线路设置菜单
function line_settings_menu() {
    show_header
    echo -e "${GOLD}🚦 ====== 线路设置 ======${NC}"
    gradient_border
    echo -e "${CYAN}当前线路: ${GREEN}$(get_current_line_name)${NC}"
    separator "─" "$GRAY"
    echo -e "${GREEN}1. 🏠 官方线路${NC}      ${GRAY}► $(get_mirror_base official)${NC}"
    echo -e "${BLUE}2. 🌍 GitHub线路(海外)${NC} ${GRAY}► $(get_mirror_base github)${NC}"
    echo -e "${CYAN}3. 🇨🇳 Gitee线路(国内)${NC}  ${GRAY}► $(get_mirror_base gitee)${NC}"
    echo -e "${YELLOW}4. 🤖 自动选择(测速优选)${NC}"
    echo -e "${PURPLE}5. 🧪 测试各线路连通性${NC}"
    echo -e "${RED}6. ↩️  返回主菜单${NC}"
    gradient_border

    read -p "🎯 请输入选项 [1-6]: " choice

    case $choice in
        1) set_line "official" ;;
        2) set_line "github" ;;
        3) set_line "gitee" ;;
        4) set_line "auto" ;;
        5) test_all_lines; read -p "⏎ 按任意键继续..." -n1; line_settings_menu; return ;;
        6) return ;;
        *)
            echo -e "${RED}❌ 无效选项，请重新输入${NC}"
            sleep 1
            line_settings_menu
            return
            ;;
    esac

    line_settings_menu
}

# ✅ 设置线路并即时生效（清空模块缓存以便按新线路重新拉取）
function set_line() {
    local line="$1"
    set_config_value "LINE" "$line"
    LINE="$line"

    echo -e "${BLUE}🔄 正在应用新线路并刷新清单...${NC}"
    progress_bar 1

    if ! fetch_manifest "force"; then
        echo -e "${RED}❌ 无法连接该线路，请检查网络或选择其他线路${NC}"
        read -p "⏎ 按任意键继续..." -n1
        return
    fi

    blink_text "✅ 线路已切换为: $(get_current_line_name)" "$GREEN" "$CYAN" 2
    read -p "⏎ 按任意键继续..." -n1
}

# 🧪 测试三条线路连通性与延迟
function test_all_lines() {
    show_header
    echo -e "${GOLD}🧪 ====== 线路连通性测试 ======${NC}"
    gradient_border

    for key in official github gitee; do
        local name=$(get_mirror_name "$key")
        local base=$(get_mirror_base "$key")
        echo -ne "${CYAN}测试 ${name} ...${NC} "
        local start_ts=$(date +%s%N)
        if curl -fsS -m 5 -o /dev/null "$base/manifest.json"; then
            local end_ts=$(date +%s%N)
            local ms=$(( (end_ts - start_ts) / 1000000 ))
            echo -e "${GREEN}✅ 可用 (${ms}ms)${NC}"
        else
            echo -e "${RED}❌ 不可达${NC}"
        fi
    done

    gradient_border
}
