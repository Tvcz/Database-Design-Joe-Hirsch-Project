from flask import Blueprint, request, jsonify, make_response
import json
from src.local_utils import label_results
from src import db

store = Blueprint("store", __name__)

# get all inventory items
@store.route("/inventory", methods=["GET"])
def get_inventory():
    cursor = db.get_db().cursor()
    cursor.execute(
        "SELECT * FROM inventory_items JOIN suppliers ON inventory_items.supplier_id = suppliers.supplier_id"
    )
    result = cursor.fetchall()
    labeled = label_results(cursor, result)
    return jsonify(labeled)
