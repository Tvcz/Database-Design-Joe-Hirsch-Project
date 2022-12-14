from flask import Blueprint, request, jsonify, make_response
import json
from src import db
from src.local_utils import label_results

customers = Blueprint("customers", __name__)

# get the profile of a customer
@customers.route("/customer/<customer_id>", methods=["GET"])
def get_customer(customer_id):
    cursor = db.get_db().cursor()
    cursor.execute(
        "SELECT customer_first_name AS first_name, customer_last_name AS last_name, customer_email AS email, customer_phone AS phone, last_visit, num_visits, name AS favorite_haircut, first_name AS favorite_haircutter_first_name, last_name AS favorite_haircutter_last_name "
        "FROM "
        "(SELECT first_name AS customer_first_name, last_name AS customer_last_name, email as customer_email, phone as customer_phone, customer_id, last_visit, num_visits "
        "FROM customers JOIN users ON customers.customer_id = users.id WHERE customer_id = %s) AS customer_info "
        "JOIN favorite_templates ON customer_info.customer_id = favorite_templates.customer_id "
        "JOIN users ON favorite_templates.haircutter_id = users.id "
        "JOIN haircut_types ON favorite_templates.haircut_type_id = haircut_types.haircut_type_id",
        (customer_id),
    )
    result = cursor.fetchone()
    if not result:
        return make_response(
            "Customer not found!",
            404,
        )
    labeled = [
        {"": title, "Profile Information": value}
        for (title, value) in list(zip([key[0] for key in cursor.description], result))
    ]
    return jsonify(labeled)


# get the appointments of a customer
@customers.route("/customer/<customer_id>/appointments", methods=["GET"])
def get_customer_appointments(customer_id):
    cursor = db.get_db().cursor()
    cursor.execute(
        "SELECT start_time, end_time, first_name, last_name, name AS haircut_type_name, price "
        "FROM "
        "(SELECT appointment_id, start_time, end_time, haircut_type_id, haircutter_id "
        "FROM appointments JOIN customers ON appointments.customer_id = customers.customer_id "
        "WHERE customers.customer_id = %s) AS appointment_info "
        "JOIN users ON appointment_info.haircutter_id = users.id "
        "JOIN haircut_types ON appointment_info.haircut_type_id = haircut_types.haircut_type_id",
        (customer_id),
    )
    result = cursor.fetchall()
    labeled = label_results(cursor, result)
    return jsonify(labeled)


# make an appointment
@customers.route("/customer/<customer_id>/make_appointment", methods=["POST"])
def make_appointment(customer_id):
    cursor = db.get_db().cursor()
    data = request.get_json()

    # check if appointment already exists
    cursor.execute(
        "SELECT * FROM appointments WHERE start_time = %s AND end_time = %s AND haircutter_id = %s",
        (data["start_time"], data["end_time"], data["haircutter_id"]),
    )
    if cursor.fetchone():
        return make_response(
            "Appointment already exists!",
            400,
        )

    # check if haircutter has availability
    cursor.execute(
        "SELECT * FROM availabilities WHERE haircutter_id = %s AND start_time <= %s AND end_time >= %s",
        (data["haircutter_id"], data["start_time"], data["end_time"]),
    )
    if not cursor.fetchone():
        return make_response(
            "Haircutter is not available at this time!",
            400,
        )

    # check if haircutter has specialty in that type
    cursor.execute(
        "SELECT * FROM specialties WHERE haircut_type_id = %s AND haircutter_id = %s",
        (data["haircut_type_id"], data["haircutter_id"]),
    )
    if not cursor.fetchone():
        return make_response(
            "Haircutter does not provide this haircut type!",
            400,
        )

    # add appointment
    cursor.execute(
        "INSERT INTO appointments (haircut_type_id, haircutter_id, customer_id, start_time, end_time) VALUES (%s, %s, %s, %s, %s)",
        (
            data["haircut_type_id"],
            data["haircutter_id"],
            customer_id,
            data["start_time"],
            data["end_time"],
        ),
    )
    db.get_db().commit()
    return make_response(
        "Appointment created!",
        201,
    )


# get the purchases of a customer
@customers.route("/customer/<customer_id>/purchases", methods=["GET"])
def get_customer_purchases(customer_id):
    cursor = db.get_db().cursor()
    cursor.execute(
        "SELECT sale_time, item_name, quantity, sale_price "
        "FROM "
        "(SELECT sale_items.sale_id AS sale_id, item_id, quantity, sale_time "
        "FROM sale_items JOIN sales ON sale_items.sale_id = sales.sale_id "
        "WHERE sales.customer_id = %s) AS sale_info "
        "JOIN inventory_items ON sale_info.item_id = inventory_items.item_id",
        (customer_id),
    )
    result = cursor.fetchall()
    labeled = label_results(cursor, result)
    return jsonify(labeled)
