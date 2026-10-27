SELECT 'orders' AS tbl,
       (SELECT COUNT(*) FROM raw.orders)  AS raw_rows,
       (SELECT COUNT(*) FROM core.orders) AS core_rows
UNION ALL
SELECT 'order_items',
       (SELECT COUNT(*) FROM raw.order_items),
       (SELECT COUNT(*) FROM core.order_items)
UNION ALL
SELECT 'customers',
       (SELECT COUNT(*) FROM raw.customers),
       (SELECT COUNT(*) FROM core.customers)
UNION ALL
SELECT 'sellers',
       (SELECT COUNT(*) FROM raw.sellers),
       (SELECT COUNT(*) FROM core.sellers)
UNION ALL
SELECT 'reviews',
       (SELECT COUNT(*) FROM raw.reviews),
       (SELECT COUNT(*) FROM core.reviews);