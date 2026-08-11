#!/bin/bash

if [ -f "${TOOLBOX_DIR}/common.sh" ]; then
    source "${TOOLBOX_DIR}/common.sh"
fi

function security_harden() {
    show_header
    echo -e "${GOLD}🛡️ ====== 安全加固设置 ======${NC}"
    gradient_border
    echo -e "${GREEN}🔐 1. SSH安全加固${NC}       ${GRAY}► 端口、认证、权限${NC}"
    echo -e "${BLUE}🔥 2. 防火墙配置${NC}         ${GRAY}► UFW/Firewalld管理${NC}"
    echo -e "${CYAN}🔑 3. 密码策略设置${NC}       ${GRAY}► 复杂度、有效期${NC}"
    echo -e "${YELLOW}🚫 4. 禁用root登录${NC}      ${GRAY}► 增强系统安全${NC}"
    echo -e "${PURPLE}👁️  5. 安全审计${NC}         ${GRAY}► 登录日志、监控${NC}"
    echo -e "${ORANGE}📋 6. 安全检查${NC}         ${GRAY}► 系统安全状态${NC}"
    echo -e "${RED}↩️  7. 返回主菜单${NC}        ${GRAY}► 返回主界面${NC}"
    gradient_border
    
    read -p "🎯 请输入选项 [1-7]: " choice
    
    case $choice in
        1) ssh_harden ;;
        2) firewall_config ;;
        3) password_policy ;;
        4) disable_root_login ;;
        5) security_audit ;;
        6) security_check ;;
        7) main_menu ;;
        *) 
            echo -e "${RED}❌ 无效选项，请重新输入${NC}"
            sleep 1
            security_harden 
            ;;
    esac
}

# 🔐 SSH安全加固 - 增强质感版
function ssh_harden() {
    show_header
    echo -e "${GOLD}🔐 ====== SSH安全加固 ======${NC}"
    gradient_border
    
    echo -e "${YELLOW}⚠️  注意: SSH安全加固将修改SSH配置${NC}"
    echo -e "${GRAY}💡 建议在操作前备份现有配置${NC}"
    separator "─" "$YELLOW"
    
    # 备份原始配置文件
    echo -e "${BLUE}📦 正在备份SSH配置...${NC}"
    sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak.$(date +%Y%m%d)
    echo -e "${GREEN}✅ 配置已备份到: /etc/ssh/sshd_config.bak.$(date +%Y%m%d)${NC}"
    
    # 修改SSH端口
    read -p "🎯 是否要修改SSH端口(默认22)? [y/N]: " change_port
    if [[ "$change_port" =~ ^[Yy]$ ]]; then
        read -p "🎯 请输入新的SSH端口(1024-65535): " new_port
        sudo sed -i "s/^#Port 22/Port $new_port/" /etc/ssh/sshd_config
        echo -e "${GREEN}✅ SSH端口已修改为 $new_port${NC}"
    fi
    
    # 安全设置
    echo -e "${BLUE}🔧 应用安全设置...${NC}"
    progress_bar 1
    
    # 禁用root登录
    sudo sed -i 's/^#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
    echo -e "${GREEN}✅ 已禁用root登录${NC}"
    
    # 禁用密码认证
    read -p "🎯 是否禁用密码认证(推荐使用密钥认证)? [y/N]: " disable_password
    if [[ "$disable_password" =~ ^[Yy]$ ]]; then
        sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
        echo -e "${GREEN}✅ 已禁用密码认证${NC}"
    fi
    
    # 其他安全设置
    sudo sed -i 's/^#MaxAuthTries 6/MaxAuthTries 3/' /etc/ssh/sshd_config
    sudo sed -i 's/^#ClientAliveInterval 0/ClientAliveInterval 300/' /etc/ssh/sshd_config
    sudo sed -i 's/^#ClientAliveCountMax 3/ClientAliveCountMax 2/' /etc/ssh/sshd_config
    
    # 重启SSH服务
    echo -e "${BLUE}🔄 重启SSH服务...${NC}"
    if command -v systemctl &>/dev/null; then
        sudo systemctl restart sshd
    else
        sudo service ssh restart
    fi
    
    separator "━" "$GREEN"
    echo -e "${GREEN}🎉 SSH安全加固完成!${NC}"
    echo -e "${YELLOW}💡 重要提示:${NC}"
    echo -e "  • 如果修改了SSH端口，请确保防火墙已放行新端口"
    echo -e "  • 建议使用SSH密钥认证代替密码认证"
    echo -e "  • 请测试新的SSH连接确保配置正确"
    
    gradient_border
    read -p "⏎ 按回车键返回..." dummy
    security_harden
}

# 👁️ 安全审计功能
function security_audit() {
    show_header
    echo -e "${GOLD}👁️ ====== 安全审计 ======${NC}"
    gradient_border
    
    echo -e "${CYAN}📝 最近登录记录:${NC}"
    separator "─" "$BLUE"
    last -10 | while read line; do
        echo -e "  ${GREEN}👤 $line${NC}"
    done
    
    echo -e "${CYAN}🚨 失败登录尝试:${NC}"
    separator "─" "$BLUE"
    sudo grep "Failed password" /var/log/auth.log 2>/dev/null | tail -5 | while read line; do
        echo -e "  ${RED}❌ $line${NC}"
    done
    
    echo -e "${CYAN}🔍 SSH登录统计:${NC}"
    separator "─" "$BLUE"
    sudo grep "Accepted password" /var/log/auth.log 2>/dev/null | tail -5 | while read line; do
        echo -e "  ${GREEN}✅ $line${NC}"
    done
    
    gradient_border
    read -p "⏎ 按回车键返回..." dummy
    security_harden
}

# 📋 安全检查功能
function security_check() {
    show_header
    echo -e "${GOLD}📋 ====== 安全检查 ======${NC}"
    gradient_border
    
    echo -e "${CYAN}🔍 进行安全检查...${NC}"
    progress_bar 2
    
    # 检查SSH端口
    local ssh_port=$(sudo grep "^Port" /etc/ssh/sshd_config 2>/dev/null | awk '{print $2}')
    if [ "$ssh_port" = "22" ]; then
        echo -e "  ${YELLOW}⚠️  SSH使用默认端口22${NC}"
    else
        echo -e "  ${GREEN}✅ SSH端口已修改: $ssh_port${NC}"
    fi
    
    # 检查root登录
    local root_login=$(sudo grep "^PermitRootLogin" /etc/ssh/sshd_config 2>/dev/null | tail -1)
    if [[ "$root_login" == *"yes"* ]]; then
        echo -e "  ${RED}❌ Root登录已启用${NC}"
    else
        echo -e "  ${GREEN}✅ Root登录已禁用${NC}"
    fi
    
    # 检查防火墙状态
    if command -v ufw &>/dev/null; then
        ufw status | grep -q "active" && echo -e "  ${GREEN}✅ UFW防火墙已启用${NC}" || echo -e "  ${RED}❌ UFW防火墙未启用${NC}"
    elif command -v firewall-cmd &>/dev/null; then
        firewall-cmd --state &>/dev/null && echo -e "  ${GREEN}✅ Firewalld已启用${NC}" || echo -e "  ${RED}❌ Firewalld未启用${NC}"
    else
        echo -e "  ${YELLOW}⚠️  未检测到防火墙${NC}"
    fi
    
    gradient_border
    read -p "⏎ 按回车键返回..." dummy
    security_harden
}


security_harden
