# Decisions

Date: 2026-10-17

Entries D-01 to D-05 were compiled by AI from my words in chat on 2026-10-19. I read them, confirmed the items marked as Claude's proposals, and saved them here.

## D-01 Levers: fund all three in priority order (option B)
Status: provisional, decided before any analysis.
Claim: Fund all three levers in priority order. The analysis shows which lever is the biggest contributor; funding goes there first, then the second, then the third, as far as the budget allows. Budget size is not the analysis's problem.
Options rejected: A (top 2 only), because lever 3 gets nothing if the top 2 turn out wrong.
Objections and my answers:
- Hedging: I never stop hedging while a lever still contributes; hence we need the data.
- No cost data: the analysis can say what contributes and where to prioritize, but cannot prove a lever would work or improve.
- Overlap: a late order is counted under every cause that applies.
I would change my mind if: the three levers contribute about equally, so the order carries no information.
Verdict: holds (Claude), 2026-10-19.

## D-02 Success metric: late rate
Status: provisional.
Claim: The success metric is late rate (denominator defined in Step 2).
Reason: late rate is something the company can improve. Reviews depend on things unrelated to delivery, such as mood and product quality.
Options rejected: review score.
Objection: late rate can be gamed by changing the promised date. My answer: also watch delivery time (purchase to delivery), which does not depend on the promised date.
I would change my mind if: late rate improves while delivery time does not.
Verdict: holds (Claude), 2026-10-19.

## D-03 No promised target
Status: provisional.
Claim: The analysis succeeds if it tells which lever is the pain point. It promises no number. The insights include a labelled scenario estimate, not a forecast.
Reason: there is no after-fix data to benchmark a target against.
I would change my mind if: I had after-fix data to benchmark against.
Verdict: holds (Claude), 2026-10-19.

## D-04 Out of scope
Status: provisional.
1. No carrier identity (no carrier column).
2. No cost data; budget size is not the analysis's problem.
3. No forecast, prediction or causal claim; the Step 7 scenario is labelled as a scenario.
4. No sentiment analysis of reviews: not needed to link lateness to scores, the text is Portuguese, and it costs time.
5. Findings are about Brazil, 2016-2018. The analysis is a reference for Indonesian marketplace settings (what to measure, which questions to ask); Indonesian numbers must be measured separately.
I would change my mind if: n/a (list of limits).
Verdict: holds (Claude), 2026-10-19.

## D-05 Persona and decision frame
Set by 02-p1 Step 1: Head of Operations at a marketplace, deciding which levers to fund next quarter.

Entries D-06 to D-09 were compiled by AI from my words in chat (20 to 26 Oct 2026). Claude's proposals are marked in each entry.

## D-06 Multi-seller orders in seller KPIs: option C
Status: provisional. Date: 2026-10-26. Compiled by AI from my words.
Claim: Orders with more than one seller are left out of seller-level KPIs. Region and category KPIs keep them; the 1.3% difference is noted.
Evidence (notebooks/eda_kpi_checks.ipynb, checks 5, 5b, 6): 1,278 multi-seller orders (1.30% of the 98,666 orders in order_items); 13 of 6,535 late orders; at threshold 30, 615 sellers ranked under C vs 627 with all orders; order coverage 83.2% vs 83.5%.
Reason: C never wrongly blames a seller for another seller's delay. Wrongly blaming sellers is bad service (like choosing precision over recall).
Options rejected: A (late for every seller in the order): can blame a seller for another seller's delay. B (split 1/n): hard to explain.
Objections and my answers:
- Revisit check: are 12 fewer ranked sellers "many"? No: about 2% of 627, and coverage moves only from 83.5% to 83.2%. C stands.
- Consistency across levers: C applies to seller KPIs only, so it does not affect other questions.
I would change my mind if: many sellers fell under the threshold because of C (checked in check 6: not the case).
Verdict: holds (Claude), 2026-10-26.

