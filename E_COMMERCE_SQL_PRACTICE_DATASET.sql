CREATE DATABASE E_COMMERCE_SQL_PRACTICE_DATASET;
USE E_COMMERCE_SQL_PRACTICE_DATASET;

-- Categories (extra table for JOIN practice)
CREATE TABLE categories (
    category_id   INT           PRIMARY KEY,
    name          VARCHAR(50)   NOT NULL,
    parent_id     INT           REFERENCES categories(category_id)  -- self-join
);

-- Customers
CREATE TABLE customers (
    customer_id   INT           PRIMARY KEY,
    first_name    VARCHAR(50)   NOT NULL,
    last_name     VARCHAR(50)   NOT NULL,
    email         VARCHAR(100)  UNIQUE NOT NULL,
    phone         VARCHAR(20),
    city          VARCHAR(50),
    state         VARCHAR(50),
    country       VARCHAR(50)   DEFAULT 'India',
    signup_date   DATE          NOT NULL,
    is_premium    BOOLEAN       DEFAULT FALSE
);

-- Products
CREATE TABLE products (
    product_id    INT           PRIMARY KEY,
    name          VARCHAR(100)  NOT NULL,
    category_id   INT           REFERENCES categories(category_id),
    price         DECIMAL(10,2) NOT NULL,
    cost_price    DECIMAL(10,2),
    stock_qty     INT           DEFAULT 0,
    is_active     BOOLEAN       DEFAULT TRUE,
    created_at    DATE          NOT NULL
);

-- Employees (for self-join / hierarchy practice)
CREATE TABLE employees (
    employee_id   INT           PRIMARY KEY,
    name          VARCHAR(80)   NOT NULL,
    role          VARCHAR(50),
    manager_id    INT           REFERENCES employees(employee_id),
    hire_date     DATE,
    salary        DECIMAL(10,2)
);

-- Coupons
CREATE TABLE coupons (
    coupon_id     INT           PRIMARY KEY,
    code          VARCHAR(20)   UNIQUE NOT NULL,
    discount_pct  DECIMAL(5,2),
    min_order_amt DECIMAL(10,2),
    valid_until   DATE
);

-- Orders
CREATE TABLE orders (
    order_id      INT           PRIMARY KEY,
    customer_id   INT           REFERENCES customers(customer_id),
    order_date    DATE          NOT NULL,
    status        VARCHAR(20)   CHECK (status IN ('pending','processing','shipped','delivered','cancelled')),
    coupon_id     INT           REFERENCES coupons(coupon_id),
    shipping_city VARCHAR(50),
    total_amount  DECIMAL(10,2)
);

-- Order Items
CREATE TABLE order_items (
    item_id       INT           PRIMARY KEY,
    order_id      INT           REFERENCES orders(order_id),
    product_id    INT           REFERENCES products(product_id),
    quantity      INT           NOT NULL CHECK (quantity > 0),
    unit_price    DECIMAL(10,2) NOT NULL,
    discount      DECIMAL(5,2)  DEFAULT 0
);

-- Reviews
CREATE TABLE reviews (
    review_id     INT           PRIMARY KEY,
    product_id    INT           REFERENCES products(product_id),
    customer_id   INT           REFERENCES customers(customer_id),
    rating        INT           CHECK (rating BETWEEN 1 AND 5),
    review_text   TEXT,
    review_date   DATE
);

-- ─────────────────────────────────────────────
-- 2. DATA INSERTION  (DML)
-- ─────────────────────────────────────────────

-- Categories (self-join: parent/child)
INSERT INTO categories VALUES
(1,  'Electronics',    NULL),
(2,  'Mobile Phones',  1),
(3,  'Laptops',        1),
(4,  'Clothing',       NULL),
(5,  'Men',            4),
(6,  'Women',          4),
(7,  'Home & Kitchen', NULL),
(8,  'Books',          NULL),
(9,  'Sports',         NULL),
(10, 'Cameras',        1);

