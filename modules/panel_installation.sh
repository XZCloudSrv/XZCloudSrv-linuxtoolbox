#!/bin/bash

if [ -f "${TOOLBOX_DIR}/common.sh" ]; then
    source "${TOOLBOX_DIR}/common.sh"
fi

panel_installation() {
    show_header
    echo -e "${GOLD}🎛️ ====== 面板安装 ======${NC}"
    gradient_border
    echo -e "${GREEN}🛑 1. 安装宝塔面板${NC}      ${GRAY}► 国产强大服务器面板${NC}"
    echo -e "${BLUE}🐘 2. 安装LNMP环境${NC}       ${GRAY}► Nginx+MySQL+PHP${NC}"
    echo -e "${CYAN}🔴 3. 安装LAMP环境${NC}       ${GRAY}► Apache+MySQL+PHP${NC}"
    echo -e "${YELLOW}🛩️  4. 安装Cockpit${NC}      ${GRAY}► 轻量级Web控制台${NC}"
    echo -e "${PURPLE}🌐 5. 安装Webmin${NC}        ${GRAY}► 经典Web管理界面${NC}"
    echo -e "${ORANGE}📊 6. 安装1Panel${NC}        ${GRAY}► 现代化运维面板${NC}"
    echo -e "${RED}↩️  7. 返回主菜单${NC}        ${GRAY}► 返回主界面${NC}"
    gradient_border
    
    read -p "🎯 请输入选项 [1-7]: " choice
    
    case $choice in
        1) install_bt_panel ;;
        2) install_lnmp ;;
        3) install_lamp ;;
        4) install_cockpit ;;
        5) install_webmin ;;
        6) install_1panel ;;
        7) main_menu ;;
        *) 
            echo -e "${RED}❌ 无效选项，请重新输入${NC}"
            sleep 1
            panel_installation 
            ;;
    esac
}

# 🛑 安装宝塔面板 - 增强质感版
install_bt_panel() {
    show_header
    echo -e "${GOLD}🛑 ====== 安装宝塔面板 ======${NC}"
    gradient_border
    
    echo -e "${YELLOW}⚠️  注意: 宝塔面板将占用8888端口${NC}"
    echo -e "${GRAY}💡 建议: 确保端口未被占用，或准备修改默认端口${NC}"
    separator "─" "$YELLOW"
    
    read -p "🎯 是否继续安装? [Y/n]: " confirm
    if [[ "$confirm" =~ ^[Nn] ]]; then
        echo -e "${YELLOW}⏸️ 已取消安装${NC}"
        sleep 1
        panel_installation
        return
    fi
    
    echo -e "${BLUE}📦 检测系统类型...${NC}"
    if [ -f /usr/bin/apt ]; then
        echo -e "${GREEN}✅ 检测到Debian/Ubuntu系统${NC}"
        echo -e "${BLUE}📥 下载安装脚本...${NC}"
        progress_bar 2
        wget -O install.sh http://download.bt.cn/install/install-ubuntu_6.0.sh && sudo bash install.sh
    elif [ -f /usr/bin/yum ]; then
        echo -e "${GREEN}✅ 检测到CentOS/RHEL系统${NC}"
        echo -e "${BLUE}📥 下载安装脚本...${NC}"
        progress_bar 2
        yum install -y wget && wget -O install.sh http://download.bt.cn/install/install_6.0.sh && sudo bash install.sh
    else
        echo -e "${RED}❌ 无法确定系统类型${NC}"
        echo -e "${GRAY}💡 请手动访问: https://www.bt.cn/download/linux.html${NC}"
    fi
    
    separator "━" "$GREEN"
    echo -e "${GREEN}🎉 宝塔面板安装完成！${NC}"
    echo -e "${YELLOW}💡 安装完成后请使用浏览器访问:${NC}"
    echo -e "  🌐 面板地址: http://服务器IP:8888"
    echo -e "  🔑 初始账号: 安装完成后终端显示"
    echo -e "  🔒 安全提示: 首次登录后立即修改密码"
    
    gradient_border
    read -p "⏎ 按回车键返回..." dummy
    panel_installation
}

