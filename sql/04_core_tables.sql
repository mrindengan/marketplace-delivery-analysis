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

-- BLOCK 5: foreign keys (links between tables)
ALTER TABLE core.order_items
    ADD FOREIGN KEY (order_id)  REFERENCES core.orders (order_id);
ALTER TABLE core.order_items
    ADD FOREIGN KEY (seller_id) REFERENCES core.sellers (seller_id);
ALTER TABLE core.orders
    ADD FOREIGN KEY (customer_id) REFERENCES core.customers (customer_id);