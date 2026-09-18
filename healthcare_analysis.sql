--------------------------------------------------------------------------------
-- DATABASE INITIALIZATION & EXPLORATION
--------------------------------------------------------------------------------
USE healthcare_db_enhanced;
GO

SELECT table_name 
FROM INFORMATION_SCHEMA.TABLES;

SELECT * 
FROM Products;


--------------------------------------------------------------------------------
-- 1. PRODUCT PORTFOLIO SIZE BY CATEGORY
-- Business Goal: Understand the size and distribution of the product portfolio.
--------------------------------------------------------------------------------
SELECT
    c.category_name AS category_name,
    COUNT(p.product_name) AS total_products
FROM Categories AS c
INNER JOIN Products AS p
    ON c.category_id = p.category_id
GROUP BY c.category_name;


--------------------------------------------------------------------------------
-- 2. SUPPLIER PORTFOLIO DISTRIBUTION
-- Business Goal: Identify the suppliers with the largest product portfolios. 
--------------------------------------------------------------------------------
SELECT
    s.supplier_name AS supplier_name,
    COUNT(p.product_id) AS total_products
FROM Products AS p
INNER JOIN Suppliers AS s
    ON p.supplier_id = s.supplier_id
GROUP BY s.supplier_name
ORDER BY total_products DESC;


--------------------------------------------------------------------------------
-- 3. WORKFORCE DISTRIBUTION ACROSS STORES
-- Business Goal: Understand workforce distribution across different store locations.
--------------------------------------------------------------------------------
SELECT
    s.store_name AS store_name,
    COUNT(e.employee_id) AS total_employees
FROM Employees AS e
INNER JOIN Stores AS s
    ON e.store_id = s.store_id
GROUP BY s.store_name
ORDER BY total_employees;


--------------------------------------------------------------------------------
-- 4. PAYMENT PREFERENCES & REVENUE CONTRIBUTION
-- Business Goal: Understand customer payment preferences and their revenue share.
--------------------------------------------------------------------------------
SELECT
    payment_method,
    SUM(total_amount) AS total_sales
FROM Sales
GROUP BY payment_method
order by total_sales DESC;


--------------------------------------------------------------------------------
-- 5. REGIONAL PERFORMANCE COMPARISON
-- Business Goal: Compare total sales performance across different regions.
--------------------------------------------------------------------------------
SELECT
    st.region AS region,
    SUM(s.total_amount) AS total_sales
FROM Sales AS s
INNER JOIN Stores AS st
    ON s.store_id = st.store_id
GROUP BY st.region
ORDER BY total_sales DESC;


--------------------------------------------------------------------------------
-- 6. LOYALTY PROGRAM COMPOSITION
-- Business Goal: Understand the composition and tier breakdown of the loyalty program.
--------------------------------------------------------------------------------
SELECT
    loyalty_level,
    COUNT(customer_id) AS total_customers
FROM Customer_Loyalty
GROUP BY loyalty_level
ORDER BY total_customers DESC;


--------------------------------------------------------------------------------
-- 7. PRESCRIPTION SALES IMPORTANCE
-- Business Goal: Evaluate the significance and revenue share of prescription sales.
--------------------------------------------------------------------------------
SELECT 
    (SUM(CASE WHEN is_prescription = 1 THEN total_amount ELSE 0 END) 
     / SUM(total_amount)) * 100 AS prescription_percentage
FROM Sales;


--------------------------------------------------------------------------------
-- 8. PREMIUM & HIGH-VALUE PRODUCTS
-- Business Goal: Identify the top 20 premium products based on unit price.
--------------------------------------------------------------------------------
SELECT TOP 20
    product_name,
    unit_price
FROM Products
ORDER BY unit_price DESC;


--------------------------------------------------------------------------------
-- 9. CATEGORY REVENUE & QUANTITY PERFORMANCE
-- Business Goal: Calculate total revenue and quantity sold per category, 
-- ranked from highest to lowest revenue.
--------------------------------------------------------------------------------
SELECT
    c.category_name,
    SUM(s.total_amount) AS total_revenue,
    SUM(s.quantity) AS total_quantity
FROM Categories AS c
INNER JOIN Products AS p
    ON p.category_id = c.category_id
INNER JOIN Sales AS s
    ON p.product_id = s.product_id
GROUP BY c.category_name
ORDER BY total_revenue DESC;


