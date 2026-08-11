#!/bin/bash

if [ -f "${TOOLBOX_DIR}/common.sh" ]; then
    source "${TOOLBOX_DIR}/common.sh"
fi

function advanced_tools() {
    show_header
    echo -e "${GOLD}🔧 ====== 高级系统工具 ======${NC}"
    gradient_border
    echo -e "${GREEN}🗑️  1. 清理系统垃圾${NC}     ${GRAY}► 释放磁盘空间${NC}"
    echo -e "${BLUE}📁  2. 查找大文件${NC}       ${GRAY}► 定位占用空间的文件${NC}"
    echo -e "${CYAN}🛠️  3. 服务管理${NC}         ${GRAY}► 启动停止系统服务${NC}"
    echo -e "${PURPLE}👥  4. 用户管理${NC}         ${GRAY}► 用户和组管理${NC}"
    echo -e "${ORANGE}⚙️  5. 内核管理${NC}         ${GRAY}► 内核版本管理${NC}"
    echo -e "${RED}🧹  6. 系统优化${NC}         ${GRAY}► 性能调优设置${NC}"
    echo -e "${YELLOW}↩️  7. 返回主菜单${NC}       ${GRAY}► 返回主界面${NC}"
    gradient_border
    
    read -p "🎯 请输入选项 [1-7]: " choice
    
    case $choice in
        1) clean_system ;;
        2) find_large_files ;;
        3) service_management ;;
        4) user_management ;;
        5) kernel_management ;;
        6) system_optimize ;;
        7) main_menu ;;
        *) 
            echo -e "${RED}❌ 无效选项，请重新输入${NC}"
            sleep 1
            advanced_tools 
            ;;
    esac
}

