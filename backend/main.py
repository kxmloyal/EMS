# backend/main.py
from app import create_app

app = create_app('development')  # 指定开发环境配置

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)