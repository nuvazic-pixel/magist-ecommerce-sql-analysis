# Magist Marketplace Evaluation for Tech E-commerce Expansion  
## Logistics Performance & Strategic Fit Analysis using SQL and Tableau

---

##  Project Overview
Eniac is evaluating Magist as a potential partner for expanding its tech-focused e-commerce business into the Brazilian market.  
This project analyses Magist’s marketplace data to assess delivery performance, product mix, and seller revenue, leading to a **data-driven NO-GO recommendation** due to strategic misalignment with premium tech requirements.

---

##  Dataset & Sources
**Source:** Magist marketplace database (internal snapshot provided for analysis)  
**Time Period:** July 2017 – June 2018 (~25 months)

**Size:**
- ~99,000 orders  
- ~112,000 products sold  
- ~3,000 sellers  

**Key Tables:**
- `orders` – order status, timestamps, delivery dates  
- `order_items` – product prices, quantities  
- `products` – product categories, weight  
- `sellers`, `customers`, `geo` – seller & customer location data  

**Notes:**  
Product names are anonymised → category-level analysis only

---

##  Key Findings
- Tech products represent **~10% of total products sold**, indicating low marketplace focus on tech
- Only **~12% of total revenue** comes from tech categories
- Average delivery time:
  - Tech products: **~13 days**
  - Non-tech products: **~12 days**
- **7.4% of orders are delayed**, with heavier products more prone to delays
- Seller income is low on average, limiting scalability for premium tech brands

---

##  Technologies Used
- **SQL (MySQL)** – data exploration & business analysis  
- **Tableau** – visual analytics & storytelling  

---

##  Visualisations
> Average delivery time comparison, tech vs non-tech products  
> Share of tech products sold vs total marketplace volume  
> Monthly order trends (July 2017 – June 2018)

_Add screenshots to `/images` and embed them here._

---

##  How to Use This Project
1. Review SQL analysis in `/sql/magist_analysis.sql`
2. Explore insights via Tableau dashboards
3. Follow the query logic to reproduce results

---

##  Future Work
- Segment sellers by performance and delivery reliability  
- Analyse customer satisfaction impact on repeat purchases  
- Evaluate alternative logistics partners for tech categories  

---

##  Contact
**LinkedIn:** *(add your LinkedIn URL here)*  
**GitHub:** https://github.com/nuvazic-pixel
