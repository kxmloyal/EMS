from flask import Blueprint, jsonify, request, abort
from app import db
from app.models.equipment import Equipment

bp = Blueprint('equipment', __name__, url_prefix='/equipment')

@bp.route('', methods=['GET'])
def get_equipment_list():
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    search = request.args.get('search', '')
    
    query = Equipment.query
    
    if search:
        query = query.filter(
            Equipment.name.ilike(f'%{search}%') |
            Equipment.model.ilike(f'%{search}%') |
            Equipment.serial_number.ilike(f'%{search}%')
        )
    
    pagination = query.paginate(page, per_page=per_page, error_out=False)
    equipment_list = [item.to_dict() for item in pagination.items]
    
    return jsonify({
        'items': equipment_list,
        'total': pagination.total,
        'pages': pagination.pages,
        'page': page,
        'per_page': per_page
    })

@bp.route('/<int:id>', methods=['GET'])
def get_equipment(id):
    equipment = Equipment.query.get_or_404(id)
    return jsonify(equipment.to_dict())

@bp.route('', methods=['POST'])
def add_equipment():
    data = request.get_json() or {}
    
    if 'name' not in data or 'serial_number' not in data:
        abort(400, description="Missing required fields")
    
    if Equipment.query.filter_by(serial_number=data['serial_number']).first():
        abort(400, description="Serial number already exists")
    
    equipment = Equipment()
    equipment.from_dict(data)
    db.session.add(equipment)
    db.session.commit()
    
    return jsonify(equipment.to_dict()), 201

@bp.route('/<int:id>', methods=['PUT'])
def update_equipment(id):
    equipment = Equipment.query.get_or_404(id)
    data = request.get_json() or {}
    
    if 'serial_number' in data and data['serial_number'] != equipment.serial_number:
        if Equipment.query.filter_by(serial_number=data['serial_number']).first():
            abort(400, description="Serial number already exists")
    
    equipment.from_dict(data)
    db.session.commit()
    
    return jsonify(equipment.to_dict())

@bp.route('/<int:id>', methods=['DELETE'])
def delete_equipment(id):
    equipment = Equipment.query.get_or_404(id)
    db.session.delete(equipment)
    db.session.commit()
    return jsonify({'message': 'Equipment deleted successfully'})