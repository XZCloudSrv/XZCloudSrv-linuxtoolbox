#!/bin/bash
# ============================================================
# 模块: update.sh —— 版本检查 / 自动更新 / 更新设置菜单
# 说明: 依赖加载器(xzyun-tool.sh)提供的 fetch_manifest / get_manifest_field /
#       CONFIG_FILE / TOOLBOX_VERSION / CACHE_DIR 等全局函数与变量
# 小战云Linux超级工具箱
# ============================================================

# ⚖️ 版本比较（与原版一致）
version_gt() {
    [ "$1" = "$2" ] && return 1
    [ "$(printf '%s\n' "$1" "$2" | sort -V | head -n1)" != "$1" ]
}

# 🌐 获取远程版本信息（重新拉取最新清单并读取 toolbox_version / changelog）
# 注意: 本函数的 stdout 会被调用方通过 `read < <(fetch_remote_version)` 解析，
#       因此这里绝不能调用任何会向 stdout 打印动画/进度的函数(如 loading_animation)，
#       否则动画帧会被当成一整行数据吞掉，导致解析出错。
fetch_remote_version() {
    if ! fetch_manifest "force"; then
        return 1
    fi
    local remote_version=$(get_manifest_field "toolbox_version")
    local changelog=$(get_manifest_field "changelog")
    [ -z "$remote_version" ] && return 1
    echo "$remote_version|$changelog"
}

