# Haircutify Database Design Project

This repo is my implementation of a backend for a web app used for the organization and management of data at a barbershop. 

It includes a total of 16 routes in 5 flask blueprints, 14 routes of which use `GET` and 2 of which use `POST`.

The frontend for the app exists on AppSmith and can be accessed [here](https://appsmith.cs3200.net/app/haircutify/login-639360725bc9880dbcb21433).



## Flask organization

The Flask code is organized into blueprints containing the routes for various functionality of the web app. The blueprints exist as follows:

### Auth

The `auth` blueprint contains the functionality related to authentication, which in this case is only one route, `/login`.

#### `/login`


The login route uses the `POST` method and takes a user email and password in the body of the request, which it authenticate the user and return the user id and role (`manager`, `haircutter`, `customer`). 

### Store

The `store` blueprint contains the functionality related to the use of the barbershop store.

#### `/inventory`

The inventory route uses the `GET` method and returns a list of all the invenory items and their relevant details.


### Managers

The `managers` blueprint contains the functionality related to usage of the web app by a user with the `manager` role.

#### `/manager/<manager_id>`

The manager route uses the `GET` method and returns the profile information for the given manager.

#### `/manager/<manager_id>/haircutters`

The haircutters route uses the `GET` method and returns the haircutters which are managed by the given manager.

#### `/haircut_types`

The haircut types route uses the `GET` method and returns all the different haircut types that exist.

#### `/availabilities`

The availabilities route uses the `GET` method and returns the availabilities of all haircutters.

#### `/appointments`

The appointments route uses the `GET` method and returns all existing appointments.


### Haircutters

The `haircutters` blueprint contains the functionality related to usage of the web app by a user with the `haircutter` role.

#### `/haircutters`

The haircutters route uses the `GET` method and returns a list of all existing haircutters.

#### `/haircutter/<haircutter_id>`

The haircutter route uses the `GET` method and returns the profile information for the given manager.

#### `/haircutter/<haircutter_id>/specialties`

The specialties route uses the `GET` method and returns the specialties of the given haircutters (what haircut types they can do).

#### `/haircutter/<haircutter_id>/availability`

The availability route uses the `GET` method and returns the availability of a given haircutter.

#### `/haircutter/<haircutter_id>/appointments`

The appointments route uses the `GET` method and returns the appointments of a given haircutter.


### Customers

The `customers` blueprint contains the functionality related to usage of the web app by a user with the `customer` role.

#### `/customer/<customer_id>`

The customer route uses the `GET` method and returns the profile information for the given customer.

#### `/customer/<customer_id>/appointments`

The appointments route uses the `GET` method and returns the appointments of the given customer.

#### `/customer/<customer_id>/make_appointment`

The make appointment route uses the `POST` method and takes a haircut type id, haircutter id, start time, and end time in the body of the request, which it uses to attempt to schedule an appointment and return the status of the appointment creation.

#### `/customer/<customer_id>/purchases`

The purchases route uses the `GET` method and returns a list of the purchases of the given customer.