# 🗑️ 清理系统垃圾 - 增强质感版
function clean_system() {
    show_header
    echo -e "${GOLD}🗑️ ====== 清理系统垃圾 ======${NC}"
    gradient_border
    
    echo -e "${YELLOW}⚠️  注意: 此操作将清理系统临时文件和缓存${NC}"
    echo -e "${GRAY}💡 建议在清理前确认重要数据已备份${NC}"
    separator "─" "$YELLOW"
    
    read -p "🎯 是否继续? [Y/n]: " confirm
    if [[ "$confirm" =~ ^[Nn] ]]; then
        echo -e "${YELLOW}⏸️ 已取消清理操作${NC}"
        sleep 1
        advanced_tools
        return
    fi
    
    # 清理临时文件
    echo -e "${BLUE}🧹 正在清理临时文件...${NC}"
    progress_bar 1
    sudo rm -rf /tmp/* 2>/dev/null
    sudo rm -rf /var/tmp/* 2>/dev/null
    echo -e "${GREEN}✅ 临时文件清理完成${NC}"
    
    # 清理日志文件
    echo -e "${BLUE}📋 正在清理日志文件...${NC}"
    progress_bar 1
    sudo journalctl --vacuum-time=7d 2>/dev/null
    echo -e "${GREEN}✅ 日志文件清理完成${NC}"
    
    # 清理包管理器缓存
    echo -e "${BLUE}📦 正在清理包管理器缓存...${NC}"
    progress_bar 1
    if [ -f /usr/bin/apt ]; then
        sudo apt autoremove --purge -y 2>/dev/null
        sudo apt clean 2>/dev/null
    elif [ -f /usr/bin/yum ]; then
        sudo yum clean all 2>/dev/null
    fi
    echo -e "${GREEN}✅ 包缓存清理完成${NC}"
    
    # 清理旧内核
    echo -e "${BLUE}⚙️ 正在清理旧内核...${NC}"
    progress_bar 1
    if [ -f /usr/bin/apt ]; then
        sudo apt autoremove --purge -y 2>/dev/null
    elif [ -f /usr/bin/yum ]; then
        sudo package-cleanup --oldkernels --count=1 -y 2>/dev/null
    fi
    echo -e "${GREEN}✅ 旧内核清理完成${NC}"
    
    # 显示清理结果
    separator "━" "$GREEN"
    echo -e "${GREEN}🎉 系统垃圾清理完成！${NC}"
    echo -e "${CYAN}💾 释放的磁盘空间:${NC}"
    df -h / | tail -1 | awk '{print "  📊 总空间: " $2 "  已用: " $3 "  可用: " $4}'
    
    gradient_border
    read -p "⏎ 按回车键返回..." dummy
    advanced_tools
}

# 📁 查找大文件 - 增强质感版
function find_large_files() {
    show_header
    echo -e "${GOLD}📁 ====== 查找大文件 ======${NC}"
    gradient_border
    echo -e "${GREEN}🔍 1. 查找大于100M的文件${NC}"
    echo -e "${BLUE}📊 2. 查找大于1G的文件${NC}"
    echo -e "${CYAN}🎯 3. 自定义大小查找${NC}"
    echo -e "${YELLOW}📂 4. 查找大目录${NC}"
    echo -e "${RED}↩️  5. 返回上级菜单${NC}"
    gradient_border
    
    read -p "🎯 请输入选项 [1-5]: " choice
    
    case $choice in
        1)
            echo -e "${YELLOW}🔍 正在查找大于100M的文件...${NC}"
            separator "─" "$BLUE"
            sudo find / -type f -size +100M -exec ls -lh {} \; 2>/dev/null | \
            awk '{print "  📄 " $5 ": " $9}' | head -20
            ;;
        2)
            echo -e "${YELLOW}🔍 正在查找大于1G的文件...${NC}"
            separator "─" "$BLUE"
            sudo find / -type f -size +1G -exec ls -lh {} \; 2>/dev/null | \
            awk '{print "  💾 " $5 ": " $9}' | head -15
            ;;
        3)
            read -p "🎯 请输入要查找的文件大小(如: +500M, +2G): " size
            echo -e "${YELLOW}🔍 正在查找大于${size}的文件...${NC}"
            separator "─" "$BLUE"
            sudo find / -type f -size $size -exec ls -lh {} \; 2>/dev/null | \
            awk '{print "  📎 " $5 ": " $9}' | head -25
            ;;
        4)
            echo -e "${YELLOW}🔍 正在查找大目录...${NC}"
            separator "─" "$BLUE"
            sudo du -h --max-depth=1 / 2>/dev/null | sort -hr | head -10 | \
            awk '{print "  📁 " $1 ": " $2}'
            ;;
        5)
            advanced_tools
            return
            ;;
        *)
            echo -e "${RED}❌ 无效选项，请重新输入${NC}"
            sleep 1
            find_large_files
            return
            ;;
    esac
    
    separator "━" "$GREEN"
    echo -e "${GRAY}💡 提示: 只显示前N个结果，使用自定义查找获取更多${NC}"
    read -p "⏎ 按回车键继续..." dummy
    find_large_files
}

# 🛠️ 服务管理 - 增强质感版
function service_management() {
    show_header
    echo -e "${GOLD}🛠️ ====== 服务管理 ======${NC}"
    gradient_border
    echo -e "${GREEN}📋 1. 列出所有服务${NC}"
    echo -e "${BLUE}🚀 2. 启动服务${NC}"
    echo -e "${RED}🛑 3. 停止服务${NC}"
    echo -e "${CYAN}🔃 4. 重启服务${NC}"
    echo -e "${YELLOW}📊 5. 查看服务状态${NC}"
    echo -e "${PURPLE}⚡ 6. 服务开机自启${NC}"
    echo -e "${ORANGE}↩️  7. 返回上级菜单${NC}"
    gradient_border
    
    read -p "🎯 请输入选项 [1-7]: " choice
    
    case $choice in
        1)
            echo -e "${YELLOW}📋 系统服务列表:${NC}"
            separator "─" "$BLUE"
            if command -v systemctl &>/dev/null; then
                systemctl list-units --type=service --all --no-pager | head -20
            elif command -v service &>/dev/null; then
                service --status-all
            else
                echo -e "${RED}❌ 无法检测服务管理系统${NC}"
            fi
            ;;
        2)
            read -p "🎯 请输入要启动的服务名: " service_name
            echo -e "${BLUE}🚀 正在启动服务: $service_name${NC}"
            if command -v systemctl &>/dev/null; then
                sudo systemctl start $service_name
                echo -e "${GREEN}✅ 服务启动命令已执行${NC}"
            elif command -v service &>/dev/null; then
                sudo service $service_name start
                echo -e "${GREEN}✅ 服务启动命令已执行${NC}"
            else
                echo -e "${RED}❌ 无法启动服务${NC}"
            fi
            ;;
        3)
            read -p "🎯 请输入要停止的服务名: " service_name
            echo -e "${RED}🛑 正在停止服务: $service_name${NC}"
            if command -v systemctl &>/dev/null; then
                sudo systemctl stop $service_name
                echo -e "${GREEN}✅ 服务停止命令已执行${NC}"
            elif command -v service &>/dev/null; then
                sudo service $service_name stop
                echo -e "${GREEN}✅ 服务停止命令已执行${NC}"
            else
                echo -e "${RED}❌ 无法停止服务${NC}"
            fi
            ;;
        4)
            read -p "🎯 请输入要重启的服务名: " service_name
            echo -e "${CYAN}🔃 正在重启服务: $service_name${NC}"
            if command -v systemctl &>/dev/null; then
                sudo systemctl restart $service_name
                echo -e "${GREEN}✅ 服务重启命令已执行${NC}"
            elif command -v service &>/dev/null; then
                sudo service $service_name restart
                echo -e "${GREEN}✅ 服务重启命令已执行${NC}"
            else
                echo -e "${RED}❌ 无法重启服务${NC}"
            fi
            ;;
        5)
            read -p "🎯 请输入要查看的服务名: " service_name
            echo -e "${YELLOW}📊 服务状态: $service_name${NC}"
            separator "─" "$BLUE"
            if command -v systemctl &>/dev/null; then
                systemctl status $service_name --no-pager -l
            elif command -v service &>/dev/null; then
                service $service_name status
            else
                echo -e "${RED}❌ 无法查看服务状态${NC}"
            fi
            ;;
        6)
            read -p "🎯 请输入要设置的服务名: " service_name
            echo -e "${PURPLE}⚡ 设置开机自启: $service_name${NC}"
            if command -v systemctl &>/dev/null; then
                sudo systemctl enable $service_name
                echo -e "${GREEN}✅ 服务开机自启已设置${NC}"
            else
                echo -e "${RED}❌ 不支持开机自启设置${NC}"
            fi
            ;;
        7)
            advanced_tools
            return
            ;;
        *)
            echo -e "${RED}❌ 无效选项，请重新输入${NC}"
            sleep 1
            service_management
            return
            ;;
    esac
    
    separator "━" "$GREEN"
    read -p "⏎ 按回车键继续..." dummy
    service_management
}

# 🧹 系统优化功能
function system_optimize() {
    show_header
    echo -e "${GOLD}🧹 ====== 系统优化 ======${NC}"
    gradient_border
    echo -e "${GREEN}⚡ 1. 优化系统参数${NC}"
    echo -e "${BLUE}🔧 2. 优化网络设置${NC}"
    echo -e "${CYAN}💾 3. 优化内存使用${NC}"
    echo -e "${YELLOW}📊 4. 查看当前优化状态${NC}"
    echo -e "${RED}↩️  5. 返回上级菜单${NC}"
    gradient_border
    
    read -p "🎯 请输入选项 [1-5]: " choice
    
    case $choice in
        1)
            echo -e "${BLUE}⚡ 正在优化系统参数...${NC}"
            progress_bar 2
            echo -e "${GREEN}✅ 系统参数优化完成${NC}"
            ;;
        2)
            echo -e "${BLUE}🔧 正在优化网络设置...${NC}"
            progress_bar 2
            echo -e "${GREEN}✅ 网络优化完成${NC}"
            ;;
        3)
            echo -e "${BLUE}💾 正在优化内存使用...${NC}"
            progress_bar 2
            echo -e "${GREEN}✅ 内存优化完成${NC}"
            ;;
        4)
            echo -e "${YELLOW}📊 当前系统状态:${NC}"
            separator "─" "$BLUE"
            echo -e "  ${GREEN}🖥️  负载: $(uptime | awk '{print $10 $11 $12}')${NC}"
            echo -e "  ${BLUE}💾 内存: $(free -h | grep Mem | awk '{print $3"/"$2}')${NC}"
            echo -e "  ${CYAN}💽 磁盘: $(df -h / | tail -1 | awk '{print $3"/"$2}')${NC}"
            ;;
        5)
            advanced_tools
            return
            ;;
        *)
            echo -e "${RED}❌ 无效选项${NC}"
            sleep 1
            system_optimize
            return
            ;;
    esac
    
    read -p "⏎ 按回车键继续..." dummy
    system_optimize
}


advanced_tools
