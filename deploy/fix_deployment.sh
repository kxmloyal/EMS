#!/bin/bash

echo "=== 开始修复部署问题 ==="

# 解决后端问题
echo "==> 修复后端依赖问题..."
cd /www/wwwroot/EMS/backend
source venv/bin/activate
pip install --upgrade pip setuptools wheel
pip install numpy==1.25.2 pandas==2.0.3
deactivate

# 解决前端问题
echo "==> 修复前端依赖问题..."
cd /www/wwwroot/EMS/frontend
npm cache clean --force
npm install --legacy-peer-deps
npm install vite@5.0.0 @vitejs/plugin-vue@5.0.0 --save-dev

echo "==> 重新部署后端..."
cd /www/wwwroot/EMS/deploy
./deploy_backend.sh

echo "==> 重新部署前端..."
cd /www/wwwroot/EMS/frontend
npm run build
npm run dev

echo "=== 部署修复完成 ==="
echo "访问 http://localhost:5173 使用设备管理系统"