## D-07 What counts as "late"
Status: provisional. Date: 2026-10-26. Compiled by AI from my words.
Claim: An order is late if its delivered day is after its promised day (order_delivered_customer_date vs order_estimated_delivery_date, compared as calendar dates). Delivery on the promised day is on time. Applies only to orders with a delivered date (see D-08).
Evidence: check 3: every promised timestamp is 00:00:00, so the promise is a date. Check 4: 1,292 orders delivered on the promised day; 6,535 late by date vs 7,827 by exact timestamp.
Reason: "As a customer I don't care if it arrives at midnight as long as it's the same day as the promised date, and it's fair."
Options rejected: exact timestamps, because they call every same-day delivery late.
Objection: the rule cuts late orders by 1,292 (16.5%); did I make the numbers look better? My answer: the reason above, and I report the raw-rule count (7,827) next to 6,535, to be responsible with the decision.
I would change my mind if: the promise had an hour, not only a date (check 3: it does not).
Verdict: holds (Claude), 2026-10-26.

## D-08 Late-rate denominator: option D with guard G2
Status: provisional. Date: 2026-10-26. Compiled by AI from my words.
Claim: Late rate = late orders (D-07) / orders with status delivered AND a delivered date (96,470). Reported next to it, per month: G2 = overdue undelivered orders / all orders. Overdue undelivered = no delivered date, and promised date before the snapshot.
Snapshot: 2018-10-17 17:30:18, the latest of the four event columns (purchase, approved, carrier hand-over, customer delivery); the promised date is left out because it points to the future. Claude's method; I confirmed it: the data is historical, so comparing with "now" would leave a gap of years.
Evidence (checks 1, 2a-2c): 2,965 orders with no delivered date; 2,961 overdue at the snapshot (shipped 1,107; canceled 615; unavailable 609; never shipped 622; delivered status but no date 8), about 45% of the 6,535 late count.
Exclusions: 6 canceled orders with a delivered date are left out of the rate and noted (Claude's default; I said yes). The 8 delivered-without-date orders are in the overdue count.
Options rejected: A alone: hides the overdue orders. B (count them as late): the outcome is unknown (wrong address, unreachable recipient or refused delivery are possible; there is no reason field), so it would guess a cause. C (all orders): canceled, unavailable and never-shipped orders never went through delivery, so they cannot be late; including them mixes up the metric. G1 (count): biased by monthly volume. G3 (combined "broken promises" rate): mixes two problems and is hard to compare.
Objections and my answers:
- Gaming: "If in a month the late rate improves, it doesn't mean operations improved: if the late % goes down but the overdue undelivered % goes up, it doesn't solve the problem, hence G2 monitors this."
- Why not count the 1,107 shipped as late: their outcome is unknown (see above).
Step 5 to-do: the last 1-2 months before the snapshot may show a falsely low G2 (orders not yet due); mark them incomplete. Recount the late orders on the 96,470 (it may be up to 6 below 6,535).
I would change my mind if: more tables or data explained why orders were canceled, not delivered or stuck (for example a reason or status history).
Verdict: holds (Claude), 2026-10-26.

## D-09 Seller minimum-order threshold: 30
Status: provisional. Date: 2026-10-26. Compiled by AI from my words.
Claim: A seller gets a ranked late rate only with at least 30 delivered orders (counted after D-06).
Evidence (check 6, option C): at 30, 615 sellers, 83.2% of orders, 83.3% of late orders. One order moves a 30-order seller's rate by 3.3 points, against a 6.8% average.
Reason: 30 protects rate reliability while covering about 83% of orders, and keeps one order's effect small. My noise range (2 to 3.3 points, so 30 to 50 orders) and my coverage range (83.2% to 87.5%, so 20 to 30 orders) overlap only at 30. The other 16.7% of late orders get no seller rank but still count in the overall rate and in the region and category levers.
Options rejected (from my ranges): 20 (one order moves the rate by 5 points); 50 (75% coverage).
Objection: is 30 just the textbook number? Picked from the data; the match is a coincidence.
I would change my mind if: more than 3 of the top-10 sellers change at threshold 20 or 50 (test in Step 5).
Verdict: holds (Claude), 2026-10-26.

## D-10 Untranslated product categories: add the 2 missing translations by hand (option B)
Status: provisional. Date: 2026-10-29. Compiled by AI from my words. Claude's proposals are marked.
Claim: The 2 category names in `core.products` that have no row in `core.category_translation` get an English label added by hand in `core.category_translation`. `raw.category_translation` stays an exact copy of the CSV (71 rows); the 2 rows go into `core` through their own labeled `INSERT` in `sql/04_core_tables.sql`. (Raw untouched: Claude's proposal; I said yes.)
Reason (my words): B is the safest choice in this situation: only 2 rows are missing, it is only a category translation, and filling them by hand is more efficient, more accurate and takes a few minutes.
Labels:
- `portateis_cozinha_e_preparadores_de_alimentos` becomes `food_prep_and_small_kitchen_appliances` (my wording; the lowercase-with-underscores format is Claude's proposal, I said yes).
- `pc_gamer` stays `pc_gamer` (an English word used as-is).
Sources for the labels: Google Translate, then an AI cross-check. The exact outputs were not recorded. No dictionary: dictionaries translate word by word and do not give the context. I wrote the first label from the meaning because Google Translate is not accurate for contextual translations. Claude suggested `small_appliances_kitchen_and_food_preparers` as its own view; I kept my wording.
How I checked before deciding (all in psql or PowerShell on 2026-10-29, in this order; the SQL files are named where they exist):
1. Load count: `(Import-Csv ...).Count` gave 71; psql printed `COPY 71`. Equal, so the load is complete.
2. Key test on raw (query 7 in `sql/03_check_raw_before_cast.sql`): 71 rows, 71 distinct `product_category_name`, 0 missing. The key is safe, so the primary key was added in `core` (`INSERT 0 71`).
3. Count check (`sql/05_reconcile_counts.sql`): 7 tables, raw equals core on every row.
4. Gap query (typed in psql): `core.products` LEFT JOIN `core.category_translation`, keep products whose translation is NULL, exclude NULL categories (the 610 are products with no label, not gaps), GROUP BY name. Result: 2 names, `portateis_cozinha_e_preparadores_de_alimentos` (10 products) and `pc_gamer` (3 products), 13 of 32,951 products. This is why the foreign key could not be added as things stood, and why a decision was needed.
5. English-label check: 71 rows, 71 distinct `product_category_name_english`. No two names share a label, so grouping by English cannot merge categories.
6. Sizing query (`core.order_items` LEFT JOIN products LEFT JOIN `category_translation`, with FILTER counts): 112,650 item rows, which equals the `order_items` count, so no join multiplied rows (double-count check passed); 24 untranslated lines (0.02% of 112,650); 22 distinct orders. This showed the gap is tiny, which supports a hand fix.
7. Claude's read-only check of the CSV, which I used: "portateis" is translated as "small_appliances" in 2 existing rows (`eletroportateis`, `portateis_casa_forno_e_cafe`), and 7 rows keep an English word unchanged (`audio`, `pet_shop`, `cool_stuff`, `market_place`, `la_cuisine`, `dvds_blu_ray`, `consoles_games`). This is why `pc_gamer` stays as it is, and why I compared my long label against the table's style.
8. After the fix (the labeled `INSERT ... VALUES` for the 2 rows and the products foreign key, both in `sql/04_core_tables.sql`): the file re-ran with no error (`INSERT 0 71`, `INSERT 0 2`, 7 `ALTER TABLE`). `sql/05_reconcile_counts.sql` shows `category_translation` at 71 in raw and 73 in core (71 from the file + 2 added by me). The gap query now returns 0 rows. Status: implemented, still provisional.
Options rejected (my words): A (fall back to the Portuguese name): fine and traceable, but hard for an English-speaking shareholder. C (one "untranslated" bucket): merges categories and makes grouping and translation confusing. D (leave the 24 lines out): I should not remove data for no reason (same logic as M-06).
Objections and my answers:
- Accuracy of the two labels (blocking): answered by the sources above and by check 7. The labels are provisional until I am sure of the long one.
- Change-my-mind condition (blocking): my first answer was vague; the one below is checkable.
- Marking the hand-made rows (optional): documented in the README, in this file and in the reconciliation row, which reads "71 from the file + 2 added by me = 73" (the places are Claude's wording; I said yes).
Foreign key: `products.product_category_name` will reference `category_translation.product_category_name`, added after the 2 rows are in (Claude's default; I said yes). NULL categories (610) are ignored by a foreign key.
README: the AI-use statement must say that an AI tool cross-checked the two labels.
I would change my mind if: the sources disagree on a name and I can't settle it. (Claude's wording; I said yes.)
Verdict: holds (Claude), 2026-10-29.

## D-11 Scope: no P1-lite, sprint to finish P1 with all 9 tables
Status: provisional. Date: 2026-10-29. Compiled by AI from my words. Claude's proposals are marked.
Claim: I am not switching to P1-lite. I will sprint to finish P1 with all 9 tables, aiming for Sun 15 Nov or earlier (the plan's hard stop stands). I set no trigger date, because I want to deliver quality.
Evidence (my words): my day is job applications in the morning, project work from after lunch until dinner, and again after dinner until sleep. The only thing that slows me is usage limits; then I do DataCamp (I finished the Introduction to Power BI course on 28 Oct) or SQL drills (I have researched a platform but not started). Why the delay: I started late, but my pace is good.
Claude's estimate (not mine): about 49 plan-hours remain (Step 3 finish plus Steps 4 to 9 without the deck), against 13 to 16 project hours a week in the plan. I did not give my own hours figure.
Options rejected: P1-lite (drop the deck, 2 Power BI pages, sellers-only what-if, fewer tables), because I want to deliver quality.
Mock test and drills (my words): no Mock 1 on Fri 30 Oct for now; I will think about it when I start the actual SQL drills. Claude's note: both are on the never-cut list, so the 11 Nov checkpoint will miss "2+ mocks" and "baseline written".
Objections and my answers: (1) Hours: answered with my daily schedule, no number. (2) Never-cut list: answered by the same schedule; drills not started. (3) Trigger date: I declined to set one.
I would change my mind if: missing (I set no trigger).
Verdict: does not hold yet (Claude), 2026-10-29. Objection 1 has no hours figure and objection 3 has no trigger. The decision stands because it is mine.

## Minor decisions (one line each)
Claude proposed most defaults below and I answered yes or changed them. Compiled by AI from my words, 2026-10-26.
- **M-01** K4 (G2) is grouped by purchase month. (Claude's default; I said yes.)
- **M-02** SQL files: `sql/kpi_01_late_orders.sql` (K1-K3), `sql/kpi_02_overdue_g2.sql` (K4), `sql/kpi_03_seller_late_rate.sql` (K5). (Claude's default; I said yes.)
- **M-03** Delivery time (K6) = median calendar days from purchase day to delivered day, on the 96,470 delivered orders. It answers "how long does a typical order take"; the data is right-skewed (median 10, mean 12.5, 99th percentile 46, max 210). (Claude's default; I said yes after seeing the distribution.)
- **M-04** Average days late (K7) = mean calendar days late, on late orders only (mean 10.6, median 7, 6,534 orders). Reason: it gives the Head of Operations the total severity of lateness from the end-to-end delivery operation, next to the late rate. It measures severity, not cause.
- **M-05** Delivered orders with no review (646) are left out of the review KPIs only. Reason: less than 1% of delivered orders (0.67%).
- **M-06** Multi-review orders (option R-C2, strict): if all of an order's reviews give the same score, that score is kept; if they differ in any way, the order is left out of the review KPIs (202 orders; 345 multi-review orders agree). Reason: "it minimizes dropping data with no reason, while still being fair to multi-review orders." Worst case: under 0.01 stars on the average score, up to about 0.12 on the late group. Rejected: latest review (R-A), mean of reviews (R-B, breaks the 1-2 star count), dropping all multi-review orders (R-C, drops 345 orders for no reason), first review (R-D). Limit to state: the score shows how dissatisfaction relates to lateness, not why (KPI dictionary note and README Limitations).
- **M-07** Review gap (K10) = mean score of on-time orders minus mean score of late orders; positive means late orders score lower. (Claude's default; I said yes.)
- **M-08** Review KPIs use delivered orders with a usable review. (Follows from M-05; Claude's wording; I said yes.)
- **M-09** SQL files: `sql/kpi_04_delivery_time.sql` (K6-K7), `sql/kpi_05_reviews.sql` (K8-K10). (Claude's default; I said yes.)
- **M-10** Load method: A. Use `\copy` from psql, with one `load.sql` file holding one line per table. Reason (Claude's proposal; I said yes): the file shows exactly how the data was loaded, and it can be re-run. Rejected: the pgAdmin dialog (clicks, hard to repeat) and pandas (guesses types, against loading raw text first). Compiled by AI from my words, 2026-10-26.
- **M-11** Candidate primary keys, to test after the load: orders `order_id`; order_items `order_id` + `order_item_id` (Claude's default; I said yes); customers `customer_id`, because orders link to it (`customer_unique_id` is the real person, counted for information only); sellers `seller_id`. Status: tested 2026-10-27 on raw, all four keys passed: orders 99,441 rows / 99,441 distinct; order_items 112,650 rows / 112,650 distinct pairs; customers 99,441 / 99,441; sellers 3,095 / 3,095; 0 missing key values. customer_unique_id has 96,096 distinct values, 3,345 fewer than the customer_id rows. Primary keys are now created in `core`. Compiled by AI from my words, 2026-10-26.
- **M-12** Rerun protection. `sql/01_raw_ddl.sql` starts each table with `DROP TABLE IF EXISTS`, and `sql/02_load_raw.sql` (called `load.sql` in M-10) starts with `TRUNCATE` on the 4 tables, so a rerun never leaves a table with doubled rows. Reason (my words): `TRUNCATE` makes sure rows don't get loaded again on reruns. Claude proposed the DROP lines; I said yes. Compiled by AI from my words, 2026-10-27.
- **M-13** Schema for the typed tables: `core`. (Claude's default; I said yes.) Compiled by AI from my words, 2026-10-27.
- **M-14** Column types in `core` (Claude's proposal; I said yes after asking why ids and zip prefixes are not numbers). Text: all ids, status, city, state and zip prefix, because ids contain letters and a zip prefix is a label, not a quantity. Timestamp: the 5 order timestamps and `shipping_limit_date`; `NULL`s stay `NULL`. Integer: `order_item_id` (a counter). `numeric(10,2)`: `price` and `freight_value`, because money needs exact decimals. The promised date stays a timestamp; D-07's calendar-day comparison happens in the KPI SQL. Compiled by AI from my words, 2026-10-27.
- **M-15** Key of `core.reviews`: the pair `(review_id, order_id)`. Evidence (raw.reviews, Query 4 in `sql/03_check_raw_before_cast.sql`): 99,224 rows; 98,410 distinct `review_id`; 99,224 distinct pairs; 98,673 distinct `order_id`. Reason (my words): the pair count equals the row count, so the pair identifies each record. The 551 fewer distinct orders come from orders with more than one review (consistent with M-06). Rejected: `review_id` alone, because it repeats on 814 rows (Claude's correction; I said yes). Step 4: look at those 814 rows. Status: provisional. Compiled by AI from my words, 2026-10-27.
- **M-16** Column types in `core.reviews` (Claude's proposal; I said yes). Text: `review_id`, `order_id`, `review_comment_title`, `review_comment_message`. Integer: `review_score`. Timestamp: `review_creation_date` and `review_answer_timestamp`. Compiled by AI from my words, 2026-10-27.
- **M-17** Products table. Names: keep the CSV names, including `lenght` (Claude's proposal; I said yes). Types (Claude's proposal; I said yes): text for `product_id` and `product_category_name`; integer for the 7 number columns. Key: `product_id` (query 2 in `sql/03_check_raw_before_cast.sql`: 32,951 rows, 32,951 distinct, 0 missing). Missing values (query 6): 610 NULL in category, name length, description length and photos; 2 NULL in weight, length, height and width; 0 empty text. Raw and core counts are equal at 32,951 (`sql/05_reconcile_counts.sql`). Foreign key `order_items.product_id` to `products.product_id`: **added 2026-10-29**, after the orphan check. I said yes to Claude's proposal. Reason (Claude's wording, awaiting my confirmation): nothing in the check blocks it, and the database now enforces the link on every future load. Option rejected (Claude's wording): leaving it off, because it protects category joins for no cost.
**How I checked** (typed in psql, 2026-10-29):
1. Orphans: LEFT JOIN `core.order_items` to `core.products`, keep rows where the products key is NULL, excluding NULL `product_id` because a NULL never matches. Result: 0.
2. NULL `product_id` in `order_items`, counted separately because a foreign key ignores NULLs. Result: 0.
3. An orphan (an item pointing to an unknown product) is not a NULL category (a product that exists but has no label: the 610).
4. After adding it: the file re-ran with no errors; `\d core.order_items` shows 3 foreign keys (order_id, seller_id, product_id); `sql/05_reconcile_counts.sql` still gives equal raw and core counts for all 6 tables (order_items 112,650; products 32,951).
`product_id` stays nullable (0 NULLs today); NOT NULL is not decided. Status: provisional. Compiled by AI from my words, 2026-10-29.
- **M-18** Category translation table (table 7 of 9). Name `category_translation` in `raw` and `core`; column names as in the CSV; both columns `text`; key `product_category_name` (Claude's defaults; I confirmed yes). Why `text` for both: they are labels, not quantities (same logic as M-14). Checks: CSV 71 data rows (PowerShell `Import-Csv`); `COPY 71` into `raw.category_translation` (`sql/01_raw_ddl.sql`, `sql/02_load_raw.sql`); key test on raw, 71 rows, 71 distinct, 0 missing (query 7 in `sql/03_check_raw_before_cast.sql`); `INSERT 0 71` into `core` with the primary key (`sql/04_core_tables.sql`, Table 7); raw and core both 71 (`sql/05_reconcile_counts.sql`, 7 tables equal). The CSV starts with an invisible BOM mark, which is harmless because `HEADER true` skips that line. The 2 missing translations and the foreign key from products are decided in D-10. Status: provisional. Compiled by AI from my words, 2026-10-29.
- **M-19** Payments table (table 8 of 9). Name `payments`; columns as in the CSV. Types in `core` (Claude's defaults; I said yes): `order_id` and `payment_type` text; `payment_sequential` and `payment_installments` integer; `payment_value` `numeric(10,2)`. Key: the pair (`order_id`, `payment_sequential`). Foreign key `payments.order_id` to `orders.order_id`: added (Claude's default; I said yes). Evidence (2026-10-29): CSV 103,886 and `COPY 103886`; query 8 on raw: 103,886 rows, 99,440 distinct orders, 103,886 distinct pairs, 0 missing; query 9: 0 NULL and 0 empty in the 3 cast columns; orphan check against `core.orders`: 0; `INSERT 0 103886`; raw equals core. Several payments per order: 4,446 more rows than orders. One order has no payment row (99,441 orders less 99,440; to verify in Step 4). Status: provisional. Compiled by AI from my words, 2026-10-29.
- **M-20** Geolocation table (table 9 of 9). Name `geolocation`; columns as in the CSV; types in `core`: zip prefix, city and state text, `geolocation_lat` and `geolocation_lng` `numeric` (Claude's defaults; I proceeded without objecting). The prefix is quoted text with leading zeros, so it stays text. **No primary key and no foreign key**, because a zip prefix repeats across many rows. Collapsing to one row per prefix: not decided; postponed until an analysis uses it (Claude's proposal). Loaded in full because of D-11. Evidence: CSV 1,000,163 and `COPY 1000163`; query 10: 19,015 distinct prefixes, 0 missing; query 11: 0 NULL and 0 empty in lat and lng; `INSERT 0 1000163`; raw equals core. No KPI uses this table yet. Status: provisional. Compiled by AI from my words, 2026-10-29.
