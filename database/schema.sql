CREATE DATABASE IF NOT EXISTS multi_vendor_ecommerce;
USE multi_vendor_ecommerce;


CREATE TABLE IF NOT EXISTS Vendors (
    vendor_id INT AUTO_INCREMENT PRIMARY KEY,
    vendor_name VARCHAR(255),
    vendor_email VARCHAR(255),
    vendor_password VARCHAR(255),
    vendor_address TEXT,
    vendor_phone VARCHAR(20),
    vendor_rating DECIMAL(2,1) DEFAULT 0.0
);


CREATE TABLE IF NOT EXISTS Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    vendor_id INT,
    product_name VARCHAR(255),
    product_description TEXT,
    product_price DECIMAL(10,2),
    product_category VARCHAR(255),
    product_stock INT DEFAULT 0,
    product_rating DECIMAL(2,1) DEFAULT 0.0,
    FOREIGN KEY (vendor_id) REFERENCES Vendors(vendor_id) ON DELETE CASCADE
);


INSERT INTO Vendors (vendor_name, vendor_email, vendor_password, vendor_address, vendor_phone)
VALUES ('TechStore', 'tech@store.com', 'techpass', '123 Tech St', '555-1111');

INSERT INTO Products (vendor_id, product_name, product_description, product_price, product_category, product_stock)
VALUES (1, 'Smartphone X', 'Latest model of Smartphone X', 799.99, 'Electronics', 50);