--------------------------------------------------------------------------------
-- 10. STORE REVENUE & REVENUE PER EMPLOYEE
-- Business Goal: Calculate total store revenue and average revenue generated per employee.
--------------------------------------------------------------------------------
SELECT 
    st.store_name,
    SUM(s.total_amount) AS store_total_revenue,
    COUNT(DISTINCT e.employee_id) AS employee_count,
    SUM(s.total_amount) / COUNT(DISTINCT e.employee_id) AS avg_revenue_per_employee
FROM Stores st
INNER JOIN Sales s 
    ON st.store_id = s.store_id
INNER JOIN Employees e 
    ON st.store_id = e.store_id
GROUP BY st.store_name
ORDER BY store_total_revenue DESC;


--------------------------------------------------------------------------------
-- 11. MOST PROFITABLE PRODUCTS
-- Business Goal: Identify the top 20 most profitable products based on profit margin.
--------------------------------------------------------------------------------
SELECT TOP 20
    product_name,
    (unit_price - cost_price) AS unit_profit
FROM Products
ORDER BY unit_profit DESC;


--------------------------------------------------------------------------------
-- 12. TOP SPENDING CUSTOMERS
-- Business Goal: Identify the top 50 high-value customers by total spending.
--------------------------------------------------------------------------------
SELECT TOP 50
    c.customer_id,
    SUM(s.total_amount) AS total_amount
FROM Customer_Loyalty AS c
INNER JOIN Sales AS s
    ON c.customer_id = s.customer_id
GROUP BY c.customer_id
ORDER BY total_amount DESC;


--------------------------------------------------------------------------------
-- 13. LOYALTY TIER PERFORMANCE METRICS
-- Business Goal: Analyze average points, spending, and customer counts per loyalty tier.
--------------------------------------------------------------------------------
SELECT
    c.loyalty_level,
    COUNT(c.customer_id) AS total_customers,
    AVG(c.total_points) AS avg_points,
    AVG(s.total_amount) AS avg_customer_spend
FROM Customer_Loyalty AS c
INNER JOIN Sales AS s
    ON c.customer_id = s.customer_id
GROUP BY c.loyalty_level
ORDER BY total_customers DESC;


--------------------------------------------------------------------------------
-- 14. MONTHLY SALES TRENDS
-- Business Goal: Track revenue performance over time broken down by year and month.
--------------------------------------------------------------------------------
SELECT
    YEAR(sale_date) AS sale_year,
    MONTH(sale_date) AS sale_month,
    SUM(total_amount) AS total_amount
FROM Sales
GROUP BY YEAR(sale_date), MONTH(sale_date)
ORDER BY sale_year, sale_month;


--------------------------------------------------------------------------------
-- 15. TOP 5 PRODUCTS PER STORE (Advanced Window Functions)
-- Business Goal: For every store, identify its top 5 products ranked by revenue.
--------------------------------------------------------------------------------
WITH RankedStoreProducts AS (
    SELECT 
        s.store_id,
        p.product_name,
        SUM(s.total_amount) AS total_revenue,
        DENSE_RANK() OVER (PARTITION BY s.store_id ORDER BY SUM(s.total_amount) DESC) AS product_rank
    FROM Sales s
    INNER JOIN Products p 
        ON s.product_id = p.product_id
    GROUP BY s.store_id, p.product_name
)
SELECT *
FROM RankedStoreProducts
WHERE product_rank <= 5;


--------------------------------------------------------------------------------
-- 16. INVENTORY REORDER ALERTS
-- Business Goal: Identify products where stock levels have reached or dropped 
-- below the reorder threshold.
--------------------------------------------------------------------------------
SELECT
    st.store_name,
    p.product_name,
    sk.quantity AS current_quantity,
    sk.reorder_level,
    (sk.quantity - sk.reorder_level) AS stock_difference
FROM Products p
INNER JOIN Stock sk
    ON p.product_id = sk.product_id
INNER JOIN Stores st
    ON sk.store_id = st.store_id
WHERE sk.quantity <= sk.reorder_level;


--------------------------------------------------------------------------------
-- 17. TOP 3 EMPLOYEES PER STORE BY REVENUE (Window Functions)
-- Business Goal: Identify the top 3 performing employees per store based on sales revenue.
--------------------------------------------------------------------------------
WITH EmployeesPerformance AS (
    SELECT
        st.store_name,
        e.employee_name,
        SUM(sa.total_amount) AS total_revenue,
        DENSE_RANK() OVER (PARTITION BY st.store_name ORDER BY SUM(sa.total_amount) DESC) AS employee_rank
    FROM Employees e
    INNER JOIN Sales sa
        ON e.employee_id = sa.employee_id
    INNER JOIN Stores st
        ON sa.store_id = st.store_id
    GROUP BY e.employee_name, st.store_name
)
SELECT * 
FROM EmployeesPerformance
WHERE employee_rank <= 3;


