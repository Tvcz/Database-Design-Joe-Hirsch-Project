# Haircutify Database Design Project

This repo is my implementation of a backend for a web app used for the organization and management of data at a barbershop. 

It includes a total of 16 routes in 5 flask blueprints, 14 routes of which use `GET` and 2 of which use `POST`.

The frontend for the app exists on AppSmith and can be accessed [here](https://appsmith.cs3200.net/app/haircutify/login-639360725bc9880dbcb21433).

Created by Joseph Hirsch (hirsch.jos@northeastern.edu).



## Flask organization

The Flask code is organized into blueprints containing the routes for various functionality of the web app. The blueprints exist as follows:

### Auth

The `auth` blueprint contains the functionality related to authentication, which in this case is only one route, `/login`.

##### `/login`


The login route uses the `POST` method and takes a user email and password in the body of the request, which it authenticate the user and return the user id and role (`manager`, `haircutter`, `customer`). 

### Store

The `store` blueprint contains the functionality related to the use of the barbershop store.

##### `/inventory`

The inventory route uses the `GET` method and returns a list of all the invenory items and their relevant details.


### Managers

The `managers` blueprint contains the functionality related to usage of the web app by a user with the `manager` role.

##### `/manager/<manager_id>`

The manager route uses the `GET` method and returns the profile information for the given manager.

##### `/manager/<manager_id>/haircutters`

The haircutters route uses the `GET` method and returns the haircutters which are managed by the given manager.

##### `/haircut_types`

The haircut types route uses the `GET` method and returns all the different haircut types that exist.

##### `/availabilities`

The availabilities route uses the `GET` method and returns the availabilities of all haircutters.

##### `/appointments`

The appointments route uses the `GET` method and returns all existing appointments.


### Haircutters

The `haircutters` blueprint contains the functionality related to usage of the web app by a user with the `haircutter` role.

##### `/haircutters`

The haircutters route uses the `GET` method and returns a list of all existing haircutters.

##### `/haircutter/<haircutter_id>`

The haircutter route uses the `GET` method and returns the profile information for the given manager.

##### `/haircutter/<haircutter_id>/specialties`

The specialties route uses the `GET` method and returns the specialties of the given haircutters (what haircut types they can do).

##### `/haircutter/<haircutter_id>/availability`

The availability route uses the `GET` method and returns the availability of a given haircutter.

##### `/haircutter/<haircutter_id>/appointments`

The appointments route uses the `GET` method and returns the appointments of a given haircutter.


### Customers

The `customers` blueprint contains the functionality related to usage of the web app by a user with the `customer` role.

##### `/customer/<customer_id>`

The customer route uses the `GET` method and returns the profile information for the given customer.

##### `/customer/<customer_id>/appointments`

The appointments route uses the `GET` method and returns the appointments of the given customer.

##### `/customer/<customer_id>/make_appointment`

The make appointment route uses the `POST` method and takes a haircut type id, haircutter id, start time, and end time in the body of the request, which it uses to attempt to schedule an appointment and return the status of the appointment creation.

##### `/customer/<customer_id>/purchases`

The purchases route uses the `GET` method and returns a list of the purchases of the given customer.



## AppSmith App Organization

The frontend for the app, created on AppSmith, has a total of 14 distinct pages, shown below.

#### Login Page

![image](https://user-images.githubusercontent.com/46767048/207463740-6425ecde-6562-4db3-a2bc-5c160760ddcb.png)

### Manager Pages

#### Manager Home Page

![image](https://user-images.githubusercontent.com/46767048/207463794-7c5b380b-0659-4cb1-bd78-7c6cac2b57cf.png)

#### Manager Inventory View

![image](https://user-images.githubusercontent.com/46767048/207463840-99c236ec-1a19-41ef-8c72-84b3b70c0485.png)

#### Manager Haircutters View

![image](https://user-images.githubusercontent.com/46767048/207463880-c9e812cb-096b-45ff-8738-2e943cef9b19.png)

#### Manager Haircut Types View

![image](https://user-images.githubusercontent.com/46767048/207463925-4be17655-824a-4822-8bbb-05b554df8723.png)

#### Manager Availabilities View

![image](https://user-images.githubusercontent.com/46767048/207463975-a279d3a5-1148-4c4a-add2-b9b3b2654e37.png)

#### Manager Appointments View

![image](https://user-images.githubusercontent.com/46767048/207464033-a1f821de-27cc-4ad1-a408-bf9c676db8f2.png)

### Haircutter Pages

#### Haircutter Home Page

![image](https://user-images.githubusercontent.com/46767048/207464156-a1cd8abc-b522-4d93-a572-a198c0998e30.png)

#### Haircutter Specialties View

![image](https://user-images.githubusercontent.com/46767048/207464203-018bb35f-aef4-4247-a87d-36b5f97b0234.png)

#### Haircutter Availability View

![image](https://user-images.githubusercontent.com/46767048/207464262-365141f3-ee5f-49bb-8d70-f3659500f8a0.png)

#### Haircutter Appointments View

![image](https://user-images.githubusercontent.com/46767048/207464310-24e8ac41-c109-43e9-b3d7-6473a3fd40b0.png)

### Customer Pages

#### Customer Home Page

![image](https://user-images.githubusercontent.com/46767048/207464420-cf8dfa11-da0c-4001-a569-104253faaefc.png)

#### Customer Appointments Page

![image](https://user-images.githubusercontent.com/46767048/207464464-e58d7af0-d6d7-40d0-8a52-846f4e6a2397.png)

#### Customer Store Page

![image](https://user-images.githubusercontent.com/46767048/207464584-4d6a6801-f463-430a-8f7d-4058ba214b7d.png)
