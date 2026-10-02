-- Question:
-- Finance wants the revenue trend with momentum. 
-- Produce monthly completed revenue with a cumulative running total and the month-over-month %  change 
-- Required output: order_month (YYYY-MM), monthly_revenue, running_total, mom_pct_change.

intuition:
-- We can use a Common Table Expression (CTE) to calculate the monthly revenue from completed orders. 
-- Then, we can use window functions to calculate the cumulative running total and the month-over-month percentage change. 
-- The running total can be calculated using the SUM() window function,
-- and the month-over-month percentage change can be calculated using the LAG() window function to compare the current month's revenue with the previous month's revenue.
-- Approach:
-- 1. What is being asked?
--     * Monthly completed revenue with a cumulative running total and the month-over-month % change.
-- 2. Which table contains the main business event?
--     * fact_orders.
-- 3. Which columns are needed?
--     * order_date, order_total.
-- 4. Any filtering?
--     * order_status = 'Completed'.
-- 5. Any grouping?
--     * Group by month (YYYY-MM).
-- 6. Any window functions?
--     * SUM() for running total, LAG() for month-over-month % change.
-- Explanation:
-- The query first calculates the monthly revenue from completed orders using a CTE.
-- Then, it calculates the cumulative running total and the month-over-month percentage change using window functions. 
-- The final result is ordered by order_month to show the revenue trend over time.      

SELECT order_date,
    order_total
FROM fact_orders
WHERE order_status = 'Completed';
SELECT CONVERT (CHAR(7), order_date, 126) as order_month,
    order_total
FROM fact_orders
WHERE order_status = 'Completed';
SELECT CONVERT(char(7), order_date, 126) AS order_month,
    SUM(order_total) AS monthly_revenue
FROM fact_orders
WHERE order_status = 'Completed'
GROUP BY CONVERT(char(7), order_date, 126);
WITH monthly_revenue AS (
    SELECT CONVERT(char(7), order_date, 126) AS order_month,
        SUM(order_total) AS monthly_revenue
    FROM fact_orders
    WHERE order_status = 'Completed'
    GROUP BY CONVERT(char(7), order_date, 126)
)
SELECT order_month,
    monthly_revenue,
    SUM(monthly_revenue) OVER (
        ORDER BY order_month
    ) AS running_total,
    (
        (
            monthly_revenue - LAG(monthly_revenue) OVER (
                ORDER BY order_month
            )
        ) / NULLIF(
            LAG(monthly_revenue) OVER (
                ORDER BY order_month
            ),
            0
        )
    ) * 100 AS mom_pct_change
FROM monthly_revenue
ORDER BY order_month;