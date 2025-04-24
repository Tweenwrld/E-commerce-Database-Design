-- E-Commerce Database Schema for MySQL
-- Created for the database design project

CREATE DATABASE ecommercedb;
   USE ecommercedb;

-- Create brand table
CREATE TABLE brand (
    brand_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_name VARCHAR(100) NOT NULL,
    description TEXT,
    logo_url VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Create product_category table with self-referencing foreign key
CREATE TABLE product_category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description TEXT,
    parent_category_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_category_id) REFERENCES product_category(category_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- Create product table
CREATE TABLE product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    brand_id INT NOT NULL,
    category_id INT NOT NULL,
    base_price DECIMAL(10, 2) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (brand_id) REFERENCES brand(brand_id) ON DELETE RESTRICT,
    FOREIGN KEY (category_id) REFERENCES product_category(category_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Create product_item table for purchasable items
CREATE TABLE product_item (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    SKU VARCHAR(50) NOT NULL UNIQUE,
    price DECIMAL(10, 2) NOT NULL,
    quantity_in_stock INT NOT NULL DEFAULT 0,
    is_available BOOLEAN DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Create product_image table
CREATE TABLE product_image (
    image_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    item_id INT,
    image_url VARCHAR(255) NOT NULL,
    is_primary BOOLEAN DEFAULT 0,
    display_order INT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES product_item(item_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Create color table
CREATE TABLE color (
    color_id INT AUTO_INCREMENT PRIMARY KEY,
    color_name VARCHAR(50) NOT NULL,
    color_code VARCHAR(20) NOT NULL, -- HEX or RGB code
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Create size_category table
CREATE TABLE size_category (
    size_category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Create size_option table
CREATE TABLE size_option (
    size_id INT AUTO_INCREMENT PRIMARY KEY,
    size_category_id INT NOT NULL,
    size_name VARCHAR(50) NOT NULL,
    size_code VARCHAR(20) NOT NULL,
    display_order INT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (size_category_id) REFERENCES size_category(size_category_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Create product_variation table to link products, items, colors, and sizes
CREATE TABLE product_variation (
    variation_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    item_id INT NOT NULL,
    color_id INT,
    size_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES product_item(item_id) ON DELETE CASCADE,
    FOREIGN KEY (color_id) REFERENCES color(color_id) ON DELETE SET NULL,
    FOREIGN KEY (size_id) REFERENCES size_option(size_id) ON DELETE SET NULL,
    UNIQUE(item_id, color_id, size_id)
) ENGINE=InnoDB;

-- Create attribute_category table
CREATE TABLE attribute_category (
    attribute_category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Create attribute_type table
CREATE TABLE attribute_type (
    attribute_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL, -- e.g., text, number, boolean
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Create product_attribute table
CREATE TABLE product_attribute (
    attribute_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    item_id INT,
    attribute_category_id INT NOT NULL,
    attribute_type_id INT NOT NULL,
    attribute_name VARCHAR(100) NOT NULL,
    attribute_value TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES product_item(item_id) ON DELETE CASCADE,
    FOREIGN KEY (attribute_category_id) REFERENCES attribute_category(attribute_category_id) ON DELETE RESTRICT,
    FOREIGN KEY (attribute_type_id) REFERENCES attribute_type(attribute_type_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Create indexes for performance optimization
CREATE INDEX idx_product_brand ON product(brand_id);
CREATE INDEX idx_product_category ON product(category_id);
CREATE INDEX idx_product_item_product ON product_item(product_id);
CREATE INDEX idx_product_image_product ON product_image(product_id);
CREATE INDEX idx_product_image_item ON product_image(item_id);
CREATE INDEX idx_product_variation_product ON product_variation(product_id);
CREATE INDEX idx_product_variation_item ON product_variation(item_id);
CREATE INDEX idx_product_attribute_product ON product_attribute(product_id);
CREATE INDEX idx_product_attribute_item ON product_attribute(item_id);
CREATE INDEX idx_size_option_category ON size_option(size_category_id);

-- Insert sample data for testing

-- Brands
INSERT INTO brand (brand_name, description, logo_url) VALUES
('Nike', 'Athletic apparel and footwear', 'https://example.com/logos/nike.png'),
('Samsung', 'Electronics manufacturer', 'https://example.com/logos/samsung.png'),
('IKEA', 'Furniture and home accessories', 'https://example.com/logos/ikea.png');

-- Categories
INSERT INTO product_category (category_name, description, parent_category_id) VALUES
('Electronics', 'Electronic devices and accessories', NULL),
('Clothing', 'Apparel and fashion items', NULL),
('Home & Garden', 'Home decor and garden supplies', NULL);

-- Insert subcategories (need to do this after parent categories are created)
INSERT INTO product_category (category_name, description, parent_category_id) VALUES
('Smartphones', 'Mobile phones and accessories', 1),
('Laptops', 'Portable computers', 1),
('Men\'s Clothing', 'Clothing items for men', 2),
('Women\'s Clothing', 'Clothing items for women', 2),
('Furniture', 'Home and office furniture', 3);

-- Size Categories
INSERT INTO size_category (category_name, description) VALUES
('Clothing Sizes', 'Standard clothing size measurements'),
('Shoe Sizes', 'Standard shoe size measurements'),
('Display Sizes', 'Screen size measurements for electronics');

-- Size Options
INSERT INTO size_option (size_category_id, size_name, size_code, display_order) VALUES
(1, 'Small', 'S', 1),
(1, 'Medium', 'M', 2),
(1, 'Large', 'L', 3),
(1, 'X-Large', 'XL', 4),
(2, 'US 8', '8', 1),
(2, 'US 9', '9', 2),
(2, 'US 10', '10', 3),
(3, '13 inch', '13"', 1),
(3, '15 inch', '15"', 2),
(3, '17 inch', '17"', 3);

-- Colors
INSERT INTO color (color_name, color_code) VALUES
('Black', '#000000'),
('White', '#FFFFFF'),
('Red', '#FF0000'),
('Blue', '#0000FF'),
('Green', '#00FF00');

-- Attribute Categories
INSERT INTO attribute_category (category_name, description) VALUES
('Physical', 'Physical attributes of products'),
('Technical', 'Technical specifications'),
('Material', 'Material composition details');

-- Attribute Types
INSERT INTO attribute_type (type_name, description) VALUES
('Text', 'Textual information'),
('Number', 'Numeric values'),
('Boolean', 'True/False values'),
('Date', 'Date values');

-- Products
INSERT INTO product (product_name, brand_id, category_id, base_price, description, is_active) VALUES
('Galaxy S23', 2, 4, 799.99, 'Latest Samsung smartphone with advanced features', 1),
('Air Max 270', 1, 2, 150.00, 'Comfortable athletic shoes with air cushioning', 1),
('MALM Desk', 3, 8, 199.99, 'Sleek modern desk with drawer storage', 1);

-- Product Items (specific variations)
INSERT INTO product_item (product_id, SKU, price, quantity_in_stock, is_available) VALUES
(1, 'GS23-BLK-128', 799.99, 50, 1),
(1, 'GS23-WHT-128', 799.99, 30, 1),
(1, 'GS23-BLK-256', 899.99, 25, 1),
(2, 'AM270-BLK-9', 150.00, 15, 1),
(2, 'AM270-WHT-9', 150.00, 10, 1),
(2, 'AM270-RED-10', 150.00, 5, 1),
(3, 'MALM-BLK', 199.99, 20, 1),
(3, 'MALM-WHT', 199.99, 15, 1);

-- Product Variations
INSERT INTO product_variation (product_id, item_id, color_id, size_id) VALUES
(1, 1, 1, NULL),  -- Galaxy S23, Black, 128GB
(1, 2, 2, NULL),  -- Galaxy S23, White, 128GB
(1, 3, 1, NULL),  -- Galaxy S23, Black, 256GB
(2, 4, 1, 6),     -- Air Max 270, Black, Size 9
(2, 5, 2, 6),     -- Air Max 270, White, Size 9
(2, 6, 3, 7),     -- Air Max 270, Red, Size 10
(3, 7, 1, NULL),  -- MALM Desk, Black
(3, 8, 2, NULL);  -- MALM Desk, White

-- Product Images
INSERT INTO product_image (product_id, item_id, image_url, is_primary, display_order) VALUES
(1, NULL, 'https://example.com/images/galaxy-s23-main.jpg', 1, 1),
(1, 1, 'https://example.com/images/galaxy-s23-black-1.jpg', 1, 1),
(1, 1, 'https://example.com/images/galaxy-s23-black-2.jpg', 0, 2),
(1, 2, 'https://example.com/images/galaxy-s23-white-1.jpg', 1, 1),
(2, NULL, 'https://example.com/images/airmax-270-main.jpg', 1, 1),
(2, 4, 'https://example.com/images/airmax-270-black-1.jpg', 1, 1),
(3, NULL, 'https://example.com/images/malm-desk-main.jpg', 1, 1),
(3, 7, 'https://example.com/images/malm-desk-black-1.jpg', 1, 1),
(3, 8, 'https://example.com/images/malm-desk-white-1.jpg', 1, 1);

-- Product Attributes
INSERT INTO product_attribute (product_id, item_id, attribute_category_id, attribute_type_id, attribute_name, attribute_value) VALUES
(1, NULL, 2, 2, 'Screen Size', '6.1 inches'),
(1, NULL, 2, 2, 'Battery Capacity', '3900 mAh'),
(1, 1, 2, 1, 'Storage', '128 GB'),
(1, 3, 2, 1, 'Storage', '256 GB'),
(2, NULL, 1, 1, 'Material', 'Synthetic leather, mesh'),
(2, NULL, 1, 2, 'Weight', '10.5 oz'),
(3, NULL, 3, 1, 'Material', 'Particleboard, ash veneer'),
(3, NULL, 1, 2, 'Width', '140 cm'),
(3, NULL, 1, 2, 'Depth', '65 cm'),
(3, NULL, 1, 2, 'Height', '73 cm');