# Healthcare-Pharmacy-SQL-Analytics
Healthcare-Pharmacy-SQL-Analytics
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