-- Customers
INSERT INTO customers VALUES
(1,  'Aarav',   'Sharma',    'aarav@email.com',    '9876543210', 'Mumbai',    'Maharashtra', 'India', '2021-01-15', TRUE),
(2,  'Priya',   'Patel',     'priya@email.com',    '9823456789', 'Ahmedabad', 'Gujarat',     'India', '2021-03-20', FALSE),
(3,  'Rohan',   'Singh',     'rohan@email.com',    '9712345678', 'Delhi',     'Delhi',       'India', '2021-06-05', TRUE),
(4,  'Sneha',   'Kumar',     'sneha@email.com',    '9634567890', 'Bangalore', 'Karnataka',   'India', '2021-07-22', FALSE),
(5,  'Vikram',  'Mehta',     'vikram@email.com',   '9587654321', 'Pune',      'Maharashtra', 'India', '2022-01-10', TRUE),
(6,  'Ananya',  'Joshi',     'ananya@email.com',   '9456789012', 'Hyderabad', 'Telangana',   'India', '2022-02-14', FALSE),
(7,  'Karan',   'Verma',     'karan@email.com',    '9345678901', 'Chennai',   'Tamil Nadu',  'India', '2022-04-01', TRUE),
(8,  'Meera',   'Gupta',     'meera@email.com',    '9234567890', 'Kolkata',   'West Bengal', 'India', '2022-05-18', FALSE),
(9,  'Arjun',   'Nair',      'arjun@email.com',    '9123456789', 'Kochi',     'Kerala',      'India', '2022-08-30', FALSE),
(10, 'Divya',   'Reddy',     'divya@email.com',    '9012345678', 'Hyderabad', 'Telangana',   'India', '2022-10-11', TRUE),
(11, 'Raj',     'Malhotra',  'raj@email.com',      '8901234567', 'Jaipur',    'Rajasthan',   'India', '2023-01-05', FALSE),
(12, 'Pooja',   'Iyer',      'pooja@email.com',    '8812345678', 'Chennai',   'Tamil Nadu',  'India', '2023-03-17', TRUE),
(13, 'Sanjay',  'Chopra',    'sanjay@email.com',   '8723456789', 'Mumbai',    'Maharashtra', 'India', '2023-04-22', FALSE),
(14, 'Neha',    'Bose',      'neha@email.com',     '8634567890', 'Kolkata',   'West Bengal', 'India', '2023-06-09', FALSE),
(15, 'Aditya',  'Tiwari',    'aditya@email.com',   '8545678901', 'Lucknow',   'Uttar Pradesh','India','2023-09-15', TRUE);


-- Products
INSERT INTO products VALUES
(1,  'Samsung Galaxy S23',      2,  69999.00, 55000.00, 50,  TRUE,  '2023-01-01'),
(2,  'iPhone 15',               2,  89999.00, 72000.00, 30,  TRUE,  '2023-09-01'),
(3,  'OnePlus 11',              2,  56999.00, 44000.00, 80,  TRUE,  '2023-02-07'),
(4,  'Dell XPS 15',             3,  139999.00,110000.00,20,  TRUE,  '2023-01-15'),
(5,  'MacBook Air M2',          3,  114999.00, 92000.00, 25, TRUE,  '2023-06-10'),
(6,  'Lenovo ThinkPad E15',     3,  74999.00,  58000.00, 40, TRUE,  '2022-11-01'),
(7,  'Men Formal Shirt',        5,   1299.00,    600.00,200,  TRUE,  '2022-05-01'),
(8,  'Women Kurti Set',         6,   1799.00,    800.00,150,  TRUE,  '2022-05-01'),
(9,  'Running Shoes Men',       9,   3499.00,   1800.00,100,  TRUE,  '2022-08-01'),
(10, 'Yoga Mat',                9,    899.00,    350.00,120,  TRUE,  '2022-09-15'),
(11, 'Instant Pot 6Qt',         7,   8999.00,   5000.00, 60,  TRUE,  '2023-03-01'),
(12, 'Non-Stick Pan Set',       7,   2499.00,   1100.00, 90,  TRUE,  '2023-01-20'),
(13, 'Clean Code (Book)',       8,    699.00,    200.00,200,  TRUE,  '2021-06-01'),
(14, 'Atomic Habits (Book)',    8,    499.00,    150.00,250,  TRUE,  '2021-10-01'),
(15, 'Sony Alpha ZV-E10',      10,  59999.00,  45000.00, 15,  TRUE,  '2023-04-01'),
(16, 'GoPro Hero 11',          10,  39999.00,  30000.00, 20,  TRUE,  '2023-02-15'),
(17, 'Bluetooth Speaker',       1,   3999.00,   1800.00, 75,  TRUE,  '2022-12-01'),
(18, 'Smart Watch',             1,  14999.00,   9000.00, 55,  TRUE,  '2023-05-01'),
(19, 'Discontinued Tablet',     2,  29999.00,  22000.00,  0,  FALSE, '2021-01-01'),
(20, 'Old Laptop Model',        3,  45999.00,  38000.00,  0,  FALSE, '2020-06-01');

