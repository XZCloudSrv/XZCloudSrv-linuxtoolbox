#!/bin/bash

if [ -f "${TOOLBOX_DIR}/common.sh" ]; then
    source "${TOOLBOX_DIR}/common.sh"
fi

function docker_management() {
    show_header
    echo -e "${GOLD}🐳 ====== Docker管理 ======${NC}"
    gradient_border
    
    # 检查Docker是否安装
    if ! command -v docker &>/dev/null; then
        echo -e "${RED}❌ Docker未安装${NC}"
        echo -e "${YELLOW}💡 是否立即安装Docker? [Y/n]${NC}"
        read install_choice
        if [[ ! "$install_choice" =~ ^[Nn]$ ]]; then
            echo -e "${BLUE}📦 正在安装Docker...${NC}"
            progress_bar 3
            curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
            sudo systemctl enable docker
            sudo systemctl start docker
            echo -e "${GREEN}✅ Docker安装完成!${NC}"
        else
            read -p "⏎ 按回车键返回..." dummy
            main_menu
            return
        fi
    fi

    echo -e "${GREEN}📊 1. 查看Docker信息${NC}     ${GRAY}► 系统和服务状态${NC}"
    echo -e "${BLUE}📦 2. 列出所有容器${NC}       ${GRAY}► 运行和停止的容器${NC}"
    echo -e "${CYAN}⚡ 3. 启动/停止容器${NC}      ${GRAY}► 容器生命周期管理${NC}"
    echo -e "${YELLOW}📋 4. 查看容器日志${NC}      ${GRAY}► 实时日志查看${NC}"
    echo -e "${PURPLE}🖼️  5. 管理镜像${NC}         ${GRAY}► 镜像列表和操作${NC}"
    echo -e "${ORANGE}🧹 6. 清理Docker${NC}        ${GRAY}► 释放磁盘空间${NC}"
    echo -e "${RED}↩️  7. 返回主菜单${NC}        ${GRAY}► 返回主界面${NC}"
    gradient_border

    read -p "🎯 请输入选项 [1-7]: " choice

    case $choice in
        1)
            echo -e "${YELLOW}📊 Docker系统信息:${NC}"
            separator "─" "$BLUE"
            docker info 2>/dev/null | grep -E "Server Version|Containers|Images|Storage Driver" | while read line; do
                echo -e "  ${GREEN}🔧 $line${NC}"
            done
            read -p "⏎ 按回车键返回..." dummy
            docker_management
            ;;
        2)
            echo -e "${YELLOW}📦 所有容器列表:${NC}"
            separator "─" "$BLUE"
            docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}" | while read line; do
                if [[ $line == *"Up"* ]]; then
                    echo -e "  ${GREEN}🟢 $line${NC}"
                elif [[ $line == *"Exited"* ]]; then
                    echo -e "  ${RED}🔴 $line${NC}"
                else
                    echo -e "  ${GRAY}⚪ $line${NC}"
                fi
            done
            read -p "⏎ 按回车键返回..." dummy
            docker_management
            ;;
        3)
            echo -e "${YELLOW}⚡ 容器操作${NC}"
            separator "─" "$BLUE"
            read -p "🎯 请输入容器ID或名称: " container
            echo -e "${GREEN}🚀 1. 启动容器${NC}"
            echo -e "${RED}🛑 2. 停止容器${NC}"
            echo -e "${CYAN}🔃 3. 重启容器${NC}"
            echo -e "${YELLOW}🗑️  4. 删除容器${NC}"
            echo -e "${GRAY}↩️  5. 返回${NC}"
            read -p "🎯 请选择操作 [1-5]: " operation
            case $operation in
                1) 
                    docker start $container
                    echo -e "${GREEN}✅ 容器已启动${NC}"
                    ;;
                2) 
                    docker stop $container
                    echo -e "${GREEN}✅ 容器已停止${NC}"
                    ;;
                3) 
                    docker restart $container
                    echo -e "${GREEN}✅ 容器已重启${NC}"
                    ;;
                4) 
                    docker rm $container
                    echo -e "${GREEN}✅ 容器已删除${NC}"
                    ;;
                5) 
                    docker_management
                    return 
                    ;;
                *) 
                    echo -e "${RED}❌ 无效选项${NC}"
                    ;;
            esac
            read -p "⏎ 按回车键返回..." dummy
            docker_management
            ;;
        4)
            echo -e "${YELLOW}📋 查看容器日志${NC}"
            separator "─" "$BLUE"
            read -p "🎯 请输入容器ID或名称: " container
            echo -e "${CYAN}📝 容器日志:${NC}"
            docker logs --tail 20 $container 2>/dev/null | while read line; do
                echo -e "  ${GRAY}📄 $line${NC}"
            done
            read -p "⏎ 按回车键返回..." dummy
            docker_management
            ;;
        5)
            echo -e "${YELLOW}🖼️ 镜像管理${NC}"
            separator "─" "$BLUE"
            echo -e "${GREEN}📋 1. 列出所有镜像${NC}"
            echo -e "${BLUE}⬇️  2. 拉取镜像${NC}"
            echo -e "${RED}🗑️  3. 删除镜像${NC}"
            echo -e "${GRAY}↩️  4. 返回${NC}"
            read -p "🎯 请选择操作 [1-4]: " operation
            case $operation in
                1)
                    echo -e "${CYAN}📦 镜像列表:${NC}"
                    docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedSince}}" | while read line; do
                        echo -e "  ${GREEN}🖼️  $line${NC}"
                    done
                    ;;
                2)
                    read -p "🎯 请输入镜像名称(如nginx:latest): " image
                    echo -e "${BLUE}⬇️  正在拉取镜像...${NC}"
                    docker pull $image
                    echo -e "${GREEN}✅ 镜像拉取完成${NC}"
                    ;;
                3)
                    read -p "🎯 请输入镜像ID: " image
                    docker rmi $image
                    echo -e "${GREEN}✅ 镜像已删除${NC}"
                    ;;
                4)
                    docker_management
                    return
                    ;;
                *)
                    echo -e "${RED}❌ 无效选项${NC}"
                    ;;
            esac
            read -p "⏎ 按回车键返回..." dummy
            docker_management
            ;;
        6)
            echo -e "${YELLOW}🧹 清理Docker${NC}"
            separator "─" "$BLUE"
            echo -e "${GREEN}🗑️  1. 清理停止的容器${NC}"
            echo -e "${BLUE}🖼️  2. 清理无用镜像${NC}"
            echo -e "${CYAN}💾 3. 清理所有未使用资源${NC}"
            echo -e "${GRAY}↩️  4. 返回${NC}"
            read -p "🎯 请选择操作 [1-4]: " operation
            case $operation in
                1) 
                    docker container prune -f
                    echo -e "${GREEN}✅ 已清理停止的容器${NC}"
                    ;;
                2) 
                    docker image prune -f
                    echo -e "${GREEN}✅ 已清理无用镜像${NC}"
                    ;;
                3) 
                    docker system prune -f
                    echo -e "${GREEN}✅ 已清理所有未使用资源${NC}"
                    ;;
                4) 
                    docker_management
                    return 
                    ;;
                *) 
                    echo -e "${RED}❌ 无效选项${NC}"
                    ;;
            esac
            read -p "⏎ 按回车键返回..." dummy
            docker_management
            ;;
        7)
            main_menu
            ;;
        *)
            echo -e "${RED}❌ 无效选项，请重新输入${NC}"
            sleep 1
            docker_management
            ;;
    esac
}


docker_management
