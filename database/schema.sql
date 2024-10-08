CREATE DATABASE IF NOT EXISTS multi_vendor_ecommerce;
USE multi_vendor_ecommerce;

-- Vendors Table
CREATE TABLE IF NOT EXISTS Vendors (
    vendor_id INT AUTO_INCREMENT PRIMARY KEY,
    vendor_name VARCHAR(255),
    vendor_email VARCHAR(255),
    vendor_password VARCHAR(255),
    vendor_address TEXT,
    vendor_phone VARCHAR(20),
    vendor_rating DECIMAL(2,1) DEFAULT 0.0
);

-- Products Table
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

-- Insert Vendors (Update for clothing store)
INSERT INTO Vendors (vendor_name, vendor_email, vendor_password, vendor_address, vendor_phone)
VALUES ('FashionHub', 'contact@fashionhub.com', 'fashionpass', '456 Fashion Ave', '555-2222');

-- Insert Products (Clothing-focused products)
INSERT INTO Products (vendor_id, product_name, product_description, product_price, product_category, product_stock)
VALUES 
(1, 'Men\'s Casual Shirt', 'Stylish and comfortable casual shirt', 29.99, 'Clothing', 100),
(1, 'Women\'s Summer Dress', 'Elegant summer dress in various colors', 49.99, 'Clothing', 75),
(1, 'Unisex Hoodie', 'Cozy unisex hoodie for all seasons', 39.99, 'Clothing', 120);

-- Insert Vendors
INSERT INTO Vendors (vendor_name, vendor_email, vendor_password, vendor_address, vendor_phone, vendor_image)
VALUES 
('FashionHub', 'contact@fashionhub.com', 'fashionpass', '456 Fashion Ave', '555-2222', 'vendor1.jpg'),
('TechStore', 'tech@store.com', 'techpass', '123 Tech St', '555-1111', 'vendor2.jpg'),
('GadgetWorld', 'info@gadgetworld.com', 'gadgetpass', '789 Gadget Blvd', '555-3333', 'vendor3.jpg'),
('Clothique', 'support@clothique.com', 'clothpass', '101 Clothing Ln', '555-4444', 'vendor4.jpg'),
('HomeEssentials', 'service@homeessentials.com', 'homepass', '55 Home St', '555-5555', 'vendor5.jpg');

-- Update Vendor Images (if missing or incorrect)
UPDATE Vendors 
SET vendor_image = 'vendor1.jpg' 
WHERE vendor_name = 'FashionHub';

UPDATE Vendors 
SET vendor_image = 'vendor2.jpg' 
WHERE vendor_name = 'TechStore';

UPDATE Vendors 
SET vendor_image = 'vendor3.jpg' 
WHERE vendor_name = 'GadgetWorld';


-- Update Product Stock for a specific product
UPDATE Products 
SET product_stock = 150 
WHERE product_name = 'Men\'s Casual Shirt';

-- Update Product Description for a specific product
UPDATE Products 
SET product_description = 'High-quality unisex hoodie for casual wear.'
WHERE product_name = 'Unisex Hoodie';

-- Delete a vendor by name
DELETE FROM Vendors 
WHERE vendor_name = 'Clothique';

-- Delete a product by name
DELETE FROM Products 
WHERE product_name = 'Smartphone X';

-- Check all Vendors
SELECT * FROM Vendors;

-- Check all Products
SELECT * FROM Products;


-- Insert More Electronic Products
INSERT INTO Products (vendor_id, product_name, product_description, product_price, product_category, product_stock, product_image)
VALUES 
(2, 'Smartphone Y', 'Next-generation smartphone with advanced features', 899.99, 'Electronics', 45, 'smartphone_y.jpg'),
(2, 'Tablet Pro', 'High-performance tablet for work and entertainment', 599.99, 'Electronics', 60, 'tablet_pro.jpg'),
(2, 'Smartwatch Z', 'Stylish smartwatch with health monitoring features', 249.99, 'Electronics', 100, 'smartwatch_z.jpg'),
(2, 'Gaming Laptop X1', 'Powerful gaming laptop with cutting-edge graphics', 1299.99, 'Electronics', 30, 'gaming_laptop_x1.jpg'),
(2, 'Wireless Earbuds', 'True wireless earbuds with noise cancellation', 149.99, 'Electronics', 80, 'wireless_earbuds.jpg');


SELECT DISTINCT p.product_id, p.product_name, p.product_description, p.product_price, p.product_category, p.product_stock, v.vendor_name
FROM Products p
JOIN Vendors v ON p.vendor_id = v.vendor_id
ORDER BY p.product_name;


-- if there is duplicacy in products
SELECT product_name, COUNT(*)
FROM Products
GROUP BY product_name
HAVING COUNT(*) > 1;

DELETE p1
FROM Products p1
INNER JOIN Products p2 
WHERE 
    p1.product_id > p2.product_id 
    AND p1.product_name = p2.product_name;


SELECT DISTINCT product_category FROM Products;

UPDATE Products
SET product_category = 'Fashion'
 WHERE product_category = 'Clothing';

 UPDATE Products
SET product_category = 'Home'
WHERE product_name LIKE '%Home%';  -- Or adjust based on your product

 UPDATE Products
SET product_category = 'Sports'
WHERE product_name LIKE '%Sports%';  -- Or adjust based on your produc

INSERT INTO Products (vendor_id, product_name, product_description, product_price, product_category, product_stock, product_image)
     VALUES
    (1, 'Sports T-shirt', 'Comfortable sportswear', 19.99, 'Sports', 50, 'sports_tshirt.jpg'),
     (1, 'Home Decor Lamp', 'Stylish table lamp for home', 29.99, 'Home', 30, 'home_decor_lamp.jpg');

SELECT DISTINCT product_category FROM Products;

-- For Home Category Products
UPDATE Products 
SET product_image = 'home_decor_1.jpg' 
WHERE product_category = 'Home';

UPDATE Products 
SET product_image = 'sport_tshirt_1.jpg' 
WHERE product_category = 'Sports';

UPDATE Products 
SET product_image = 'sport_tshirt_2.jpg' 
WHERE product_category = 'Sports';

UPDATE Products 
SET product_image = 'sport_tshirt_3.jpg' 
WHERE product_category = 'Sports';

SELECT * FROM Products WHERE product_category = 'Sports';

-- Inserting multiple Sports products
INSERT INTO Products (vendor_id, product_name, product_description, product_price, product_category, product_stock, product_image)
VALUES 
(2, 'NotBrand', 'Comfortable sports t-shirt for workouts', 19.99, 'Sports', 100, 'sport_tshirt_1.jpg'),
(2, 'BorFend', 'Breathable sports t-shirt for active wear', 22.99, 'Sports', 120, 'sport_tshirt_2.jpg'),
(2, 'Hooligans', 'Stylish sports t-shirt with modern design', 25.99, 'Sports', 80, 'sport_tshirt_3.jpg');

SELECT product_name, COUNT(*) 
FROM Products 
WHERE product_category = 'Sports' 
GROUP BY product_name 
HAVING COUNT(*) > 1;

-- Step 1: Create a temporary table to store unique vendor_id's
CREATE TEMPORARY TABLE tmp_vendors AS
SELECT MIN(vendor_id) AS vendor_id
FROM Vendors
GROUP BY vendor_name;

-- Step 2: Delete duplicates from the original Vendors table
DELETE FROM Vendors
WHERE vendor_id NOT IN (SELECT vendor_id FROM tmp_vendors);

-- Step 3: Drop the temporary table
DROP TEMPORARY TABLE tmp_vendors;
