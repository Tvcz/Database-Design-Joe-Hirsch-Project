from flask import Blueprint, request, jsonify, make_response
import json
from src.local_utils import label_results, concat_names
from src import db

managers = Blueprint("managers", __name__)


# get the profile of a manager
@managers.route("/manager/<manager_id>", methods=["GET"])
def get_manager(manager_id):
    cursor = db.get_db().cursor()
    cursor.execute(
        "SELECT email, first_name, last_name, phone, store_id, job_start_date FROM managers JOIN users ON managers.manager_id = users.id WHERE manager_id = %s",
        (manager_id),
    )
    result = cursor.fetchone()
    if not result:
        return make_response(
            "Manager not found!",
            404,
        )
    labeled = [
        {"": title, "Profile Information": value}
        for (title, value) in list(zip([key[0] for key in cursor.description], result))
    ]
    return jsonify(labeled)


# get the haircutters of a manager
@managers.route("/manager/<manager_id>/haircutters", methods=["GET"])
def get_haircutters(manager_id):
    cursor = db.get_db().cursor()
    cursor.execute(
        "SELECT first_name, last_name, email, phone, job_start_date, years_of_experience FROM haircutters JOIN users ON haircutters.haircutter_id = users.id WHERE manager_id = %s",
        (manager_id),
    )
    result = cursor.fetchall()
    labeled = label_results(cursor, result)
    return jsonify(labeled)


# list all haircut types
@managers.route("/haircut_types", methods=["GET"])
def get_haircut_types():
    cursor = db.get_db().cursor()
    cursor.execute("SELECT * FROM haircut_types")
    result = cursor.fetchall()
    labeled = label_results(cursor, result)
    return jsonify(labeled)


# list all availabilities
@managers.route("/availabilities", methods=["GET"])
def get_availabilities():
    cursor = db.get_db().cursor()
    cursor.execute(
        "SELECT first_name, last_name, start_time, end_time FROM availabilities JOIN users ON availabilities.haircutter_id = users.id"
    )
    result = cursor.fetchall()
    labeled = label_results(cursor, result)
    return jsonify(labeled)


# list all appointments
@managers.route("/appointments", methods=["GET"])
def get_appointments():
    cursor = db.get_db().cursor()
    cursor.execute(
        "SELECT appointment_id, haircutter_first_name, haircutter_last_name, first_name, last_name, name AS haircut_type, start_time, end_time FROM "
        "(SELECT appointment_id, first_name AS haircutter_first_name, last_name AS haircutter_last_name, haircut_type_id, start_time, end_time, customer_id FROM "
        "appointments JOIN users ON appointments.haircutter_id = users.id) AS T "
        "JOIN "
        "haircut_types ON T.haircut_type_id = haircut_types.haircut_type_id "
        "JOIN "
        "users ON T.customer_id = users.id"
    )
    result = cursor.fetchall()
    labeled = [
        concat_names(
            concat_names(
                dict(zip([key[0] for key in cursor.description], row)),
                name="customer_name",
            ),
            first_name="haircutter_first_name",
            last_name="haircutter_last_name",
            name="haircutter_name",
        )
        for row in result
    ]
    return jsonify(labeled)
