#!/bin/bash

# 设备管理系统后端部署脚本

# 定义项目路径
PROJECT_DIR="/www/wwwroot/EMS/backend"
VENV_DIR="$PROJECT_DIR/venv"
LOG_FILE="/www/wwwroot/EMS/backend.log"

echo "=== 开始部署后端服务 ==="

# 检查Python环境
echo "==> 检查Python环境..."
if ! command -v python3 &> /dev/null; then
    echo "错误: 未找到Python 3"
    exit 1
fi

# 获取Python主版本和次版本
major_version=$(python3 -c 'import sys; print(sys.version_info.major)')
minor_version=$(python3 -c 'import sys; print(sys.version_info.minor)')

# 检查版本是否 >= 3.8
if [[ $major_version -lt 3 ]] || [[ $major_version -eq 3 && $minor_version -lt 8 ]]; then
    echo "错误: 需要Python 3.8或更高版本，当前版本为 $major_version.$minor_version"
    exit 1
fi

echo "Python版本: $major_version.$minor_version (满足要求)"

# 创建虚拟环境
echo "==> 创建虚拟环境..."
if [ ! -d "$VENV_DIR" ]; then
    python3 -m venv "$VENV_DIR"
    if [ $? -ne 0 ]; then
        echo "错误: 创建虚拟环境失败"
        exit 1
    fi
fi

# 激活虚拟环境
source "$VENV_DIR/bin/activate"

# 升级pip和setuptools
echo "==> 升级pip和setuptools..."
pip install --upgrade pip setuptools wheel

# 安装依赖
echo "==> 安装依赖..."
cd "$PROJECT_DIR"

# 尝试安装兼容版本的numpy和pandas
echo "==> 安装numpy和pandas..."
pip install --only-binary=:all: numpy pandas || pip install numpy==1.26.0 pandas==2.1.0

# 安装其他依赖
echo "==> 安装其他依赖..."
pip install -r requirements.txt

if [ $? -ne 0 ]; then
    echo "错误: 依赖安装失败"
    exit 1
fi

# 配置环境变量
echo "==> 配置环境变量..."
if [ -f ".env" ]; then
    echo "加载环境变量..."
    export $(grep -v '^#' .env | xargs)
else
    echo "警告: .env文件不存在，将使用默认配置"
fi

# 初始化数据库
echo "==> 初始化数据库..."
flask db init
if [ $? -ne 0 ]; then
    echo "错误: 数据库初始化失败"
    exit 1
fi

flask db migrate -m "Initial migration"
if [ $? -ne 0 ]; then
    echo "错误: 数据库迁移失败"
    exit 1
fi

flask db upgrade
if [ $? -ne 0 ]; then
    echo "错误: 数据库升级失败"
    exit 1
fi

# 启动后端服务
echo "==> 启动后端服务..."
cd "$PROJECT_DIR"
gunicorn -w 4 -b 0.0.0.0:5000 app:app --access-logfile "$LOG_FILE" --error-logfile "$LOG_FILE" --daemon

if [ $? -ne 0 ]; then
    echo "错误: 启动后端服务失败，请检查日志: $LOG_FILE"
    exit 1
fi

echo "后端服务已启动，日志文件: $LOG_FILE"
echo "=== 后端服务部署完成 ==="
echo "访问 http://localhost:5000/api/equipment 测试API"

# 验证服务是否启动
sleep 5
if ! curl -s http://localhost:5000/api/health > /dev/null; then
    echo "警告: 服务未正常响应，请检查 $LOG_FILE"
fi