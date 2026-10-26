# KPI dictionary: late deliveries (Olist)

**Status: provisional.** *AI-drafted from D-06 to D-09 and minor decisions M-01 to M-09 (`docs/decisions.md`), 26 Oct 2026. It restates those records and adds nothing new; I still have to read and correct it.* Values are provisional figures from `notebooks/eda_kpi_checks.ipynb` and will be recomputed in SQL (Step 5).

## Base populations

| Name | Definition | Size (notebook) | Source |
|---|---|---|---|
| Delivered orders | Orders with status `delivered` AND a delivered date (`order_delivered_customer_date`) | 96,470 | D-08 |
| Overdue undelivered orders | Orders with no delivered date whose promised date is before the snapshot (2018-10-17 17:30:18) | 2,961 | D-08 |
| Reviewed delivered orders | Delivered orders with a usable review: at least one review, and not a conflicting multi-review order | up to 95,824 (minus the delivered ones among 202 conflicting orders) | M-05, M-06, M-08 |

Left out of every rate: the 6 canceled orders that have a delivered date (D-08).

## Summary

| ID | KPI | Grain | SQL file |
|---|---|---|---|
| K1 | Late order (flag) | order | `sql/kpi_01_late_orders.sql` |
| K2 | Late rate | order | `sql/kpi_01_late_orders.sql` |
| K3 | On-time rate | order | `sql/kpi_01_late_orders.sql` |
| K4 | G2: overdue undelivered share | order, by purchase month | `sql/kpi_02_overdue_g2.sql` |
| K5 | Seller late rate | seller | `sql/kpi_03_seller_late_rate.sql` |
| K6 | Delivery time | order | `sql/kpi_04_delivery_time.sql` |
| K7 | Average days late | order | `sql/kpi_04_delivery_time.sql` |
| K8 | Average review score | order | `sql/kpi_05_reviews.sql` |
| K9 | % of 1-2 star reviews | order | `sql/kpi_05_reviews.sql` |
| K10 | Late vs on-time review gap | order | `sql/kpi_05_reviews.sql` |

## K1 Late order (flag)
- **Rule:** late if the delivered day is after the promised day (`order_delivered_customer_date` vs `order_estimated_delivery_date`, compared as calendar dates). Delivery on the promised day is on time.
- **Grain:** one order. **Applies to:** delivered orders (96,470).
- **Exclusions:** orders with no delivered date (they are counted in K4); the 6 canceled orders with a delivered date.
- **Also reported:** the count under the exact-timestamp rule, next to the date-rule count.
- **Values (notebook):** 6,534 late on the 96,470. Exact-timestamp rule: 7,827, and date rule 6,535, both on the earlier 96,476 basis.
- **Source:** D-07, D-08.

## K2 Late rate
- **Numerator:** K1 late orders. **Denominator:** delivered orders (96,470). **Exclusions:** as K1.
- **Read together with K4** for the same month. The two use different denominators; say so wherever both appear.
- **Value (notebook):** about 6.77%.
- **Source:** D-07, D-08 (success metric: D-02).

## K3 On-time rate
- **Numerator:** delivered orders delivered on or before the promised day. **Denominator:** delivered orders (96,470). Equals 100% minus K2.
- **Source:** D-07, D-08.

## K4 G2: overdue undelivered share
- **Numerator:** overdue undelivered orders. **Denominator:** all orders. **Grouped by:** purchase month (M-01).
- **Snapshot:** 2018-10-17 17:30:18, the latest of the four event columns (purchase, approved, carrier hand-over, customer delivery). The promised date is left out because it points to the future.
- **Includes** every status, including the 8 orders with status `delivered` but no delivered date.
- **Warning rule:** if K2 falls while K4 rises in the same month, the improvement is not counted.
- **Trap:** the last 1 to 2 months before the snapshot may show a falsely low K4 (orders not yet due). Mark them incomplete.
- **Value overall (notebook):** 2,961 of 99,441, about 2.98%.
- **Source:** D-08, M-01.

## K5 Seller late rate
- **Grain:** one seller. **Numerator:** the seller's K1 late orders. **Denominator:** the seller's delivered orders, counting **single-seller orders only** (D-06).
- **Ranked only with at least 30 such orders** (D-09). Smaller sellers still count in K2 and in the region and category results.
- **Values (notebook, check 6):** 615 sellers ranked at 30.
- **Step 5 test:** reconsider 30 if more than 3 of the top-10 sellers change at thresholds 20 or 50.
- **Source:** D-06, D-07, D-08, D-09.

## K6 Delivery time
- **Measure:** median calendar days from purchase day to delivered day. **Grain:** one order. **Population:** delivered orders (96,470).
- **Why the median:** it answers "how long does a typical order take?"; the distribution is right-skewed (median 10, mean 12.5, 99th percentile 46, max 210).
- **Watched next to K2,** because K2 alone can improve by lengthening the promise (D-02).
- **Value (notebook):** 10 days.
- **Source:** D-02, M-03, M-09.

## K7 Average days late
- **Measure:** mean calendar days late (delivered day minus promised day). **Grain:** one order. **Population:** K1 late orders only.
- **Why the mean:** it shows the total severity of lateness the operation produces, next to K2's frequency. It measures severity, not cause.
- **Values (notebook):** mean 10.6 days, median 7, on 6,534 late orders.
- **Source:** M-04.

## K8 Average review score
- **Measure:** mean of the order-level review score (1 to 5). **Grain:** one order. **Population:** reviewed delivered orders.
- **Order-level score:** the order's score if all its reviews give the same score; orders whose reviews differ in any way are left out (202 orders).
- **Exclusions:** delivered orders with no review (646, about 0.67%); conflicting multi-review orders.
- **Value:** to compute in Step 5.
- **Source:** M-05, M-06, M-08.

## K9 % of 1-2 star reviews
- **Numerator:** reviewed delivered orders with an order-level score of 1 or 2. **Denominator:** reviewed delivered orders. **Exclusions:** as K8.
- **Value:** to compute in Step 5.
- **Source:** M-05, M-06, M-08.

## K10 Late vs on-time review gap
- **Measure:** mean K8 score of on-time orders minus mean K8 score of late orders. A positive number means late orders score lower (M-07).
- **Population:** reviewed delivered orders, split by K1.
- **Association, not cause:** the gap shows how scores relate to lateness. It does not show that lateness caused them (brief, D-04).
- **Value:** to compute in Step 5.
- **Source:** D-07, M-05 to M-08.

### What the review score cannot tell (applies to K8 to K10)
The score shows how dissatisfaction relates to lateness, not why a customer was unhappy. Review text was not analysed (D-04), and other factors such as the product or category also affect scores. This limit also goes in the README Limitations section (Step 9). Effect bounds of the conflicting-review rule: under 0.01 stars on K8; up to about 0.12 stars on the late group in K10, only if all 202 orders were late.

## Not defined yet
- **Breakdowns by region and by category** (Step 5): customer state or seller state? How to treat orders with items from several categories?
- **Flags for Step 4 (data-quality checks):** orders with 0 delivery days (purchased and delivered the same day); reviews written before the order arrived (review creation date vs delivered date), which could not reflect lateness.