# 🚀 执行更新 - 更新加载器本身 + 清空模块缓存以拉取最新模块
perform_update() {
    echo -e "${YELLOW}🔄 正在下载更新...${NC}"
    progress_bar 2

    local new_loader_url="${CURRENT_BASE_URL}/xzyun-tool.sh"
    if ! curl -fsS "$new_loader_url" -o "/tmp/xzyun-tool-new.sh"; then
        echo -e "${RED}❌ 更新下载失败${NC}"
        echo -e "${GRAY}💡 提示: 请检查网络连接或稍后重试${NC}"
        return 1
    fi
    chmod +x "/tmp/xzyun-tool-new.sh"

    echo -e "${CYAN}🎯 正在应用更新...${NC}"
    progress_bar 1

    # 清空模块缓存，确保重启后拉取与新版本匹配的模块
    rm -f "$CACHE_DIR"/*.sh "$CACHE_DIR"/.*.ver 2>/dev/null

    if $INSTALLED; then
        sudo mv "/tmp/xzyun-tool-new.sh" "$(which xzyun-tool)"
        echo -e "\n"
        blink_text "🎉 更新成功！请重新启动工具箱" "$GREEN" "$YELLOW" 3
        echo -e "${GRAY}💫 新版本功能已就绪，重启后即可体验${NC}"
    else
        mv "/tmp/xzyun-tool-new.sh" "$0" 2>/dev/null || cp "/tmp/xzyun-tool-new.sh" "./xzyun-tool.sh"
        echo -e "\n"
        blink_text "🎉 更新成功！请重新运行脚本" "$GREEN" "$YELLOW" 3
        echo -e "${GRAY}🚀 重新执行脚本以体验新功能${NC}"
    fi

    separator "─" "$GRAY"
    echo -e "${CYAN}⏰ 3秒后自动退出...${NC}"
    sleep 3
    exit 0
}

# 🔄 自动更新检查（启动时静默触发）
auto_update_check() {
    get_config
    [ "$auto_update" = "false" ] && return

    echo -e "${CYAN}🔍 检查更新中...${NC}"
    progress_bar 1

    if ! IFS='|' read -r remote_version changelog < <(fetch_remote_version); then
        echo -e "${RED}❌ 检查更新失败（无法获取版本信息）${NC}" >&2
        echo -e "${GRAY}🌐 请检查网络连接或稍后重试，或到「线路设置」切换线路${NC}"
        return
    fi

    if version_gt "$remote_version" "$TOOLBOX_VERSION"; then
        separator "─" "$YELLOW"
        echo -e "${YELLOW}🎯 发现新版本 v$remote_version${NC}"
        echo -e "${GRAY}📅 当前版本: v$TOOLBOX_VERSION${NC}"
        separator "─" "$YELLOW"

        echo -e "${CYAN}📝 更新内容:${NC}"
        echo -e "${GREEN}$(tr ',' '\n' <<< "$changelog" | sed 's/^/   ✨ /')${NC}"
        separator "─" "$GRAY"

        while true; do
            echo -e "${BLUE}💭 是否立即更新? ${NC}"
            echo -e "   ${GREEN}[Y] 是的，立即更新${NC}"
            echo -e "   ${RED}[N] 不，暂不更新${NC}"
            echo -e "   ${YELLOW}[S] 跳过，并永久暂停自动更新${NC}"
            read -p "🎯 请选择 [Y/n/s]: " choice

            case "$choice" in
                [Nn]*)
                    echo -e "${YELLOW}⏸️ 已跳过本次更新${NC}"
                    return
                    ;;
                [Ss]*)
                    set_config_value "auto_update" "false"
                    blink_text "⏸️ 已永久暂停自动更新" "$YELLOW" "$GRAY" 2
                    echo -e "${GRAY}💡 您仍可在设置中手动检查更新${NC}"
                    return
                    ;;
                *)
                    perform_update
                    break
                    ;;
            esac
        done
    else
        echo -e "${GREEN}✅ 当前已是最新版本 (v$TOOLBOX_VERSION)${NC}"
    fi
}

# 🔍 手动更新检查
manual_update_check() {
    echo -e "${CYAN}🔍 正在检查更新...${NC}"
    progress_bar 2

    if ! IFS='|' read -r remote_version changelog < <(fetch_remote_version); then
        echo -e "${RED}❌ 检查更新失败（无法连接服务器）${NC}"
        echo -e "${GRAY}🌐 请检查:"
        echo -e "   • 网络连接是否正常"
        echo -e "   • 防火墙设置"
        echo -e "   • 或到「线路设置」切换到其他线路重试${NC}"
        return 1
    fi

    if version_gt "$remote_version" "$TOOLBOX_VERSION"; then
        separator "━" "$GOLD"
        echo -e "${GOLD}🎉 发现新版本！${NC}"
        echo -e "${CYAN}📦 当前版本: v$TOOLBOX_VERSION${NC}"
        echo -e "${GREEN}🚀 最新版本: v$remote_version${NC}"
        separator "━" "$GOLD"

        echo -e "${YELLOW}📝 更新内容:${NC}"
        echo -e "${GREEN}$(tr ',' '\n' <<< "$changelog" | sed 's/^/   ✨ /')${NC}"
        separator "─" "$GRAY"

        read -p "🎯 是否更新到最新版? [Y/n] " choice
        if [[ ! "$choice" =~ ^[Nn] ]]; then
            perform_update
        else
            echo -e "${YELLOW}⏸️ 已取消更新${NC}"
        fi
    else
        echo -e "\n"
        blink_text "✅ 恭喜！当前已是最新版本 (v$TOOLBOX_VERSION)" "$GREEN" "$CYAN" 2
        separator "─" "$GREEN"
        echo -e "${GRAY}💫 您正在使用最新最稳定的版本${NC}"
    fi
}

# ⚙️ 更新设置菜单
update_settings_menu() {
    while true; do
        show_header
        get_config

        echo -e "${CYAN}🔄 === 更新设置 ===${NC}"
        gradient_border
        echo -e "1. ${GREEN}📊${NC} 自动更新状态: [${auto_update}]"
        echo -e "2. ${BLUE}🔄${NC} 切换自动更新设置"
        echo -e "3. ${YELLOW}🔍${NC} 立即检查更新"
        echo -e "4. ${RED}↩️${NC} 返回主菜单"
        gradient_border

        read -p "🎯 请选择 [1-4]: " choice
        case $choice in
            1)
                separator "─" "$BLUE"
                echo -e "${GREEN}📊 当前自动更新设置: ${NC}"
                if [ "$auto_update" = "true" ]; then
                    echo -e "   ${GREEN}✅ 已启用 - 工具箱会自动检查并提示更新${NC}"
                else
                    echo -e "   ${YELLOW}❌ 已禁用 - 需要手动检查更新${NC}"
                fi
                separator "─" "$BLUE"
                read -p "⏎ 按任意键继续..." -n1
                ;;
            2)
                if [ "$auto_update" = "true" ]; then
                    set_config_value "auto_update" "false"
                    blink_text "🔕 已禁用自动更新" "$YELLOW" "$GRAY" 2
                    echo -e "${GRAY}💡 您仍可手动检查更新${NC}"
                else
                    set_config_value "auto_update" "true"
                    blink_text "🔔 已启用自动更新" "$GREEN" "$CYAN" 2
                    echo -e "${GRAY}💫 工具箱将在启动时自动检查更新${NC}"
                fi
                sleep 1
                ;;
            3)
                manual_update_check
                read -p "⏎ 按任意键继续..." -n1
                ;;
            4)
                echo -e "${CYAN}↩️ 返回主菜单...${NC}"
                sleep 0.5
                return
                ;;
            *)
                echo -e "${RED}❌ 无效选项，请重新输入${NC}"
                sleep 1
                ;;
        esac
    done
}
