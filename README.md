# Healthcare & Pharmacy Retail SQL Analytics

## Project Overview
This project presents an end-to-end SQL-based data analytics solution for a healthcare and pharmacy retail network (`healthcare_db_enhanced`). The analysis covers **21 comprehensive business questions** designed to optimize sales performance, store efficiency, inventory management, employee productivity, and customer loyalty segmentation.

---

## Tech Stack & Advanced SQL Techniques
- **Database Engine**: Microsoft SQL Server / T-SQL
- **Advanced SQL Concepts Used**:
  - **Window Functions**: `DENSE_RANK() OVER (PARTITION BY ...)` for ranking top products and employees per store.
  - **Common Table Expressions (CTEs)**: Multi-level CTEs for regional benchmarking and company-wide contribution metrics.
  - **Aggregations & Grouping**: `GROUP BY`, `HAVING`, and `CASE` conditional aggregations.
  - **Subqueries & Cross Joins**: Nested aggregation subqueries and `CROSS JOIN` for global percentage benchmarking.
## Repository Structure
```text
├── SQL_Scripts/
│   └── healthcare_analysis.sql   -- Full T-SQL script containing all 21 analytical queries
└── README.md                     -- Project documentation and overview

Key Business Insights Covered
1. Sales & Revenue Analytics
Prescription vs. Non-Prescription: Evaluated revenue share generated from prescription sales (is_prescription).

Category Contribution: Identified high-impact categories contributing >= 10% to total company revenue using CTEs.

Monthly Revenue Trends: Tracked seasonal growth patterns across years and months.

2. Store & Regional Operations
Regional Benchmarking: Benchmarked individual store revenues against their regional averages to classify stores as Above Average or Below Average.

Top Performers: Ranked top 5 products and top 3 employees per store using DENSE_RANK().

Revenue per Employee: Calculated store efficiency by measuring average revenue generated per employee.

3. Inventory & Supply Chain
Stock Reorder Alerts: Flagged products reaching critical stock thresholds (quantity <= reorder_level).

Supplier Distribution: Evaluated supplier portfolio sizes to manage supply chain dependencies.

4. Customer Intelligence & Loyalty
Customer Segmentation: Categorized customers into tiers (VIP, A Class, B Class, C Class) based on lifetime spend.

Cross-Store Loyalists: Identified high-value customers with >10 orders across multiple store locations spending above the global average.

Loyalty Program Performance: Analyzed average spending and points across loyalty levels.

How to Run the Scripts
Restore or connect to your SQL Server instance containing the healthcare_db_enhanced schema.

Open SQL_Scripts/healthcare_analysis.sql in SSMS (SQL Server Management Studio).

Execute the script sequentially to review individual business outputs.
