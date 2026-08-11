#!/bin/bash
# ============================================================
# 模块: cron.sh —— 定时任务管理
# 小战云Linux超级工具箱
# ============================================================

# ⏰ 定时任务管理 - 终极质感增强版
function cron_management() {
    show_header
    echo -e "${GOLD}⏰ ====== 定时任务管理 ======${NC}"
    gradient_border
    echo -e "${GREEN}📋 1. 查看当前定时任务${NC}    ${GRAY}► 列出所有cron任务${NC}"
    echo -e "${BLUE}✏️  2. 编辑定时任务${NC}       ${GRAY}► 使用编辑器修改${NC}"
    echo -e "${CYAN}👁️  3. 查看系统定时任务${NC}   ${GRAY}► 系统级cron任务${NC}"
    echo -e "${YELLOW}➕ 4. 添加定时任务${NC}       ${GRAY}► 创建新定时任务${NC}"
    echo -e "${RED}🗑️  5. 删除定时任务${NC}       ${GRAY}► 移除指定任务${NC}"
    echo -e "${PURPLE}🔄 6. 定时任务监控${NC}      ${GRAY}► 任务执行状态${NC}"
    echo -e "${ORANGE}↩️  7. 返回主菜单${NC}        ${GRAY}► 返回主界面${NC}"
    gradient_border

    read -p "🎯 请输入选项 [1-7]: " choice

    case $choice in
        1)
            echo -e "${YELLOW}📋 当前用户的定时任务:${NC}"
            separator "─" "$BLUE"
            local cron_count=$(crontab -l 2>/dev/null | grep -v '^#' | grep -v '^$' | wc -l)
            if [ $cron_count -eq 0 ]; then
                echo -e "  ${GRAY}📭 暂无定时任务${NC}"
            else
                crontab -l | while read line; do
                    if [[ ! $line =~ ^# ]] && [ ! -z "$line" ]; then
                        echo -e "  ${GREEN}⏰ $line${NC}"
                    fi
                done
            fi
            echo -e "${CYAN}📊 总计: $cron_count 个任务${NC}"
            ;;
        2)
            echo -e "${BLUE}✏️  打开cron编辑器...${NC}"
            crontab -e
            echo -e "${GREEN}✅ 定时任务已更新${NC}"
            ;;
        3)
            echo -e "${YELLOW}👁️  系统定时任务:${NC}"
            separator "─" "$BLUE"
            echo -e "${CYAN}📁 /etc/cron.d/ 目录:${NC}"
            ls -la /etc/cron.d/ 2>/dev/null | while read line; do
                echo -e "  ${GRAY}📄 $line${NC}"
            done
            echo -e "${CYAN}📋 /etc/crontab 文件:${NC}"
            grep -v '^#' /etc/crontab 2>/dev/null | while read line; do
                if [ ! -z "$line" ]; then
                    echo -e "  ${GREEN}⚡ $line${NC}"
                fi
            done
            ;;
        4)
            echo -e "${YELLOW}➕ 添加定时任务${NC}"
            separator "─" "$BLUE"
            read -p "🎯 请输入分钟(0-59, *): " minute
            read -p "🎯 请输入小时(0-23, *): " hour
            read -p "🎯 请输入日期(1-31, *): " day
            read -p "🎯 请输入月份(1-12, *): " month
            read -p "🎯 请输入星期(0-6, *): " weekday
            read -p "🎯 请输入要执行的命令: " command
            
            # 验证输入
            if [ -z "$command" ]; then
                echo -e "${RED}❌ 命令不能为空${NC}"
            else
                # 添加到当前用户的crontab
                (crontab -l 2>/dev/null; echo "$minute $hour $day $month $weekday $command") | crontab -
                echo -e "${GREEN}✅ 定时任务已添加!${NC}"
                echo -e "${CYAN}📅 任务时间: $minute $hour $day $month $weekday${NC}"
                echo -e "${CYAN}⚡ 执行命令: $command${NC}"
            fi
            ;;
        5)
            echo -e "${YELLOW}🗑️  删除定时任务${NC}"
            separator "─" "$BLUE"
            local temp_file=$(mktemp)
            crontab -l > "$temp_file"
            
            if [ ! -s "$temp_file" ]; then
                echo -e "  ${GRAY}📭 暂无定时任务可删除${NC}"
            else
                echo -e "${CYAN}📋 当前定时任务:${NC}"
                local index=1
                while read line; do
                    if [[ ! $line =~ ^# ]] && [ ! -z "$line" ]; then
                        echo -e "  ${RED}$index) $line${NC}"
                        index=$((index + 1))
                    fi
                done < "$temp_file"
                
                read -p "🎯 请输入要删除的任务编号: " line_num
                if [[ $line_num =~ ^[0-9]+$ ]]; then
                    sed -i "${line_num}d" "$temp_file"
                    crontab "$temp_file"
                    echo -e "${GREEN}✅ 定时任务已删除!${NC}"
                else
                    echo -e "${RED}❌ 无效的编号${NC}"
                fi
            fi
            rm -f "$temp_file"
            ;;
        6)
            echo -e "${YELLOW}🔄 定时任务监控${NC}"
            separator "─" "$BLUE"
            echo -e "${CYAN}📊 最近执行的任务:${NC}"
            sudo grep CRON /var/log/syslog 2>/dev/null | tail -5 | while read line; do
                echo -e "  ${GREEN}📝 $line${NC}"
            done
            echo -e "${CYAN}⏱️  任务执行统计:${NC}"
            sudo grep CRON /var/log/syslog 2>/dev/null | wc -l | awk '{print "  📈 总执行次数: " $1}'
            ;;
        7)
            main_menu
            ;;
        *)
            echo -e "${RED}❌ 无效选项，请重新输入${NC}"
            sleep 1
            cron_management
            ;;
    esac
    
    gradient_border
    read -p "⏎ 按回车键继续..." dummy
    cron_management
}
