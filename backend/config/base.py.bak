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
