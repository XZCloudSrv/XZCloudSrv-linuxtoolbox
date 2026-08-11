#!/bin/bash
if [ -f "${TOOLBOX_DIR}/common.sh" ]; then
    source "${TOOLBOX_DIR}/common.sh"
fi

echo -e "${BLUE}🔄 正在检查工具箱主程序更新...${NC}"
progress_bar 1
curl -fsS "$base_url/xzyun-tool.sh" -o /tmp/xzyun-tool.sh
if [ $? -eq 0 ]; then
    mv /tmp/xzyun-tool.sh "$0"
    echo -e "${GREEN}✅ 工具箱主程序已更新！请重新运行。${NC}"
    exit 0
else
    echo -e "${RED}❌ 更新失败，请检查网络线路。${NC}"
fi
sleep 2