# 🐘 安装LNMP环境 - 增强质感版
install_lnmp() {
    show_header
    echo -e "${GOLD}🐘 ====== 安装LNMP环境 ======${NC}"
    gradient_border
    
    echo -e "${YELLOW}⚠️  注意: LNMP将安装Nginx+MySQL+PHP${NC}"
    echo -e "${GRAY}💡 建议: 确保系统有足够磁盘空间(至少2GB)${NC}"
    separator "─" "$YELLOW"
    
    read -p "🎯 是否继续安装? [Y/n]: " confirm
    if [[ "$confirm" =~ ^[Nn] ]]; then
        echo -e "${YELLOW}⏸️ 已取消安装${NC}"
        sleep 1
        panel_installation
        return
    fi
    
    echo -e "${BLUE}📦 下载LNMP安装包...${NC}"
    progress_bar 2
    wget http://soft.vpser.net/lnmp/lnmp1.8.tar.gz -O lnmp1.8.tar.gz
    
    echo -e "${BLUE}📂 解压安装包...${NC}"
    tar zxf lnmp1.8.tar.gz
    
    echo -e "${BLUE}⚡ 开始安装LNMP...${NC}"
    echo -e "${YELLOW}💡 安装过程较长时间，请耐心等待...${NC}"
    cd lnmp1.8 && sudo ./install.sh lnmp
    
    separator "━" "$GREEN"
    echo -e "${GREEN}🎉 LNMP环境安装完成！${NC}"
    echo -e "${CYAN}📊 默认安装信息:${NC}"
    echo -e "  🌐 Nginx端口: 80"
    echo -e "  🗄️  MySQL端口: 3306"
    echo -e "  🐘 PHP版本: 7.4+"
    echo -e "  📁 网站目录: /home/wwwroot/"
    
    gradient_border
    read -p "⏎ 按回车键返回..." dummy
    panel_installation
}

# 🛩️ 安装Cockpit - 增强质感版
install_cockpit() {
    show_header
    echo -e "${GOLD}🛩️ ====== 安装Cockpit ======${NC}"
    gradient_border
    
    echo -e "${YELLOW}💡 Cockpit: 轻量级服务器Web控制台${NC}"
    echo -e "${GRAY}✨ 特点: 系统监控、容器管理、服务管理${NC}"
    separator "─" "$YELLOW"
    
    read -p "🎯 是否继续安装? [Y/n]: " confirm
    if [[ "$confirm" =~ ^[Nn] ]]; then
        echo -e "${YELLOW}⏸️ 已取消安装${NC}"
        sleep 1
        panel_installation
        return
    fi
    
    echo -e "${BLUE}📦 安装Cockpit...${NC}"
    progress_bar 2
    
    if [ -f /usr/bin/apt ]; then
        echo -e "${GREEN}✅ Debian/Ubuntu系统安装${NC}"
        sudo apt-get update
        sudo apt-get install -y cockpit
    elif [ -f /usr/bin/yum ]; then
        echo -e "${GREEN}✅ CentOS/RHEL系统安装${NC}"
        sudo yum install -y cockpit
        sudo systemctl enable --now cockpit.socket
        sudo firewall-cmd --permanent --add-service=cockpit
        sudo firewall-cmd --reload
    fi
    
    separator "━" "$GREEN"
    echo -e "${GREEN}🎉 Cockpit安装完成！${NC}"
    echo -e "${YELLOW}💡 访问信息:${NC}"
    echo -e "  🌐 访问地址: https://您的服务器地址:9090"
    echo -e "  🔐 使用系统账号密码登录"
    echo -e "  🔒 默认使用HTTPS安全连接"
    
    gradient_border
    read -p "⏎ 按回车键返回..." dummy
    panel_installation
}

# 📊 安装1Panel - 增强质感版
install_1panel() {
    show_header
    echo -e "${GOLD}📊 ====== 安装1Panel ======${NC}"
    gradient_border
    
    echo -e "${YELLOW}💡 1Panel: 现代化开源服务器面板${NC}"
    echo -e "${GRAY}✨ 特点: 容器化、安全、易用${NC}"
    separator "─" "$YELLOW"
    
    read -p "🎯 是否继续安装? [Y/n]: " confirm
    if [[ "$confirm" =~ ^[Nn] ]]; then
        echo -e "${YELLOW}⏸️ 已取消安装${NC}"
        sleep 1
        panel_installation
        return
    fi
    
    echo -e "${BLUE}📦 安装1Panel...${NC}"
    progress_bar 3
    
    # 使用官方安装脚本
    curl -sSL https://resource.fit2cloud.com/1panel/package/quick_start.sh -o quick_start.sh
    sudo bash quick_start.sh
    
    separator "━" "$GREEN"
    echo -e "${GREEN}🎉 1Panel安装完成！${NC}"
    echo -e "${YELLOW}💡 访问信息:${NC}"
    echo -e "  🌐 访问地址: http://服务器IP:10080"
    echo -e "  🔑 初始账号: 安装完成后终端显示"
    echo -e "  🔒 安全提示: 首次登录后立即修改密码"
    
    gradient_border
    read -p "⏎ 按回车键返回..." dummy
    panel_installation
}


panel_installation
