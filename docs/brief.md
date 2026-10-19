# Stakeholder brief: late deliveries (Olist)

**Status: provisional.** Written on 2026-10-19, before any analysis. It may change as the project progresses. Any change is recorded as a new entry in `docs/decisions.md` that names the entry it replaces.

*Authorship: the persona section is my own words. The rest is AI-drafted from D-01 to D-05 (see `docs/decisions.md` and `docs/ai_log.md`) and reviewed by me.*

## Who decides
The Head of Operations at a marketplace like Olist is judged on improving the late rate. Budget covers only a few fixes (levers), so she needs to know which one to address first.

## The decision
The Head of Operations decides which of three levers to fund next quarter: seller enforcement, regional carrier changes, and category handling-time rules. All three are funded in priority order. The lever the analysis shows is the biggest contributor to late orders is funded first. If it doesn't solve the problem, funding goes to the second lever, then the third, as far as the budget allows. How big the budget is lies outside this analysis. (D-01, D-05)

## What the analysis answers
Which lever is the pain point, and in what order the levers contribute to late orders. A late order is counted under every cause that applies. The analysis can say what contributes and where to prioritize. It cannot prove that a lever would work. (D-01, D-03)

## How success is judged
- **The metric is late rate.** Its denominator is defined in Step 2. Delivery time (purchase to delivery) is watched alongside it, because late rate alone can improve by changing the promised date. (D-02)
- **The analysis succeeds if it tells which lever is the pain point.** It promises no target number. The insights include an estimate labelled as a scenario, not a forecast. (D-03)

## Out of scope
1. No carrier identity (the data has no carrier column).
2. No cost data. Budget size is not this analysis's problem.
3. No forecast, prediction or causal claim. The Step 7 estimate is labelled as a scenario.
4. No sentiment analysis of reviews. It isn't needed to link lateness to scores, the text is in Portuguese, and it costs time.
5. The findings are about Brazil, 2016-2018. They serve as a reference for Indonesian marketplace settings (what to measure, which questions to ask). Indonesian numbers must be measured separately. (D-04)
