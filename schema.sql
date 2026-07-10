-- Database Creation Script for FoodRush
CREATE DATABASE IF NOT EXISTS foodrush_db;
USE foodrush_db;

-- 1. Create users table
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    role VARCHAR(50) DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Create restaurants table
CREATE TABLE IF NOT EXISTS restaurants (
    restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    cuisine VARCHAR(255),
    address TEXT,
    rating DOUBLE,
    delivery_time INT,
    image_url VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE
);

-- 3. Create menu_items table
CREATE TABLE IF NOT EXISTS menu_items (
    menu_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT,
    item_name VARCHAR(255) NOT NULL,
    description TEXT,
    price DOUBLE NOT NULL,
    category VARCHAR(255),
    image_url VARCHAR(255),
    is_available BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id) ON DELETE CASCADE
);

-- 4. Create orders table
CREATE TABLE IF NOT EXISTS orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    total_amount DOUBLE NOT NULL,
    status VARCHAR(50) DEFAULT 'Pending',
    payment_method VARCHAR(50),
    delivery_address TEXT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 5. Create order_items table
CREATE TABLE IF NOT EXISTS order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    menu_id INT,
    quantity INT NOT NULL,
    price DOUBLE NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (menu_id) REFERENCES menu_items(menu_id) ON DELETE CASCADE
);

-- 6. Insert initial records (Admin, Customers, Restaurants, Menus, and Sample Orders)
-- User passwords: admin123 for Admin, user123 for Customers (hashed using BCrypt)
INSERT INTO users (name, email, password, phone, address, role) VALUES
('Admin FoodRush', 'admin@foodrush.com', '$2b$12$KsBaNeSH00oi0AiD.jU/qubNGcbiGjgkBXkpJI41YdGJVZPim/8vW', '9876543210', 'FoodRush HQ, Sector 5', 'admin'),
('John Doe', 'john@example.com', '$2b$12$NK1OpytuUTcWn7gvqd/8LeeaTptippK6MRLgf25yE42JSO27KMiy2', '8765432109', '123 Main St, New York', 'customer'),
('Jane Smith', 'jane@example.com', '$2b$12$NK1OpytuUTcWn7gvqd/8LeeaTptippK6MRLgf25yE42JSO27KMiy2', '7654321098', '456 Oak St, Boston', 'customer'),
('Robert Johnson', 'robert@example.com', '$2b$12$NK1OpytuUTcWn7gvqd/8LeeaTptippK6MRLgf25yE42JSO27KMiy2', '6543210987', '789 Elm St, Chicago', 'customer');

-- Insert Sample Restaurants
INSERT INTO restaurants (name, cuisine, address, rating, delivery_time, image_url, is_active) VALUES
('KFC', 'Fried Chicken, Fast Food', '101 Elm St, Seattle', 4.3, 35, 'assets/images/restaurants/kfc.jpg', TRUE),
('Dominos Pizza', 'Pizza, Italian', '202 Pine St, Boston', 4.5, 30, 'assets/images/restaurants/dominos.jpg', TRUE),
('Burger King', 'Burgers, Fast Food', '303 Oak St, Chicago', 4.2, 25, 'assets/images/restaurants/burger-king.jpg', TRUE),
('Meghana Foods', 'Biryani, Indian', '404 Main St, Bangalore', 4.4, 40, 'assets/images/restaurants/meghana.jpg', TRUE),
('Starbucks', 'Coffee, Desserts', '505 Broadway, New York', 4.1, 20, 'assets/images/restaurants/starbucks.jpg', TRUE);

-- Insert Sample Menu Items
INSERT INTO menu_items (restaurant_id, item_name, description, price, category, image_url, is_available) VALUES
(1, '8 Pc Hot & Crispy Bucket', 'Crispy fried chicken bucket', 499.00, 'Fried Chicken', 'assets/images/menu/kfc-bucket.jpg', TRUE),
(2, 'Pepperoni Pizza', 'Classic pepperoni with extra cheese', 299.00, 'Pizza', 'assets/images/menu/pepperoni.jpg', TRUE),
(3, 'Whopper Burger', 'Flame-grilled beef patty with lettuce', 149.00, 'Burger', 'assets/images/menu/whopper.jpg', TRUE),
(4, 'Chicken Biryani', 'Traditional spicy aromatic rice dish', 249.00, 'Biryani', 'assets/images/menu/biryani.jpg', TRUE),
(5, 'Caffe Latte', 'Rich espresso with steamed milk', 189.00, 'Coffee', 'assets/images/menu/latte.jpg', TRUE);

-- Insert Sample Orders to display on dashboard
INSERT INTO orders (user_id, total_amount, status, payment_method, delivery_address) VALUES
(2, 675.00, 'Delivered', 'COD', '123 Main St, New York'),
(3, 549.00, 'Delivered', 'Card', '456 Oak St, Boston'),
(4, 799.00, 'Preparing', 'UPI', '789 Elm St, Chicago'),
(3, 450.00, 'Out for Delivery', 'COD', '456 Oak St, Boston'),
(2, 320.00, 'Delivered', 'Card', '123 Main St, New York');

-- Insert Sample Order Items
INSERT INTO order_items (order_id, menu_id, quantity, price) VALUES
(1, 1, 1, 499.00),
(1, 3, 1, 149.00),
(2, 2, 1, 299.00),
(2, 4, 1, 249.00),
(3, 1, 1, 499.00),
(3, 2, 1, 299.00),
(4, 4, 1, 249.00),
(4, 5, 1, 189.00),
(5, 5, 1, 189.00);
