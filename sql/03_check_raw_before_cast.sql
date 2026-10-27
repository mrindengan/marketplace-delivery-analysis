-- 1. Missing values: NULL (no value) vs '' (empty text)
SELECT
    COUNT(*) AS all_rows,
    COUNT(*) FILTER (WHERE order_approved_at IS NULL) AS null_rows_approved,
    COUNT(*) FILTER (WHERE order_approved_at = '') AS empty_rows_approved,
    COUNT(*) FILTER (WHERE order_delivered_carrier_date IS NULL) AS null_rows_carrier_date,
    COUNT(*) FILTER (WHERE order_delivered_carrier_date = '') AS empty_rows_carrier_date,
    COUNT(*) FILTER (WHERE order_delivered_customer_date IS NULL) AS null_rows_customer_date,
    COUNT(*) FILTER (WHERE order_delivered_customer_date = '') AS empty_rows_customer_date
FROM raw.orders;

-- 2. Key test: is order_id, customer_id, seller_id unique?
SELECT 'orders' AS tbl,
    COUNT(*) AS all_rows,
    COUNT(DISTINCT order_id) AS distinct_keys,
    COUNT(*) FILTER(WHERE order_id IS NULL OR order_id = '') AS missing_keys
FROM raw.orders
UNION ALL
SELECT 'customers',
    COUNT(*),
    COUNT(DISTINCT customer_id),
    COUNT(*) FILTER(WHERE customer_id IS NULL OR customer_id = '') AS missing_keys
FROM raw.customers
UNION ALL
SELECT 'sellers',
    COUNT(*),
    COUNT(DISTINCT seller_id),
    COUNT(*) FILTER(WHERE seller_id IS NULL OR seller_id = '') AS missing_keys
FROM raw.sellers;

-- 3. Key made of two columns (order_items)
SELECT
    COUNT(*) AS all_rows,
    COUNT(DISTINCT(order_id, order_item_id)) AS distinct_pairs,
    COUNT(*) FILTER (WHERE order_id IS NULL OR order_id = '' OR order_item_id IS NULL OR order_item_id = '') AS missing_keys
FROM raw.order_items;

-- how many real people are in raw.customers?
SELECT COUNT(DISTINCT customer_unique_id) FROM raw.customers;

-- 4. Is the key of reviews unique?
SELECT
    COUNT(*)                                AS all_rows,
    COUNT(DISTINCT review_id)               AS distinct_review_ids,
    COUNT(DISTINCT (review_id, order_id))   AS distinct_pairs,
    COUNT(DISTINCT order_id)                AS distinct_orders
FROM raw.reviews;

-- 5. Missing values on reviews: NULL (no value) vs '' (empty text)
SELECT
    COUNT(*) AS all_rows,
    COUNT(*) FILTER (WHERE review_score IS NULL) AS null_rows_review_score,
    COUNT(*) FILTER (WHERE review_score = '') AS empty_rows_review_score,
    COUNT(*) FILTER (WHERE review_creation_date IS NULL) AS null_rows_review_create_date,
    COUNT(*) FILTER (WHERE review_creation_date = '') AS empty_rows_review_create_date,
    COUNT(*) FILTER (WHERE review_answer_timestamp IS NULL) AS null_rows_review_answer,
    COUNT(*) FILTER (WHERE review_answer_timestamp = '') AS empty_rows_review_answer
FROM raw.reviews;