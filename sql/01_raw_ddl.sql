-- Raw layer: every column is text, no keys yet.
CREATE SCHEMA IF NOT EXISTS raw;

DROP TABLE IF EXISTS raw.orders;
CREATE TABLE raw.orders (
    order_id text,
    customer_id text,
    order_status text,
    order_purchase_timestamp text,
    order_approved_at text,
    order_delivered_carrier_date text,
    order_delivered_customer_date text,
    order_estimated_delivery_date text
);

DROP TABLE IF EXISTS raw.order_items;
CREATE TABLE raw.order_items (
    order_id text,
    order_item_id text,
    product_id text,
    seller_id text,
    shipping_limit_date text,
    price text,
    freight_value text
);

DROP TABLE IF EXISTS raw.customers;
CREATE TABLE raw.customers (
    customer_id text,
    customer_unique_id text,
    customer_zip_code_prefix text,
    customer_city text,
    customer_state text
);

DROP TABLE IF EXISTS raw.sellers;
CREATE TABLE raw.sellers (
    seller_id text,
    seller_zip_code_prefix text,
    seller_city text,
    seller_state text
);

DROP TABLE IF EXISTS raw.reviews;
CREATE TABLE raw.reviews (
    review_id text,
    order_id text,
    review_score text,
    review_comment_title text,
    review_comment_message text,
    review_creation_date text,
    review_answer_timestamp text
);