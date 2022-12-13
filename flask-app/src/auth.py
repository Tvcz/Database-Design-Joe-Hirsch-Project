from flask import Blueprint, request, jsonify, make_response
import json
from src import db

auth = Blueprint("auth", __name__)

# login a user
@auth.route("/login", methods=["POST"])
def login():
    cursor = db.get_db().cursor()
    data = request.get_json()
    cursor.execute(
        "SELECT id FROM users WHERE email = %s AND password = %s",
        (data["email"], data["password"]),
    )
    result = cursor.fetchone()
    if not result:
        return make_response(
            "Login failed!",
            401,
            {"WWW-Authenticate": 'Basic realm="Login Required"'},
        )
    ## get the role of the user
    labeled = dict(zip([key[0] for key in cursor.description], result))
    labeled["role"] = "none"
    cursor.execute("SELECT * FROM managers WHERE manager_id = %s", (labeled["id"]))
    if cursor.fetchone():
        labeled["role"] = "manager"
    cursor.execute(
        "SELECT * FROM haircutters WHERE haircutter_id = %s", (labeled["id"])
    )
    if cursor.fetchone():
        labeled["role"] = "haircutter"
    cursor.execute("SELECT * FROM customers WHERE customer_id = %s", (labeled["id"]))
    if cursor.fetchone():
        labeled["role"] = "customer"

    return jsonify({"user_id": labeled["id"], "role": labeled["role"]})
