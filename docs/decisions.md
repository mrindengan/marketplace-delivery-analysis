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
