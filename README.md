# Magist — Marketplace Fit & Delivery Performance
**SQL analytics case study · MySQL · Tableau · WBS Data Analytics coursework**

## Business question
Would Magist be a suitable marketplace partner for a technology retailer expanding into Brazil? The analysis examines product mix, seller activity and delivery performance rather than treating marketplace size alone as evidence of fit.

## Review the work
- [SQL exploration and business questions](<explore_the_dataset (1).sql>)
- Tableau screenshots below show the existing visual presentation; a downloadable workbook is not included.

## Method
1. Inspect orders, products, order items, sellers, customers and geographic tables.
2. Use joins, distinct counts, grouping and date differences to compare technology categories with the wider marketplace.
3. Examine order status, monthly activity, delivery timing and regional patterns.
4. Translate the metrics into a discussion of partner fit, while checking population and denominator definitions.

## Metrics and interpretation
| Metric | Definition / caveat |
| --- | --- |
| Technology product share | Distinct technology product IDs sold divided by all distinct product IDs sold, using the same order-status filter. This is **not** the share of units sold. |
| Technology revenue share | Sum of item prices in selected technology categories divided by the corresponding total. This is merchandise value, not profit or seller net income. |
| Delivery duration | Difference between purchase and actual delivery dates. Joining orders to multiple items can weight an average by line count. |
| Late-delivery rate | Late delivered orders / all delivered orders with both actual and estimated delivery dates. |
| Monthly activity | Order counts by year and month; this does not establish customer growth or retention. |

The original SQL comments record 6,665 late and 89,805 on-time orders. Those counts imply **6.91% late deliveries**, not 7.42%; the latter divided late orders by on-time orders. This is an arithmetic correction of recorded counts, not a fresh database result.

## Results and validation status
The original coursework presentation argues against selecting Magist for a premium-technology strategy. Treat that as the case-study recommendation, subject to the metric definitions above. The source database is not included and the analysis has not been rerun in this portfolio revision; numerical comments and screenshots are historical evidence, not independently refreshed results.

The exact coverage dates must be checked from the source database. The previous README mixed a one-year date range with a roughly 25-month duration; that inconsistent range has been removed.

## What this project practises
- Turning a business decision into queryable questions.
- Joining relational tables without confusing products, order lines and orders.
- Defining denominators and explaining why a KPI changes.
- Using SQL and Tableau to communicate operational findings.

## Reproduce
1. Obtain the authorised Magist coursework database and import it into MySQL.
2. Open the SQL file and select the `magist` schema.
3. Execute queries individually and inspect results; the file is an exploratory worksheet.
4. Confirm source date coverage, category definitions and order-status filters before reusing any recommendation.

## Existing Tableau visual evidence
<img width="2328" height="1306" alt="tech_product_share" src="https://github.com/user-attachments/assets/d1613b69-95e3-40ce-bd59-6b692dac29b5" />
<img width="2332" height="1314" alt="Screenshot 2026-02-09 192009" src="https://github.com/user-attachments/assets/26813ac0-6cb4-4cbc-bfcf-279671bb806c" />
<img width="2328" height="1309" alt="monthly_orders" src="https://github.com/user-attachments/assets/961afcde-3c46-47d5-8db7-af280dd72986" />

## Next improvements
- Publish an aggregate results table with the exact query, filters and extraction date.
- Calculate delivery KPIs at one row per order.
- Separate calendar duration from each seller's active selling months.

[Portfolio](https://github.com/nuvazic-pixel) · [LinkedIn](https://www.linkedin.com/in/bistreanchirodeamark)