-- Employees (hierarchy for self-join)
INSERT INTO employees VALUES
(1,  'Ravi Kapoor',    'CEO',              NULL, '2015-01-01', 500000),
(2,  'Sunita Das',     'VP Sales',            1, '2016-03-15', 300000),
(3,  'Amit Shah',      'VP Operations',       1, '2016-06-01', 280000),
(4,  'Leena Roy',      'Sales Manager',       2, '2018-07-01', 150000),
(5,  'Tarun Bhat',     'Sales Executive',     4, '2020-01-15',  80000),
(6,  'Preethi Nair',   'Sales Executive',     4, '2021-03-01',  75000),
(7,  'Manoj Yadav',    'Ops Manager',         3, '2019-02-01', 140000),
(8,  'Deepa Menon',    'Warehouse Lead',      7, '2020-08-01',  90000);

-- Coupons
INSERT INTO coupons VALUES
(1, 'SAVE10',  10.00,  500.00, '2024-12-31'),
(2, 'PREMIUM20',20.00,1000.00, '2024-06-30'),
(3, 'NEWUSER15',15.00,  300.00,'2024-03-31'),
(4, 'FLASH50',  50.00, 5000.00,'2024-01-15'),
(5, 'EXPIRED5',  5.00,  100.00,'2022-12-31');

-- Orders  (mix of statuses, some with coupons, some NULL)
INSERT INTO orders VALUES
(1001, 1,  '2023-01-20', 'delivered',  1,    'Mumbai',    72999.00),
(1002, 2,  '2023-02-14', 'delivered',  NULL, 'Ahmedabad', 57898.00),
(1003, 3,  '2023-03-05', 'delivered',  2,    'Delhi',    139999.00),
(1004, 4,  '2023-03-18', 'cancelled',  NULL, 'Bangalore',  3499.00),
(1005, 5,  '2023-04-02', 'delivered',  NULL, 'Pune',      91998.00),
(1006, 6,  '2023-04-25', 'delivered',  3,    'Hyderabad',  4796.00),
(1007, 7,  '2023-05-10', 'shipped',    NULL, 'Chennai',   60998.00),
(1008, 8,  '2023-05-22', 'delivered',  1,    'Kolkata',    9898.00),
(1009, 9,  '2023-06-14', 'delivered',  NULL, 'Kochi',      1198.00),
(1010,10,  '2023-06-28', 'processing', 2,    'Hyderabad', 89999.00),
(1011, 1,  '2023-07-04', 'delivered',  NULL, 'Mumbai',    59999.00),
(1012, 3,  '2023-07-19', 'delivered',  NULL, 'Delhi',      5998.00),
(1013,11,  '2023-08-01', 'pending',    NULL, 'Jaipur',     3998.00),
(1014,12,  '2023-08-14', 'delivered',  2,    'Chennai',  114999.00),
(1015,13,  '2023-09-03', 'delivered',  NULL, 'Mumbai',    74999.00),
(1016,14,  '2023-09-20', 'cancelled',  NULL, 'Kolkata',     899.00),
(1017,15,  '2023-10-05', 'delivered',  1,    'Lucknow',   17998.00),
(1018, 2,  '2023-10-17', 'delivered',  NULL, 'Ahmedabad',  2598.00),
(1019, 5,  '2023-11-11', 'shipped',    NULL, 'Pune',      39999.00),
(1020, 7,  '2023-11-25', 'delivered',  4,    'Chennai',   15998.00),
(1021, 1,  '2023-12-01', 'delivered',  NULL, 'Mumbai',     1399.00),
(1022, 4,  '2023-12-15', 'delivered',  NULL, 'Bangalore',  3399.00),
(1023, 8,  '2024-01-05', 'delivered',  3,    'Kolkata',    4298.00),
(1024,10,  '2024-01-18', 'processing', NULL, 'Hyderabad', 14999.00),
(1025, 6,  '2024-02-02', 'delivered',  NULL, 'Hyderabad',  3999.00);

