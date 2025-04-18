-- Active: 1744645740469@@127.0.0.1@5432@bookstore_db@public

-- This line for create the database

CREATE DATABASE bookstore_db;

-- Create the books table
CREATE TABLE books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) CHECK (price >= 0),
    stock INTEGER NOT NULL,
    published_year INTEGER NOT NULL
);

-- Create the customers table
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    joined_date DATE DEFAULT CURRENT_DATE
);

-- Create the orders table
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(id),
    book_id INTEGER REFERENCES books(id),
    quantity INTEGER CHECK (quantity > 0),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- For inserting books table data
INSERT INTO books (title, author, price, stock, published_year) VALUES
('The Catcher in the Rye', 'J.D. Salinger', 11.99, 5, 1951),
('Pride and Prejudice', 'Jane Austen', 9.50, 0, 1813),
('Atomic Habits', 'James Clear', 16.20, 12, 2018),
('Clean Code', 'Robert C. Martin', 32.99, 7, 2008),
('The Lean Startup', 'Eric Ries', 19.99, 0, 2011), 
('Educated', 'Tara Westover', 14.75, 3, 2018),
('The Alchemist', 'Paulo Coelho', 13.49, 20, 1988);

-- For inserting customers table data
INSERT INTO customers (name, email, joined_date) VALUES
('Emily Carter', 'emily.carter@example.com', '2023-05-22'),
('David Miller', 'david.miller@example.com', '2023-06-14'),
('Sophia Thompson', 'sophia.t@example.com', '2023-07-01'),
('Liam Rodriguez', 'liam.rodriguez@example.com', '2024-01-20'),
('Olivia Martinez', 'olivia.martinez@example.com', '2024-02-10');


-- For inserting orders table data
INSERT INTO orders (customer_id, book_id, quantity, order_date) VALUES
(1, 1, 1, '2023-06-01 10:30:00'),
(1, 3, 2, '2023-06-03 14:12:00'),
(2, 4, 1, '2023-06-15 09:45:00'),
(3, 6, 1, '2023-07-05 17:22:00'),
(4, 7, 3, '2024-02-01 11:00:00');

-- For seeing the table data 

SELECT * FROM books;
SELECT * FROM customers;
SELECT * FROM orders;

-- This is for drop the tables don't touch just for practice
DROP TABLE orders;
DROP TABLE books;
DROP TABLE customers;


-- 1.  Find books that are out of stock.
SELECT title FROM books
WHERE stock = 0;

-- 2. Retrieve the most expensive book in the store.
SELECT * FROM books ORDER BY price DESC
LIMIT 1;

-- 3. Find the total number of orders placed by each customer.

SELECT customers.name, COUNT(orders.id) AS total_orders FROM customers
LEFT JOIN orders ON customers.id = orders.customer_id
GROUP BY customers.id, customers.name  
ORDER BY total_orders DESC;         


-- 4. Calculate the total revenue generated from book sales.

SELECT SUM(books.price * orders.quantity) AS total_revenue FROM orders
JOIN books ON orders.book_id = books.id;

-- 5. List all customers who have placed more than one order.

SELECT customers.name, COUNT(orders.id) AS orders_count FROM customers
JOIN orders ON customers.id = orders.customer_id
GROUP BY customers.id, customers.name
HAVING COUNT(orders.id) > 1;

-- 6. Find the average price of books in the store.

SELECT AVG(price) AS avg_book_price FROM books;

-- 7. Increase the price of all books published before 2000 by 10%.
UPDATE books
SET price = price * 1.10
WHERE published_year < 2000;

-- 8. Delete customers who haven't placed any orders.
DELETE FROM customers
WHERE id NOT IN (SELECT DISTINCT customer_id FROM orders);