--------------------------------------------------------------------------------
-- 18. SIGNIFICANT REVENUE CONTRIBUTORS BY CATEGORY (Advanced CTE & Filtering)
-- Business Goal: Identify product categories contributing 10% or more 
-- to the overall company revenue.
--------------------------------------------------------------------------------
WITH CategoryTotalRevenue AS (
    SELECT
        cat.category_name,
        SUM(sl.total_amount) AS category_revenue
    FROM Categories cat
    INNER JOIN Products pr
        ON cat.category_id = pr.category_id
    INNER JOIN Sales sl
        ON pr.product_id = sl.product_id
    GROUP BY cat.category_name
),
CompanyTotalRevenue AS (
    SELECT
        SUM(category_revenue) AS overall_revenue
    FROM CategoryTotalRevenue
)
SELECT
    ctr.category_name,
    ctr.category_revenue,
    ctrtr.overall_revenue,
    ROUND((ctr.category_revenue * 100.0 / ctrtr.overall_revenue), 2) AS percentage_contribution
FROM CategoryTotalRevenue ctr
CROSS JOIN CompanyTotalRevenue ctrtr
WHERE (ctr.category_revenue * 100.0 / ctrtr.overall_revenue) >= 10
ORDER BY percentage_contribution DESC;


--------------------------------------------------------------------------------
-- 19. CUSTOMER SPENDING TIER SEGMENTATION (CASE Logic & CTE)
-- Business Goal: Segment customers into specific tiers (VIP, A Class, B Class, etc.) 
-- based on their lifetime spending value.
--------------------------------------------------------------------------------
WITH CustomersSpend AS (
    SELECT
        c.customer_id,
        SUM(s.total_amount) AS total_spend
    FROM Customer_Loyalty c
    INNER JOIN Sales s
        ON c.customer_id = s.customer_id
    GROUP BY c.customer_id
)
SELECT
    customer_id,
    total_spend,
    CASE
        WHEN total_spend >= 80000 THEN 'VIP'
        WHEN total_spend > 64000 THEN 'A Class'
        WHEN total_spend > 50000 THEN 'B Class' 
        WHEN total_spend > 35000 THEN 'C Class'
        ELSE 'Normal'
    END AS customer_category
FROM CustomersSpend
ORDER BY total_spend DESC;


--------------------------------------------------------------------------------
-- 20. REGIONAL STORE PERFORMANCE BENCHMARKING (Advanced Window Functions)
-- Business Goal: Compare each store's revenue against the average revenue 
-- of stores within the same region.
--------------------------------------------------------------------------------
WITH StoreRevenues AS (
    SELECT
        s.region,
        s.store_name,
        SUM(sa.total_amount) AS store_revenue
    FROM Stores s
    INNER JOIN Sales sa
        ON s.store_id = sa.store_id
    GROUP BY s.region, s.store_name
),
RegionalComparison AS (
    SELECT
        region,
        store_name,
        store_revenue,
        AVG(store_revenue) OVER (PARTITION BY region) AS regional_avg_revenue
    FROM StoreRevenues
)
SELECT
    region,
    store_name,
    store_revenue,
    regional_avg_revenue,
    CASE
        WHEN store_revenue > regional_avg_revenue THEN 'Above Average'
        WHEN store_revenue < regional_avg_revenue THEN 'Below Average'
        ELSE 'Equal'
    END AS performance_status
FROM RegionalComparison
ORDER BY region, store_revenue DESC;


--------------------------------------------------------------------------------
-- 21. HIGH-VALUE CROSS-STORE LOYAL CUSTOMERS (Complex Subqueries & HAVING)
-- Business Goal: Identify loyal customers with more than 10 purchases, 
-- buying from multiple stores, and spending above the average customer.
--------------------------------------------------------------------------------
SELECT
    cl.customer_id,
    SUM(s.total_amount) AS total_revenue,
    COUNT(s.sale_id) AS count_orders,
    COUNT(DISTINCT s.store_id) AS count_stores
FROM Customer_Loyalty cl
INNER JOIN Sales s
    ON cl.customer_id = s.customer_id
GROUP BY cl.customer_id
HAVING
    COUNT(s.sale_id) > 10
    AND COUNT(DISTINCT s.store_id) > 1
    AND SUM(s.total_amount) > (
        SELECT AVG(customer_total) 
        FROM (
            SELECT SUM(total_amount) AS customer_total 
            FROM Sales 
            GROUP BY customer_id
        ) t
    );