#!/bin/bash

echo "=== 开始部署前端服务 ==="

# 检查环境
echo "==> 检查Node.js环境..."
if ! command -v node &> /dev/null; then
    echo "错误: 未找到Node.js"
    exit 1
fi

# 安装依赖
echo "==> 安装依赖..."
cd $(dirname "$0")/../frontend
npm install

# 配置环境变量
echo "==> 配置环境变量..."
if [ ! -f .env.development ]; then
    cp .env.development.example .env.development
fi

if [ ! -f .env.production ]; then
    cp .env.production.example .env.production
fi

# 构建项目
echo "==> 构建项目..."
npm run build

# 启动开发服务器
echo "==> 启动前端服务..."
nohup npm run dev > frontend.log 2>&1 &
echo "前端服务已启动，日志文件: frontend.log"

echo "=== 前端服务部署完成 ==="
echo "访问 http://localhost:5173 查看应用"