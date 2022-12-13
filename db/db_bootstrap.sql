-- This file is to bootstrap a database for the CS3200 project. 

-- Create a new database.  You can change the name later.  You'll
-- need this name in the FLASK API file(s),  the AppSmith 
-- data source creation.
create database BARBERSHOP;

-- Via the Docker Compose file, a special user called webapp will 
-- be created in MySQL. We are going to grant that user
-- all privilages to the new database we just created. 
-- TODO: If you changed the name of the database above, you need 
-- to change it here too.
GRANT ALL PRIVILEGES ON BARBERSHOP.* TO 'webapp'@'%';
FLUSH PRIVILEGES;

-- Move into the database we just created.
-- TODO: If you changed the name of the database above, you need to
-- change it here too. 
USE BARBERSHOP;


-- create users table
CREATE TABLE users (
    id INT NOT NULL AUTO_INCREMENT,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(255) NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

-- sample users data
INSERT INTO users 
    (email, password, phone, first_name, last_name) 
VALUES
    ('manager@gmail.com', 'password', '955-568-6484', 'Loree', 'Jean'),
    ('epiggen1@sun.com', 'NpMHAO4CdIXb', '958-597-3254', 'Ellissa', 'Piggen'),
    ('haircutter@gmail.com', 'password', '473-781-4144', 'Laurianne', 'Swanton'),
    ('dsdawdawd@gmail.com', 'd@(*YR(GD(WJJ', '123-456-7890', 'David', 'Sdawdawd'),
    ('john.smith@gmail.com', 'mysecretpassword', '555-555-5555', 'John', 'Smith'),
    ('jane.doe@gmail.com', 'securepassword', '444-444-4444', 'Jane', 'Doe'),
    ('customer@gmail.com', 'password', '333-333-3333', 'Mike', 'Johnson'),
    ('emily.lee@gmail.com', 'letmein', '222-222-2222', 'Emily', 'Lee'),
    ('david.brown@gmail.com', 'qwerty123', '111-111-1111', 'David', 'Brown'),
    ('samantha.williams@gmail.com', 'mypassword', '123-456-7890', 'Samantha', 'Williams'),
    ('mark.taylor@gmail.com', 'pa$$word', '987-654-3210', 'Mark', 'Taylor'),
    ('sarah.jones@gmail.com', 'password123', '456-789-0123', 'Sarah', 'Jones'),
    ('alex.moore@gmail.com', 'letmein123', '789-456-1230', 'Alex', 'Moore'),
    ('laura.miller@gmail.com', 'securepassword123', '159-753-8410', 'Laura', 'Miller');
  


-- create managers table
CREATE TABLE managers (
    manager_id INT NOT NULL,
    store_id INT NOT NULL,
    job_start_date DATE NOT NULL,
    PRIMARY KEY (manager_id),
    FOREIGN KEY (manager_id) REFERENCES users(id)
);

-- sample managers data
INSERT INTO 
    managers (manager_id, store_id, job_start_date) 
VALUES
    (1, 101, '2022-01-01'),
    (2, 202, '2020-05-15');

-- create haircutters table
CREATE TABLE haircutters (
    haircutter_id INT NOT NULL,
    manager_id INT NOT NULL,
    job_start_date DATE NOT NULL,
    years_of_experience INT NOT NULL,
    PRIMARY KEY (haircutter_id),
    FOREIGN KEY (manager_id) REFERENCES managers(manager_id),
    FOREIGN KEY (haircutter_id) REFERENCES users(id)
);

-- sample haircutters data
INSERT INTO haircutters
    (haircutter_id, manager_id, job_start_date, years_of_experience)
VALUES
    (3, 1, '2021-02-14', 3),
    (4, 1, '2020-09-01', 5),
    (5, 2, '2022-04-01', 2),
    (6, 2, '2021-07-05', 1);


-- create customers table
CREATE TABLE customers (
    customer_id INT NOT NULL,
    last_visit DATE,
    num_visits INT NOT NULL,
    PRIMARY KEY (customer_id),
    FOREIGN KEY (customer_id) REFERENCES users(id)
);

-- sample customers data
INSERT INTO customers 
    (customer_id, last_visit, num_visits) 
VALUES 
    (7, '2022-06-01', 2),
    (8, '2022-08-15', 3),
    (9, NULL, 0),
    (10, '2022-03-01', 1),
    (11, '2022-09-01', 3),
    (12, '2022-05-12', 4),
    (13, '2022-07-01', 2),
    (14, '2022-11-01', 1);

-- create haircut type table
CREATE TABLE haircut_types (
    haircut_type_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (haircut_type_id)
);

-- sample haircut type data
INSERT INTO haircut_types 
    (name, description, price) 
VALUES 
    ('Haircut', 'A haircut', 20.00),
    ('Shave', 'A shave', 10.00),
    ('Haircut and Shave', 'A haircut and a shave', 25.00),
    ('Haircut and Beard Trim', 'A haircut and a beard trim', 25.00),
    ('Beard Trim', 'A beard trim', 10.00),
    ('Haircut and Beard Trim and Shave', 'A haircut and a beard trim and a shave', 30.00);


-- create favorite template table
CREATE TABLE favorite_templates (
    customer_id INT NOT NULL,
    haircutter_id INT NOT NULL,
    haircut_type_id INT NOT NULL,
    PRIMARY KEY (customer_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (haircutter_id) REFERENCES haircutters(haircutter_id),
    FOREIGN KEY (haircut_type_id) REFERENCES haircut_types(haircut_type_id)
);

-- sample favorite template data
INSERT INTO favorite_templates 
    (customer_id, haircutter_id, haircut_type_id)
VALUES
    (7, 3, 1),
    (8, 4, 2),
    (9, 5, 3),
    (10, 6, 4),
    (11, 3, 5),
    (12, 4, 6),
    (13, 5, 1),
    (14, 6, 2);


-- create specialties table
CREATE TABLE specialties (
    haircutter_id INT NOT NULL,
    haircut_type_id INT NOT NULL,
    PRIMARY KEY (haircutter_id, haircut_type_id),
    FOREIGN KEY (haircutter_id) REFERENCES haircutters(haircutter_id),
    FOREIGN KEY (haircut_type_id) REFERENCES haircut_types(haircut_type_id)
);

-- sample specialties data
INSERT INTO specialties 
    (haircutter_id, haircut_type_id)
VALUES
    (3, 1),
    (3, 2),
    (3, 4),
    (4, 5),
    (5, 3),
    (5, 6),
    (6, 1),
    (6, 2),
    (6, 3),
    (6, 4),
    (6, 5);


-- create availabilities table
CREATE TABLE availabilities (
    haircutter_id INT NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    PRIMARY KEY (haircutter_id, start_time, end_time),
    FOREIGN KEY (haircutter_id) REFERENCES haircutters(haircutter_id)
);

-- sample availabilities data
INSERT INTO availabilities 
    (haircutter_id, start_time, end_time)
VALUES
    (3, '2018-01-01 09:00:00', '2018-01-01 17:00:00'),
    (3, '2018-01-02 09:00:00', '2018-01-02 17:00:00'),
    (4, '2018-01-01 09:00:00', '2018-01-01 17:00:00'),
    (4, '2018-01-02 09:00:00', '2018-01-02 17:00:00'),
    (5, '2018-01-01 09:00:00', '2018-01-01 17:00:00'),
    (5, '2018-01-02 09:00:00', '2018-01-02 17:00:00'),
    (6, '2018-01-01 09:00:00', '2018-01-01 17:00:00'),
    (6, '2018-01-02 09:00:00', '2018-01-02 17:00:00'),
    (6, '2018-01-03 09:00:00', '2018-01-03 17:00:00');



-- create appointments table
CREATE TABLE appointments (
    appointment_id INT NOT NULL AUTO_INCREMENT,
    haircut_type_id INT NOT NULL,
    haircutter_id INT NOT NULL,
    customer_id INT NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    PRIMARY KEY (appointment_id),
    FOREIGN KEY (haircut_type_id) REFERENCES haircut_types(haircut_type_id),
    FOREIGN KEY (haircutter_id) REFERENCES haircutters(haircutter_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- sample appointments data
INSERT INTO appointments 
    (haircut_type_id, haircutter_id, customer_id, start_time, end_time)
VALUES
    (1, 3, 7, '2018-01-01 10:00:00', '2018-01-01 10:30:00'),
    (2, 3, 8, '2018-01-01 11:00:00', '2018-01-01 11:30:00'),
    (3, 4, 9, '2018-01-01 12:00:00', '2018-01-01 12:30:00'),
    (4, 6, 10, '2018-01-01 13:00:00', '2018-01-01 13:30:00'),
    (5, 5, 11, '2018-01-01 14:00:00', '2018-01-01 14:30:00'),
    (6, 4, 12, '2018-01-01 15:00:00', '2018-01-01 15:30:00'),
    (1, 3, 13, '2018-01-01 16:00:00', '2018-01-01 16:30:00'),
    (2, 4, 14, '2018-01-01 17:00:00', '2018-01-01 17:30:00');



-- create sales table
CREATE TABLE sales (
    sale_id INT NOT NULL AUTO_INCREMENT,
    customer_id INT NOT NULL,
    sale_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (sale_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- sample sales data
INSERT INTO sales 
    (customer_id, sale_time)
VALUES
    (7, '2018-01-01 10:00:00'),
    (7, '2018-01-02 10:23:00'),
    (8, '2018-01-01 11:00:00'),
    (8, '2018-01-02 12:00:00'),
    (9, '2018-01-01 12:00:00'),
    (10, '2018-01-01 13:00:00'),
    (11, '2018-01-01 14:00:00'),
    (12, '2018-01-01 15:00:00'),
    (13, '2018-01-01 16:00:00'),
    (14, '2018-01-01 17:00:00');


-- create suppliers table
CREATE TABLE suppliers (
    supplier_id INT NOT NULL AUTO_INCREMENT,
    company_name VARCHAR(255) NOT NULL,
    contact_phone VARCHAR(255) NOT NULL,
    contact_email VARCHAR(255) NOT NULL,
    PRIMARY KEY (supplier_id)
);

-- sample suppliers data
INSERT INTO suppliers 
    (company_name, contact_phone, contact_email)
VALUES
    ('Jaxbean', '457-235-4288', 'bducroe0@bluehost.com'),
    ('Thoughtstorm', '231-355-1933', 'aizac1@theglobeandmail.com'),
    ('Yakijo', '372-259-8883', 'ctheis2@usatoday.com'),
    ('Acme Corporation', '555-555-5555', 'acme@gmail.com'),
    ('Best Suppliers Inc.', '444-444-4444', 'bestsuppliers@gmail.com'),
    ('Top Quality Products', '333-333-3333', 'topquality@gmail.com'),
    ('Superior Supplies Co.', '222-222-2222', 'superiorsupplies@gmail.com'),
    ('Premier Provisions', '111-111-1111', 'premierprovisions@gmail.com');


-- create inventory item table
CREATE TABLE inventory_items (
    item_id INT NOT NULL AUTO_INCREMENT,
    supplier_id INT NOT NULL,
    item_name VARCHAR(255) NOT NULL,
    sale_price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL,
    PRIMARY KEY (item_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

-- sample inventory item data
INSERT INTO inventory_items 
    (supplier_id, item_name, sale_price, stock_quantity)
VALUES
    (1, 'Hair Gel', 5.00, 19),
    (2, 'Scissors', 3.00, 4),
    (3, 'Shampoo', 7.00, 13),
    (7, 'Hair Clippers', 49.99, 10),
    (6, 'Barber Cape', 19.99, 25),
    (8, 'Hair Cutting Shears', 89.99, 5),
    (1, 'Shaving Cream', 9.99, 50),
    (4, 'Razor Blades', 7.99, 100),
    (5, 'Aftershave Lotion', 14.99, 75);


-- create sales item table
CREATE TABLE sale_items (
    sale_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (sale_id, item_id),
    FOREIGN KEY (sale_id) REFERENCES sales(sale_id),
    FOREIGN KEY (item_id) REFERENCES inventory_items(item_id)
);

-- sample sales item data
INSERT INTO sale_items 
    (sale_id, item_id, quantity)
VALUES
    (1, 1, 2),
    (1, 2, 10),
    (1, 6, 1),
    (1, 3, 1),
    (2, 5, 3),
    (2, 3, 1),
    (2, 7, 2),
    (3, 8, 5),
    (3, 9, 2),
    (4, 2, 1),
    (4, 3, 7),
    (5, 8, 3),
    (6, 2, 2),
    (6, 5, 9),
    (7, 6, 2),
    (7, 4, 1),
    (8, 7, 5),
    (8, 2, 1),
    (8, 3, 2);