-- Order Items
INSERT INTO order_items VALUES
(1,  1001, 1,  1, 69999.00, 0),
(2,  1001, 10, 3,   899.00, 0),
(3,  1002, 3,  1, 56999.00, 0),
(4,  1002, 13, 1,   699.00, 5),
(5,  1002, 14, 1,   499.00, 5),
(6,  1003, 4,  1,139999.00,10),
(7,  1004, 9,  1,  3499.00, 0),
(8,  1005, 2,  1, 89999.00, 0),
(9,  1005, 14, 4,   499.00, 0),
(10, 1006, 7,  2,  1299.00, 0),
(11, 1006, 8,  1,  1799.00,10),
(12, 1007, 15, 1, 59999.00, 0),
(13, 1007, 17, 1,  3999.00, 5),
(14, 1008, 11, 1,  8999.00, 0),
(15, 1008, 12, 1,  2499.00,10),
(16, 1009, 13, 1,   699.00, 0),
(17, 1009, 14, 1,   499.00, 0),
(18, 1010, 2,  1, 89999.00, 0),
(19, 1011, 15, 1, 59999.00, 0),
(20, 1012, 13, 5,   699.00,10),
(21, 1012, 14, 5,   499.00,10),
(22, 1013, 17, 1,  3999.00, 0),
(23, 1014, 5,  1,114999.00, 0),
(24, 1015, 6,  1, 74999.00, 0),
(25, 1016, 10, 1,   899.00, 0),
(26, 1017, 18, 1, 14999.00, 0),
(27, 1017, 9,  1,  3499.00, 0),
(28, 1018, 7,  2,  1299.00, 0),
(29, 1019, 16, 1, 39999.00, 0),
(30, 1020, 18, 1, 14999.00, 0),
(31, 1020, 9,  1,  3499.00, 0),
(32, 1021, 7,  1,  1299.00, 0),
(33, 1022, 8,  1,  1799.00, 0),
(34, 1022, 7,  1,  1299.00, 0),
(35, 1023, 11, 1,  8999.00,10),
(36, 1024, 18, 1, 14999.00, 0),
(37, 1025, 17, 1,  3999.00, 0);

-- Reviews
INSERT INTO reviews VALUES
(1,  1,  1,  5, 'Excellent phone! Very fast.',           '2023-02-10'),
(2,  2,  3,  4, 'Great iPhone, camera is amazing.',      '2023-04-01'),
(3,  3,  2,  4, 'Good value for money.',                 '2023-03-25'),
(4,  4,  3,  5, 'Best laptop ever!',                     '2023-04-10'),
(5,  5,  12, 5, 'MacBook is flawless.',                  '2023-10-01'),
(6,  6,  15, 3, 'Average build quality.',                '2023-10-15'),
(7,  9,  5,  4, 'Very comfortable shoes.',               '2023-05-15'),
(8,  13, 9,  5, 'Must read for developers.',             '2023-07-01'),
(9,  14, 9,  5, 'Life changing book.',                   '2023-07-02'),
(10, 15, 7,  4, 'Great camera for the price.',           '2023-06-20'),
(11, 17, 6,  3, 'Average sound quality.',                '2023-05-20'),
(12, 18, 10, 5, 'Love the smart watch features.',        '2023-07-28'),
(13, 11, 8,  5, 'Instant Pot is amazing!',               '2023-07-10'),
(14, 1,  5,  4, 'Good phone, battery lasts long.',       '2023-05-08'),
(15, 2,  7,  5, 'iPhone is worth every penny.',          '2023-07-15');

SELECT * FROM CATEGORIES;
SELECT * FROM CUSTOMERS;
SELECT * FROM PRODUCTS;
SELECT * FROM EMPLOYEES;
SELECT * FROM COUPONS;
SELECT * FROM ORDERS;
SELECT * FROM ORDER_ITEMS;
SELECT * FROM REVIEWS;

CREATE INDEX Idx_orders_customer on orders(customer_id);
CREATE INDEX Idx_order_date on orders(order_date);
CREATE INDEX Id_order_items_order on order_items(order_id);
CREATE INDEX Id_product_category on product(category_id);
CREATE INDEX Id_reviews_product on reviews(product_id);


SQL Interview Practice Questions
🟢 Basic Level (1–15)

-- 1. Retrieve the full name, email, and city of all customers who signed up after January 1, 2022. 
SELECT FIRST_NAME, LAST_NAME, EMAIL, CITY
FROM CUSTOMERS
WHERE SIGNUP_DATE >= '2022-01-01';


-- 2. List all products that are currently active and have stock quantity greater than 50.
SELECT * FROM PRODUCTS
WHERE IS_ACTIVE = 1 AND STOCK_QTY > 50;

-- 3. Find all orders that have a status of either 'shipped' or 'pending'.
SELECT * FROM ORDERS
WHERE STATUS = 'SHIPPED' OR STATUS = 'PENDING';

-- 4. Display all customers from Maharashtra or Tamil Nadu, sorted by their signup date in descending order.
SELECT * FROM CUSTOMERS
WHERE state IN ('Maharashtra','Tamil Nadu')
ORDER BY SIGNUP_DATE DESC;

