from flask import Blueprint, request, jsonify, make_response
import json
from src import db
from src.local_utils import label_results

haircutters = Blueprint("haircutters", __name__)

# get all haircutters
@haircutters.route("/haircutters", methods=["GET"])
def get_haircutters():
    cursor = db.get_db().cursor()
    cursor.execute(
        "SELECT * FROM haircutters JOIN users ON haircutters.haircutter_id = users.id"
    )
    result = cursor.fetchall()
    labeled = label_results(cursor, result)
    return jsonify(labeled)


# get the profile of a haircutter
@haircutters.route("/haircutter/<haircutter_id>", methods=["GET"])
def get_haircutter(haircutter_id):
    cursor = db.get_db().cursor()
    cursor.execute(
        "SELECT haircutter_first_name, haircutter_last_name, start_date, years_of_experience, haircutter_email, haircutter_phone, first_name AS manager_first_name, last_name AS manager_last_name "
        "FROM "
        "(SELECT first_name AS haircutter_first_name, last_name AS haircutter_last_name, job_start_date AS start_date, years_of_experience, email as haircutter_email, phone as haircutter_phone, manager_id, haircutter_id "
        "FROM haircutters JOIN users ON haircutters.haircutter_id = users.id) AS haircutter_info "
        "JOIN users ON haircutter_info.manager_id = users.id "
        "WHERE haircutter_id = %s",
        (haircutter_id),
    )
    result = cursor.fetchone()
    if not result:
        return make_response(
            "Haircutter not found!",
            404,
        )
    labeled = [
        {"": title, "Profile Information": value}
        for (title, value) in list(zip([key[0] for key in cursor.description], result))
    ]
    return jsonify(labeled)


# get the specialties of a haircutter
@haircutters.route("/haircutter/<haircutter_id>/specialties", methods=["GET"])
def get_haircutter_specialties(haircutter_id):
    cursor = db.get_db().cursor()
    cursor.execute(
        "SELECT name, description, price, haircut_types.haircut_type_id AS haircut_type_id FROM specialties JOIN haircut_types ON specialties.haircut_type_id = haircut_types.haircut_type_id "
        "JOIN haircutters ON specialties.haircutter_id = haircutters.haircutter_id "
        "WHERE haircutters.haircutter_id = %s",
        (haircutter_id),
    )
    result = cursor.fetchall()
    labeled = label_results(cursor, result)
    return jsonify(labeled)


# get the availability of a haircutter
@haircutters.route("/haircutter/<haircutter_id>/availability", methods=["GET"])
def get_haircutter_availability(haircutter_id):
    cursor = db.get_db().cursor()
    cursor.execute(
        "SELECT start_time, end_time FROM availabilities JOIN haircutters ON availabilities.haircutter_id = haircutters.haircutter_id "
        "WHERE haircutters.haircutter_id = %s",
        (haircutter_id),
    )
    result = cursor.fetchall()
    labeled = label_results(cursor, result)
    return jsonify(labeled)


# get the appointments of a haircutter
@haircutters.route("/haircutter/<haircutter_id>/appointments", methods=["GET"])
def get_haircutter_appointments(haircutter_id):
    cursor = db.get_db().cursor()
    cursor.execute(
        "SELECT appointment_id, start_time, end_time, first_name, last_name, phone, name AS haircut_type_name, price "
        "FROM "
        "(SELECT appointment_id, start_time, end_time, customer_id, haircut_type_id "
        "FROM appointments JOIN haircutters ON appointments.haircutter_id = haircutters.haircutter_id "
        "WHERE haircutters.haircutter_id = %s) AS appointment_info "
        "JOIN customers ON appointment_info.customer_id = customers.customer_id "
        "JOIN users ON customers.customer_id = users.id "
        "JOIN haircut_types ON appointment_info.haircut_type_id = haircut_types.haircut_type_id",
        (haircutter_id),
    )
    result = cursor.fetchall()
    labeled = label_results(cursor, result)
    return jsonify(labeled)
