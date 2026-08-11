#!/bin/bash
# ============================================================
# 模块: common.sh  —— 公共UI/颜色/动画函数库
# 说明: 被加载器 source，其他所有模块共用这里的函数与颜色变量
# 小战云Linux超级工具箱
# ============================================================

# 🎨 定义颜色代码 - 质感增强版
RED='\033[1;38;5;196m'      # 鲜红色 - 用于错误和警告
GREEN='\033[1;38;5;46m'     # 亮绿色 - 用于成功和确认
YELLOW='\033[1;38;5;226m'   # 金黄色 - 用于提示和注意
BLUE='\033[1;38;5;39m'      # 宝蓝色 - 用于信息和链接
PURPLE='\033[1;38;5;129m'   # 紫罗兰色 - 用于特殊功能
CYAN='\033[1;38;5;51m'      # 青蓝色 - 用于标题和边框
ORANGE='\033[1;38;5;208m'   # 橙黄色 - 用于警告和操作
PINK='\033[1;38;5;205m'     # 粉红色 - 用于女性化提示
GRAY='\033[1;38;5;245m'     # 高级灰 - 用于次要信息
GOLD='\033[1;38;5;178m'     # 金色 - 用于重要信息
SILVER='\033[1;38;5;250m'   # 银色 - 用于边框和分割线
NC='\033[0m'                # 重置颜色

# ✨ 定义全局变量
TOOLBOX_DIR="/etc/zcycloud-toolbox"
CONFIG_FILE="$TOOLBOX_DIR/config.cfg"
COUNTER_FILE="$TOOLBOX_DIR/counter"
VERSION="2.3"
UPDATE_URL="https://xzy.xzyun.sbs/tools/gx.json"
SCRIPT_URL="https://xzy.xzyun.sbs/tools/xzyun-tool.sh"

# 🎭 动画效果函数库
function animate_text() {
    local text="$1"
    local color="$2"
    local delay=${3:-0.03}
    
    echo -ne "${color}"
    for (( i=0; i<${#text}; i++ )); do
        echo -n "${text:$i:1}"
        sleep $delay
    done
    echo -e "${NC}"
}

# 📊 进度条函数
function progress_bar() {
    local duration=${1:-2}
    local width=40
    local increment=$((100 / width))
    local count=0
    local phase=("⣷" "⣯" "⣟" "⡿" "⢿" "⣻" "⣽" "⣾")
    
    while [ $count -lt 100 ]; do
        local pos=$((count % 8))
        local bar=""
        for ((i=0; i<width; i++)); do
            if [ $i -lt $((count * width / 100)) ]; then
                bar+="▓"
            else
                bar+="░"
            fi
        done
        local percent=$(printf "%3d" $count)
        echo -ne "\r${phase[$pos]} ${BLUE}[${bar}] ${percent}%${NC}"
        count=$((count + increment))
        sleep 0.1
    done
    echo -ne "\r${GREEN}✅ [========================================] 100%${NC}"
    echo
}

# ✨ 闪烁效果
function blink_text() {
    local text="$1"
    local color1="$2"
    local color2="$3"
    local times=${4:-2}
    
    for ((i=0; i<times; i++)); do
        echo -ne "\r${color1}${text}${NC}"
        sleep 0.2
        echo -ne "\r${color2}${text}${NC}"
        sleep 0.2
    done
    echo -ne "\r${color1}${text}${NC}"
    echo
}

# 🌈 渐变边框
function gradient_border() {
    local width=$(tput cols)
    local colors=("$BLUE" "$CYAN" "$GREEN" "$YELLOW" "$ORANGE" "$PINK" "$PURPLE")
    local border=""
    
    for ((i=0; i<width; i++)); do
        local color_idx=$((i % ${#colors[@]}))
        border+="${colors[$color_idx]}═${NC}"
    done
    echo -e "$border"
}

# 🎯 分割线函数
function separator() {
    local width=$(tput cols)
    local char="${1:-─}"
    local color="${2:-$CYAN}"
    echo -e "${color}$(printf "%${width}s" | tr ' ' "$char")${NC}"
}

# 💫 加载动画
function loading_animation() {
    local text="$1"
    local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
    
    echo -ne "${CYAN}${text}${NC}"
    for i in {1..6}; do
        for frame in "${frames[@]}"; do
            echo -ne "\r${CYAN}${frame} ${text}${NC}"
            sleep 0.1
        done
    done
    echo -e "\r${GREEN}✅ ${text}完成${NC}"
}
