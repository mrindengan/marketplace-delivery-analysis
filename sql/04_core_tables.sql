-- Table 1: orders
-- BLOCK 1: make a place to put the tables
CREATE SCHEMA IF NOT EXISTS core;
-- BLOCK 2: make an EMPTY table with the right column types
--          (like an empty form: each slot has a type)
DROP TABLE IF EXISTS core.orders CASCADE;
CREATE TABLE core.orders (
    order_id text,
    customer_id text,
    order_status text,
    order_purchase_timestamp timestamp,
    order_approved_at timestamp,
    order_delivered_carrier_date timestamp,
    order_delivered_customer_date timestamp,
    order_estimated_delivery_date timestamp
);
-- BLOCK 3: COPY the rows from raw into the empty table,
--          converting the text on the way
INSERT INTO core.orders
SELECT  order_id,
        customer_id,
        order_status,
        order_purchase_timestamp::timestamp,
        order_approved_at::timestamp,
        order_delivered_carrier_date::timestamp,
        order_delivered_customer_date::timestamp,
        order_estimated_delivery_date::timestamp
FROM raw.orders;
-- BLOCK 4: add the rule "order_id must be unique and never empty"
ALTER TABLE core.orders ADD PRIMARY KEY (order_id);

-- Table 2: order_items
DROP TABLE IF EXISTS core.order_items CASCADE;
CREATE TABLE core.order_items (
    order_id text,
    order_item_id integer,
    product_id text,
    seller_id text,
    shipping_limit_date timestamp,
    price numeric(10,2),
    freight_value numeric(10,2)
);
INSERT INTO core.order_items
SELECT  order_id,
        order_item_id::integer,
        product_id,
        seller_id,
        shipping_limit_date::timestamp,
        price::numeric(10,2),
        freight_value::numeric(10,2)
FROM raw.order_items;
ALTER TABLE core.order_items ADD PRIMARY KEY (order_id, order_item_id);

-- Table 3: customers
DROP TABLE IF EXISTS core.customers CASCADE;
CREATE TABLE core.customers (
    customer_id text,
    customer_unique_id text,
    customer_zip_code_prefix text,
    customer_city text,
    customer_state text
);
INSERT INTO core.customers
SELECT  customer_id,
        customer_unique_id,
        customer_zip_code_prefix,
        customer_city,
        customer_state
FROM raw.customers;
ALTER TABLE core.customers ADD PRIMARY KEY (customer_id);

-- Table 4: sellers
DROP TABLE IF EXISTS core.sellers CASCADE;
CREATE TABLE core.sellers (
    seller_id text,
    seller_zip_code_prefix text,
    seller_city text,
    seller_state text
);
INSERT INTO core.sellers
SELECT  seller_id,
        seller_zip_code_prefix,
        seller_city,
        seller_state
FROM raw.sellers;
ALTER TABLE core.sellers ADD PRIMARY KEY (seller_id);

-- Table 5: reviews
DROP TABLE IF EXISTS core.reviews CASCADE;
CREATE TABLE core.reviews (
    review_id               text,
    order_id                text,
    review_score            integer,
    review_comment_title    text,
    review_comment_message  text,
    review_creation_date    timestamp,
    review_answer_timestamp timestamp
);
INSERT INTO core.reviews
SELECT review_id, order_id, review_score::integer, review_comment_title, review_comment_message, review_creation_date::timestamp, review_answer_timestamp::timestamp
FROM raw.reviews;
ALTER TABLE core.reviews ADD PRIMARY KEY (review_id, order_id);

-- Table 6: products
DROP TABLE IF EXISTS core.products CASCADE;
CREATE TABLE core.products (
    product_id                  text,
    product_category_name       text,
    product_name_lenght         integer,
    product_description_lenght  integer,
    product_photos_qty          integer,
    product_weight_g            integer,
    product_length_cm           integer,
    product_height_cm           integer,
    product_width_cm            integer
);
INSERT INTO core.products
SELECT product_id, product_category_name, product_name_lenght::integer, product_description_lenght::integer, product_photos_qty::integer, product_weight_g::integer, product_length_cm::integer, product_height_cm::integer, product_width_cm::integer
FROM raw.products;
ALTER TABLE core.products ADD PRIMARY KEY (product_id);

-- Table 7: category_translation
DROP TABLE IF EXISTS core.category_translation CASCADE;
CREATE TABLE core.category_translation (
    product_category_name           text,
    product_category_name_english   text
);
INSERT INTO core.category_translation
SELECT product_category_name, product_category_name_english
FROM raw.category_translation;
INSERT INTO core.category_translation (product_category_name, product_category_name_english) -- HAND-ADDED 2026-10-29 (D-10): missing from the source CSV
VALUES  ('portateis_cozinha_e_preparadores_de_alimentos', 'food_prep_and_small_kitchen_appliances'),
        ('pc_gamer', 'pc_gamer');
ALTER TABLE core.category_translation ADD PRIMARY KEY (product_category_name);


-- BLOCK 5: foreign keys (links between tables)
ALTER TABLE core.order_items
    ADD FOREIGN KEY (order_id)  REFERENCES core.orders (order_id);
ALTER TABLE core.order_items
    ADD FOREIGN KEY (seller_id) REFERENCES core.sellers (seller_id);
ALTER TABLE core.orders
    ADD FOREIGN KEY (customer_id) REFERENCES core.customers (customer_id);
ALTER TABLE core.reviews
    ADD FOREIGN KEY (order_id) REFERENCES core.orders (order_id);
ALTER TABLE core.order_items
    ADD FOREIGN KEY (product_id) REFERENCES core.products (product_id);
ALTER TABLE core.products
    ADD FOREIGN KEY (product_category_name) REFERENCES core.category_translation (product_category_name);