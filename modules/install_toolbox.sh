#!/bin/bash

if [ -f "${TOOLBOX_DIR}/common.sh" ]; then
    source "${TOOLBOX_DIR}/common.sh"
fi

function install_menu() {
    show_header
    if $INSTALLED; then
        echo -e "${GOLD}📦 ====== 工具箱已安装 ======${NC}"
        gradient_border
        echo -e "${GREEN}✅ 当前状态: 已安装${NC}"
        echo -e "${BLUE}📁 安装路径: /usr/local/bin/xzyun-tool${NC}"
        echo -e "${CYAN}⚡ 快捷命令: xzyun-tool${NC}"
        echo -e "${YELLOW}🔧 版本: v$VERSION${NC}"
        gradient_border
        
        echo -e "${RED}⚠️  卸载将移除工具箱的系统安装${NC}"
        read -p "🎯 是否卸载工具箱? [y/N]: " uninstall_choice
        if [[ "$uninstall_choice" =~ ^[Yy]$ ]]; then
            uninstall_toolbox
        else
            echo -e "${YELLOW}⏸️ 取消卸载${NC}"
            sleep 1
            main_menu
        fi
    else
        echo -e "${GOLD}📦 ====== 安装工具箱 ======${NC}"
        gradient_border
        echo -e "${GREEN}✨ 安装后将获得以下功能:${NC}"
        echo -e "  ${BLUE}✅ 系统级命令: xzyun-tool${NC}"
        echo -e "  ${CYAN}✅ 任意目录快速启动${NC}"
        echo -e "  ${YELLOW}✅ 自动更新支持${NC}"
        echo -e "  ${PURPLE}✅ 使用统计功能${NC}"
        gradient_border
        
        read -p "🎯 是否安装工具箱? [Y/n]: " install_choice
        if [[ ! "$install_choice" =~ ^[Nn]$ ]]; then
            install_toolbox
        else
            echo -e "${YELLOW}⏸️ 取消安装${NC}"
            sleep 1
            main_menu
        fi
    fi
}

# 📥 安装工具箱 - 增强质感版
function install_toolbox() {
    show_header
    echo -e "${GOLD}📥 ====== 安装工具箱 ======${NC}"
    gradient_border
    
    # 检查是否已经安装
    if [ -f /usr/local/bin/xzyun-tool ]; then
        echo -e "${RED}❌ 工具箱已经安装${NC}"
        echo -e "${YELLOW}💡 如需重新安装请先卸载${NC}"
        sleep 2
        main_menu
        return
    fi
    
    echo -e "${BLUE}📦 创建工具箱目录...${NC}"
    progress_bar 1
    mkdir -p "$TOOLBOX_DIR"
    echo "0" > "$COUNTER_FILE"
    
    echo -e "${BLUE}📥 下载工具箱脚本...${NC}"
    progress_bar 2
    curl -sL "$base_url/xzyun-tool.sh" -o /usr/local/bin/xzyun-tool
    
    echo -e "${BLUE}🔧 设置执行权限...${NC}"
    chmod +x /usr/local/bin/xzyun-tool
    
    echo -e "${BLUE}📝 更新配置...${NC}"
    echo "INSTALLED=true" > "$CONFIG_FILE"
    echo "auto_update=true" >> "$CONFIG_FILE"
    
    separator "━" "$GREEN"
    blink_text "🎉 小战云Linux超级工具箱安装成功！" "$GREEN" "$YELLOW" 3
    echo -e "${CYAN}✨ 现在您可以在任何位置使用以下命令:${NC}"
    echo -e "  ${GREEN}🚀 xzyun-tool${NC} - 启动工具箱"
    echo -e "  ${BLUE}🔧 xzyun-tool${NC} - 备用命令"
    echo -e "${YELLOW}💫 享受便捷的服务器管理体验吧！${NC}"
    
    gradient_border
    read -p "⏎ 按回车键返回主菜单..." dummy
    INSTALLED=true
    main_menu
}

# 🗑️ 卸载工具箱 - 增强质感版
function uninstall_toolbox() {
    show_header
    echo -e "${GOLD}🗑️ ====== 卸载工具箱 ======${NC}"
    gradient_border
    
    # 检查是否已安装
    if [ ! -f /usr/local/bin/xzyun-tool ]; then
        echo -e "${RED}❌ 工具箱未安装${NC}"
        echo -e "${YELLOW}💡 无需卸载${NC}"
        sleep 2
        main_menu
        return
    fi
    
    echo -e "${YELLOW}⚠️  即将卸载工具箱，此操作不可逆！${NC}"
    echo -e "${GRAY}📋 将删除以下内容:${NC}"
    echo -e "  ${RED}🗑️  /usr/local/bin/xzyun-tool${NC}"
    echo -e "  ${RED}🗑️  $TOOLBOX_DIR/${NC}"
    separator "─" "$RED"
    
    read -p "🎯 确认卸载? [y/N]: " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}⏸️ 取消卸载${NC}"
        sleep 1
        main_menu
        return
    fi
    
    echo -e "${BLUE}🗑️ 正在卸载工具箱...${NC}"
    progress_bar 2
    
    # 删除相关文件
    rm -f /usr/local/bin/xzyun-tool
    rm -rf "$TOOLBOX_DIR"
    
    separator "━" "$GREEN"
    blink_text "✅ 小战云Linux超级工具箱已成功卸载" "$GREEN" "$CYAN" 2
    echo -e "${YELLOW}💡 您仍然可以使用以下方式运行:${NC}"
    echo -e "  ${CYAN}bash <(curl -sL "$base_url/xzyun-tool.sh")${NC}"
    echo -e "${GRAY}🌟 感谢您的使用，期待再次相遇！${NC}"
    
    gradient_border
    read -p "⏎ 按回车键退出..." dummy
    INSTALLED=false
    exit 0
}


install_menu
