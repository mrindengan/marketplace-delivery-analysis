# Data quality log

AI-drafted from D-12 to D-14 and M-23 to M-27 (derived text, adds no new claim). Source: psql queries on the `core` tables, typed 2026-10-30 and 2026-10-31. Each entry has the issue, the count, the decision and the KPI impact. The decisions are in `docs/decisions.md`.

| Issue | Count | Decision | KPI impact |
|---|---|---|---|
| Delivered to the customer before the carrier hand-over (gap 00:23:18 to 16 days 02:18:29) | 23 of 99,441 orders, all `delivered` | Keep all orders; one flag for this date pair; a KPI that uses these two columns excludes only the flagged orders; a missing date is not a conflict (D-12) | No KPI K1 to K10 uses the carrier date. The Step 5 open item on `shipping_limit_date` would. |
| Carrier hand-over before approval (gap 00:00:21 to 171 days 05:15:22) | 1,359 orders (1,350 `delivered`, 9 `shipped`) | Same rule, with its own flag for this date pair (D-12) | No KPI K1 to K10 uses the approval date. The K4 snapshot takes the latest of the four event columns; not yet checked against these orders. |
| Approval before purchase | 0 | Nothing to decide | None |
| Delivered to the customer before purchase | 0 | Nothing to decide | None |
| Delivered on the purchase day (gap 12:48:07) | 1 of 96,470 delivered orders | Keep and log (M-23) | None visible; K6 median is 10 days |
| `review_creation_date` with a time of day | 85 values | Compare calendar days with `::date`, as in D-07 (D-13) | None visible |
| Review written before the delivery day | 5,126 review rows (5,100 orders), 5.3% of 96,353; 4,777 of them on late orders | Keep all reviews; show both groups of late-order reviews; K10 two ways (D-13) | K8 to K10: the gap is about 2.0 stars with all late orders and about 0.8 without the early reviews (rough, raw review rows) |
| Late order with an early and a later review | 4 orders (2 with different scores, 2 with the same score) | The 2 with different scores are left out by M-06; the 2 with the same score count as "reviewed while waiting" (M-24) | None visible |
| Delivered order with no payment row | 1 of 99,441 orders | Keep and log (M-25) | None; no KPI K1 to K10 uses payments. A later payment-based number would miss this order. |
| Zero freight on an item (also checked: negative or zero price, negative freight, missing values: 0 each) | 383 of 112,650 item rows (0.34%) | Keep and log (M-26); free shipping is plausible, not verified | None; no KPI K1 to K10 uses price or freight. A later price-based number would need a rule. |
| `shipping_limit_date` missing, or before the purchase | 0 of 112,650 items | Nothing to decide | None |
| Items in one order with different `shipping_limit_date` | 336 of 9,803 multi-item orders (3.4%) | Deferred: decided at the start of Step 5 with the seller-versus-carrier split (`docs/kpi_dictionary.md`) | None in K1 to K10; matters for the Step 5 split |
| `review_id` shared by several orders | 789 IDs on 1,603 rows (814 extra rows); same score on every row; all belong to one person | Keep all rows (M-27); each order keeps its own review row (M-15, M-06) | Negligible for K8 to K10 |
| Products with no category (they also have no name length, description length or photos) | 610 of 32,951 products, all sold; 1,603 of 112,650 order items (1.4%) in 1,451 orders | Show them as one extra group, "Uncategorised", with its size next to it (D-14) | None in K1 to K10; affects the Step 5 category breakdown |

The two problem groups do not overlap: 1,382 orders in total, 1.4% of 99,441 (D-12).
