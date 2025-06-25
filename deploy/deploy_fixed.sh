#!/bin/bash

echo "=== 开始部署设备管理系统 ==="

# 定义项目路径
BACKEND_DIR="/www/wwwroot/EMS/backend"
FRONTEND_DIR="/www/wwwroot/EMS/frontend"
VENV_DIR="$BACKEND_DIR/venv"
BACKEND_LOG="/www/wwwroot/EMS/backend.log"
FRONTEND_LOG="/www/wwwroot/EMS/frontend.log"

# 后端部署函数
deploy_backend() {
    echo "==> 部署后端服务..."
    
    # 清除旧虚拟环境
    if [ -d "$VENV_DIR" ]; then
        echo "==> 清除旧虚拟环境..."
        rm -rf "$VENV_DIR"
    fi
    
    # 创建新虚拟环境
    echo "==> 创建虚拟环境..."
    python3 -m venv "$VENV_DIR"
    if [ $? -ne 0 ]; then
        echo "错误: 创建虚拟环境失败"
        exit 1
    fi
    
    # 激活虚拟环境
    source "$VENV_DIR/bin/activate"
    
    # 升级工具
    echo "==> 升级pip和setuptools..."
    pip install --upgrade pip setuptools wheel
    
    # 安装依赖
    echo "==> 安装后端依赖..."
    cd "$BACKEND_DIR"
    pip install -r requirements.txt
    if [ $? -ne 0 ]; then
        echo "错误: 依赖安装失败"
        exit 1
    fi
    
    # 配置环境变量
    echo "==> 配置环境变量..."
    if [ -f ".env" ]; then
        export $(grep -v '^#' .env | xargs)
    else
        echo "警告: .env文件不存在，使用默认配置"
    fi
    
    # 初始化数据库
    echo "==> 初始化数据库..."
    flask db init
    flask db migrate -m "Initial migration"
    flask db upgrade
    if [ $? -ne 0 ]; then
        echo "错误: 数据库初始化失败"
        exit 1
    fi
    
    # 启动后端服务
    echo "==> 启动后端服务..."
    gunicorn -w 4 -b 0.0.0.0:5000 app:app --access-logfile "$BACKEND_LOG" --error-logfile "$BACKEND_LOG" --daemon
    if [ $? -ne 0 ]; then
        echo "错误: 启动后端服务失败，请检查日志: $BACKEND_LOG"
        exit 1
    fi
    
    echo "后端服务已启动，日志文件: $BACKEND_LOG"
}

# 前端部署函数
deploy_frontend() {
    echo "==> 部署前端服务..."
    cd "$FRONTEND_DIR"
    
    # 清除缓存和旧依赖
    echo "==> 清除前端缓存..."
    npm cache clean --force
    rm -rf node_modules package-lock.json
    
    # 安装依赖
    echo "==> 安装前端依赖..."
    npm install --legacy-peer-deps
    if [ $? -ne 0 ]; then
        echo "错误: 前端依赖安装失败"
        exit 1
    fi
    
    # 构建前端
    echo "==> 构建前端项目..."
    npm run build
    if [ $? -ne 0 ]; then
        echo "错误: 前端构建失败"
        exit 1
    fi
    
    # 启动前端服务
    echo "==> 启动前端服务..."
    npm run dev > "$FRONTEND_LOG" 2>&1 &
    echo "前端服务已启动，日志文件: $FRONTEND_LOG"
}

# 主流程
deploy_backend
sleep 5  # 等待后端启动
deploy_frontend

echo "=== 设备管理系统部署完成 ==="
echo "访问 http://localhost:5173 使用系统"
echo "后端API: http://localhost:5000/api"