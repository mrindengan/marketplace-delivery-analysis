## Data load and reconciliation

<!-- AI-drafted from M-10 to M-18, D-10 and my own psql outputs (2026-10-29) -->

### How the database is built
The 9 source CSVs (placed in `data/raw/`) are loaded into PostgreSQL in two layers:
- **`raw`**: an exact copy of each CSV. Every column is text, so nothing can fail on load. Loaded with `\copy` from psql, one line per table (`sql/02_load_raw.sql`).
- **`core`**: the same data with proper types, primary keys and foreign keys (`sql/04_core_tables.sql`). Ids and zip prefixes stay text, timestamps are timestamps, counters are integers, money is `numeric(10,2)` and coordinates are `numeric`.

Run order, from psql in the project folder: `sql/01_raw_ddl.sql`, `sql/02_load_raw.sql`, `sql/04_core_tables.sql`, `sql/05_reconcile_counts.sql`. `sql/03_check_raw_before_cast.sql` holds the checks I ran on `raw` before casting. Every file can be re-run safely (`DROP TABLE IF EXISTS`, `TRUNCATE`, `CASCADE`).

### Terms used in this section
- **Raw and core:** two layers of the same data. `raw` is an exact text copy of the CSV. `core` is the cleaned version with proper types and rules.
- **Cast:** converting a value from one type to another, for example the text `'2018-10-17'` into a real timestamp. I cast only the columns that change type; ids and zip prefixes stay text.
- **NULL versus empty text:** NULL means "no value". Empty text (`''`) is a value that happens to be blank. A blank cell in a CSV loads as NULL here. The difference matters because an empty `''` makes a cast to a number fail, while a NULL passes through.
- **Primary key:** the column, or pair of columns, that identifies each row exactly once, for example `order_id` in `orders`. It can't repeat and can't be missing.
- **Key test:** counting rows against distinct key values (and missing ones) on `raw` before a primary key is added. If the numbers are equal and nothing is missing, the key is valid.
- **Foreign key:** a rule that every value in a child column must exist in a parent table's key. Example: every `order_id` in `payments` must exist in `orders`. The database rejects a row that breaks the rule. NULLs are ignored by the rule.
- **Orphan:** a child row that points to a parent that doesn't exist, such as an order item whose `product_id` is not in `products`. I counted orphans before adding each foreign key, because an orphan would make the foreign key fail.
- **Gap (translation):** a category name that appears in `products` but has no row in the translation table. Not the same as an orphan check on a key, but found the same way.
- **Double counting:** counting the same thing twice because a join multiplied the rows. Example: joining `payments` to `orders` gives several rows for an order that has several payments.
- **Reconciliation:** comparing counts at each stage (CSV, `raw`, `core`) to prove that no rows were lost or added by accident.
- **Re-runnable:** a file that can run again without errors or duplicated rows. `DROP TABLE IF EXISTS` removes a table if it exists, `TRUNCATE` empties a table but keeps it, and `CASCADE` also removes what depends on it, such as foreign keys.

### Reconciliation
Counts at three points: the source CSV (PowerShell `Import-Csv`), `raw` (psql `\copy`) and `core` (`sql/05_reconcile_counts.sql`).

| Table | Key | CSV rows | Raw rows | Core rows | Note |
|---|---|---|---|---|---|
| orders | `order_id` | 99,441 | 99,441 | 99,441 | 2,965 delivered dates are NULL and stay NULL |
| order_items | `order_id` + `order_item_id` | 112,650 | 112,650 | 112,650 | one row per item |
| customers | `customer_id` | 99,441 | 99,441 | 99,441 | 96,096 distinct `customer_unique_id` (real people) |
| sellers | `seller_id` | 3,095 | 3,095 | 3,095 | |
| reviews | `review_id` + `order_id` | 99,224 | 99,224 | 99,224 | 814 rows share a `review_id` |
| products | `product_id` | 32,951 | 32,951 | 32,951 | 610 products have no category |
| category_translation | `product_category_name` | 71 | 71 | 73 | core = 71 from the file + 2 added by me (D-10) |
| payments | `order_id` + `payment_sequential` | 103,886 | 103,886 | 103,886 | 99,440 distinct orders, so several payments per order |
| geolocation | none | 1,000,163 | 1,000,163 | 1,000,163 | 19,015 distinct zip prefixes, so the prefix repeats |

Rejected rows: 0. Every CSV row loaded into `raw`, and every `raw` row into `core`. The only difference is the 2 translation rows added by hand.

### Foreign keys (7)
`order_items.order_id` to `orders`; `order_items.seller_id` to `sellers`; `order_items.product_id` to `products`; `orders.customer_id` to `customers`; `reviews.order_id` to `orders`; `payments.order_id` to `orders`; `products.product_category_name` to `category_translation`. A foreign key ignores NULLs, so the 610 products with no category do not break the last one. Geolocation has no key and no foreign key, because a repeated prefix can neither identify a row nor be a parent.

### Checks run before deciding
- **Keys:** each candidate key was tested on `raw` before the primary key was added (rows versus distinct values, plus missing values). All passed except geolocation, which has no key.
- **NULL versus empty text,** before every cast. Products: 610 NULL in category, name length, description length and photos, and 2 NULL in weight and the three dimensions, with 0 empty text. Payments, and geolocation lat and lng: 0 NULL, 0 empty.
- **Orphans,** before each foreign key. `order_items.product_id`: 0 orphans and 0 NULL. `payments.order_id`: 0 orphans.
- **Translation gaps:** 2 category names in products had no translation (13 products, 24 order lines, 22 orders, about 0.02% of lines). The 71 English labels are all distinct.
- **Double counting:** joining `order_items` to `products` and `category_translation` still returns 112,650 rows.

### The 2 translations added by hand (D-10)
`portateis_cozinha_e_preparadores_de_alimentos` became `food_prep_and_small_kitchen_appliances`, and `pc_gamer` stays `pc_gamer`. They are not from the source data. I wrote the first label from its meaning, using Google Translate and an AI cross-check, with no dictionary. They sit in `core` only, through their own labeled `INSERT`; `raw` stays an exact copy of the CSV.

### Known limits and open items
- 814 review rows share a `review_id`; to inspect in Step 4.
- 99,441 orders but 99,440 with payments, so one order has no payment row (to verify in Step 4).
- `order_items.product_id` can be NULL by definition; today it has 0 NULLs, and NOT NULL is not decided.
- Geolocation is kept as loaded, with about 53 rows per prefix. Collapsing it to one row per prefix is not decided, and no KPI uses it yet.
