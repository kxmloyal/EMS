#!/bin/bash

echo "=== 开始全量部署设备管理系统 ==="

# 部署后端
echo "==> 部署后端..."
$(dirname "$0")/deploy_backend.sh

# 等待后端启动
echo "==> 等待后端服务启动..."
sleep 10

# 部署前端
echo "==> 部署前端..."
$(dirname "$0")/deploy_frontend.sh

echo "=== 系统部署完成 ==="
echo "访问 http://localhost:5173 使用设备管理系统"
echo "后端API: http://localhost:5000/api"