-- 5. List all products whose price is between ₹1,000 and ₹20,000, ordered by price ascending.
SELECT * FROM PRODUCTS
WHERE PRICE BETWEEN 1000 AND 20000;

-- 6. How many orders were placed in each month of 2023? Show the month and order count.
SELECT 
YEAR(ORDER_DATE) AS year,
MONTH(ORDER_DATE) AS month,
COUNT(ORDER_ID) AS TOTAL_ORDER_COUNT
FROM ORDERS
WHERE YEAR(ORDER_DATE) = '2023'
GROUP BY YEAR(ORDER_DATE), MONTH(ORDER_DATE);


-- 7. Find the total number of customers per country.
SELECT * FROM CUSTOMERS;
SELECT CITY, COUNT(CUSTOMER_ID) AS CUSTOMER_COUNT_PER_CITY
FROM CUSTOMERS
GROUP BY CITY
ORDER BY CITY;

-- 8. List all products in the 'Books' category.
SELECT P.NAME,C.CATEGORY_ID,C.NAME
FROM PRODUCTS P 
INNER JOIN CATEGORIES C 
ON P.CATEGORY_ID = C.CATEGORY_ID
WHERE C.NAME = 'BOOKS';

-- 9. Show all orders where no coupon was used (coupon_id is NULL).
SELECT * FROM ORDERS
WHERE COUPON_ID IS NULL;
 
-- 10. Find the most expensive product in the entire catalog.
SELECT NAME , COST_PRICE
FROM (SELECT NAME , COST_PRICE,DENSE_RANK()OVER(ORDER BY COST_PRICE DESC ) AS MOST_EXPENSIVE_PRO
FROM PRODUCTS
)AS E
WHERE  MOST_EXPENSIVE_PRO = 1;

-- 11. How many products belong to each category? Include the category name.

SELECT C.NAME,COUNT(P.PRODUCT_ID) AS PRODUCT_COUNT
FROM PRODUCTS P 
INNER JOIN CATEGORIES C 
ON P.CATEGORY_ID = C.CATEGORY_ID
GROUP BY C.NAME;

-- 12. List all customers whose email contains the domain 'gmail.com'.
SELECT * FROM CUSTOMERS
WHERE EMAIL LIKE '%gmail.com';

-- 13. What is the total revenue generated from all 'delivered' orders?
SELECT SUM(TOTAL_AMOUNT) AS TOTAL_REVENUE_DEL
FROM ORDERS
WHERE STATUS = 'DELIVERED';

-- 14. Show all orders placed in the month of October 2023.
SELECT * FROM ORDERS
WHERE YEAR(ORDER_DATE) = 2023 AND MONTH(ORDER_DATE) = 10;

-- 15. Find all products where the product name contains the word 'Book'.
SELECT * FROM PRODUCTS
WHERE NAME LIKE '%BOOK%';
								


-- 🟡 Intermediate Level (16–35)

-- 16. List each customer along with the total number of orders they have placed. Include customers with zero orders. 
SELECT * FROM CUSTOMERS;
SELECT * FROM ORDERS;
SELECT C.CUSTOMER_ID,C.FIRST_NAME,COUNT(O.ORDER_ID) AS TOTAL_NUM_ORDER
FROM CUSTOMERS C 
LEFT JOIN ORDERS O 
ON O.CUSTOMER_ID =  C.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID,C.FIRST_NAME

-- 17. Find the top 5 best-selling products by total quantity sold.
SELECT P.PRODUCT_ID,P.NAME,SUM(OI.QUANTITY)AS TOTAL_QTY_SOLVE
FROM PRODUCTS P 
INNER JOIN ORDER_ITEMS OI 
ON P.PRODUCT_ID = OI.PRODUCT_ID
INNER JOIN ORDERS O 
ON O.ORDER_ID = OI.ORDER_ID
GROUP BY P.PRODUCT_ID,P.NAME
ORDER BY TOTAL_QTY_SOLVE DESC
LIMIT 5;

-- 18. Show all orders along with the customer's full name, order date, and total amount — sorted by total amount descending.
SELECT C.CUSTOMER_ID,C.FIRST_NAME,C.LAST_NAME,O.ORDER_DATE,O.TOTAL_AMOUNT
FROM CUSTOMERS C 
INNER JOIN ORDERS O 
ON C.CUSTOMER_ID = O.CUSTOMER_ID
ORDER BY TOTAL_AMOUNT DESC;

 




















