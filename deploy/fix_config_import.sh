#!/bin/bash

echo "=== 修复配置模块导入问题 ==="

# 备份原文件
cd /www/wwwroot/EMS/backend
if [ -f "app/__init__.py" ]; then
    cp app/__init__.py app/__init__.py.bak
    echo "已备份app/__init__.py"
fi

if [ -f "config/base.py" ]; then
    cp config/base.py config/base.py.bak
    echo "已备份config/base.py"
fi

# 更新config/base.py
cat > config/base.py << 'EOF'
import os

class Config:
    DEBUG = False
    TESTING = False
    SECRET_KEY = os.environ.get('SECRET_KEY', 'your-secret-key')
    SQLALCHEMY_DATABASE_URI = os.environ.get(
        'DATABASE_URL', 
        'mysql+mysqlconnector://root:mariadb_j2m5B2@192.168.90.174:3307/equipment_db'
    )
    SQLALCHEMY_TRACK_MODIFICATIONS = False

config = {
    'development': Config,
    'production': Config,
    'testing': Config
}
EOF

# 更新app/__init__.py导入语句
sed -i 's/from config.base import config/from config.base import config/g' app/__init__.py

# 创建模型文件示例
if [ ! -d "app/models" ]; then
    mkdir -p app/models
    echo "创建模型目录"
fi

cat > app/models/equipment.py << 'EOF'
from app import db

class Equipment(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    model = db.Column(db.String(50))
    serial_number = db.Column(db.String(50), unique=True)
    category = db.Column(db.String(50))
EOF

echo "=== 配置模块导入问题修复完成 ==="
echo "请重新运行部署脚本"