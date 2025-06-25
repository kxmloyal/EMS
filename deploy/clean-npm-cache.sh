#!/bin/bash

echo "正在清除npm缓存..."
npm cache clean --force

echo "查找并删除全局npm缓存目录..."
NPM_CACHE_DIR=$(npm config get cache)
if [ -d "$NPM_CACHE_DIR" ]; then
    echo "找到缓存目录: $NPM_CACHE_DIR"
    echo "正在删除..."
    rm -rf "$NPM_CACHE_DIR"
    echo "缓存目录已删除"
else
    echo "未找到npm缓存目录"
fi

echo "验证缓存状态..."
npm cache verify

echo "npm缓存已彻底清除！"