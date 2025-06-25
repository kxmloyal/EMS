from app import db

class Equipment(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    model = db.Column(db.String(50))
    serial_number = db.Column(db.String(50), unique=True)
    category = db.Column(db.String(50))
