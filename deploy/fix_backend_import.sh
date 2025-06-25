#!/bin/bash

echo "=== 修复后端导入问题 ==="

# 备份原文件
cd /www/wwwroot/EMS/backend
if [ -f "app/__init__.py" ]; then
    cp app/__init__.py app/__init__.py.bak
    echo "已备份app/__init__.py"
fi

if [ -f "main.py" ]; then
    cp main.py main.py.bak
    echo "已备份main.py"
fi

# 修改app/__init__.py导入语句
sed -i 's/from config import config/from config.base import config/g' app/__init__.py

# 确保config/base.py存在
if [ ! -f "config/base.py" ]; then
    echo "创建config/base.py..."
    cat > config/base.py << 'EOF'
class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY', 'your-secret-key')
    SQLALCHEMY_DATABASE_URI = os.environ.get(
        'DATABASE_URL', 
        'mysql+mysqlconnector://root:mariadb_j2m5B2@192.168.90.174:3307/equipment_db'
    )
    SQLALCHEMY_TRACK_MODIFICATIONS = False

config = {
    'development': Config,
    'production': Config
}
EOF
fi

# 修改main.py
sed -i 's/config_name=None/config_name="development"/g' main.py

echo "=== 后端导入问题修复完成 ==="
echo "请重新运行部署脚本"