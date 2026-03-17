#!/bin/bash
# OpenClaw Agent 安装脚本
# Repo: https://github.com/anyone-developer/agent-created-by-agents
# Usage: curl -sSL https://raw.githubusercontent.com/anyone-developer/agent-created-by-agents/main/install.sh | bash

set -e

echo "🤖 Agents Creating Agents - 安装脚本"
echo "=================================="
echo ""

# 检查 OpenClaw 是否安装
if ! command -v openclaw &> /dev/null; then
    echo "❌ OpenClaw 未安装，请先安装 OpenClaw"
    echo "   访问: https://github.com/openclaw/openclaw"
    exit 1
fi

# 获取 OpenClaw 配置目录
OPENCLAW_DIR="$HOME/.openclaw"
WORKSPACE_DIR="$OPENCLAW_DIR"

echo "📁 OpenClaw 目录: $OPENCLAW_DIR"
echo ""

# 创建临时目录
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# 克隆仓库
echo "📥 下载 Agent 文件..."
git clone --quiet https://github.com/anyone-developer/agent-created-by-agents.git .
echo "✅ 下载完成"
echo ""

# 询问安装哪个 Agent
echo "请选择要安装的 Agent:"
echo "1) 🚀 ProFullStack — 专业版（全能型，适合团队/企业）"
echo "2) ⚡ LiteFullStack — 轻量版（专注Coding，适合OPC/个人）"
echo "3) 两个都安装"
echo ""
read -p "请输入选择 (1/2/3): " choice

install_pro() {
    echo ""
    echo "🚀 安装 ProFullStack..."
    
    # 创建目录
    mkdir -p "$WORKSPACE_DIR/workspace-pro-fullstack"
    
    # 复制文件
    cp -r agent-pro-fullstack-engineer/* "$WORKSPACE_DIR/workspace-pro-fullstack/"
    
    echo "✅ ProFullStack 安装完成"
    echo "   工作目录: $WORKSPACE_DIR/workspace-pro-fullstack"
}

install_lite() {
    echo ""
    echo "⚡ 安装 LiteFullStack..."
    
    # 创建目录
    mkdir -p "$WORKSPACE_DIR/workspace-lite-fullstack"
    
    # 复制文件
    cp -r agent-lite-fullstack-engineer/* "$WORKSPACE_DIR/workspace-lite-fullstack/"
    
    echo "✅ LiteFullStack 安装完成"
    echo "   工作目录: $WORKSPACE_DIR/workspace-lite-fullstack"
}

case $choice in
    1)
        install_pro
        ;;
    2)
        install_lite
        ;;
    3)
        install_pro
        install_lite
        ;;
    *)
        echo "❌ 无效选择"
        exit 1
        ;;
esac

echo ""
echo "📝 下一步:"
echo "1. 编辑 $OPENCLAW_DIR/openclaw.json 添加 Agent 配置"
echo "2. 运行 'openclaw restart' 重启服务"
echo "3. 在 Aight App 中选择 Agent 开始使用"
echo ""
echo "📚 详细文档: https://github.com/anyone-developer/agent-created-by-agents"
echo ""
echo "🎉 安装完成！"

# 清理
rm -rf "$TEMP_DIR"
