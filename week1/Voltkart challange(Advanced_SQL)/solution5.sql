-- The CRM team wants to size up the customer base by value. 
-- Split customers into four quartiles by lifetime completed spend, and for each quartile report how many
-- customers fall in it and their average spend. Required output: spend_quartile, customer_count, avg_lifetime_spend
-- explination:
--  So our first task is:
-- Calculate total completed spending for each customer.
SELECT customer_id,
    SUM(order_total) AS lifetime_spend
FROM fact_orders
WHERE order_status = 'Completed'
GROUP BY customer_id;
-- Now comes the new concept: NTILE(4)
-- Divide the rows into 4 roughly equal groups.
-- Why ORDER BY lifetime_spend?Because we want the customers sorted by their spending:
-- WITH customer_spend AS (
--     SELECT customer_id,
--         SUM(order_total) AS lifetime_spend
--     FROM fact_orders
--     WHERE order_status = 'Completed'
--     GROUP BY customer_id
-- )
WITH customer_spend AS (
    SELECT customer_id,
        SUM(order_total) AS lifetime_spend
    FROM fact_orders
    WHERE order_status = 'Completed'
    GROUP BY customer_id
),
customer_quartiles AS (
    SELECT customer_id,
        lifetime_spend,
        NTILE(4) OVER (
            ORDER BY lifetime_spend
        ) AS spend_quartile
    FROM customer_spend
) -- NTILE() doesn’t calculate the average.It simply gives each customer a bucket number
-- Finally GROUP BY the quartile
-- Now the question says:“for each quartile report how many customers fall in it and their average spend.”
SELECT spend_quartile,
    COUNT(*) AS customer_count,
    AVG(lifetime_spend) AS avg_lifetime_spend
FROM customer_quartiles
GROUP BY spend_quartile;
-- fact_orders
--      │
--      │ WHERE Completed
--      ↓
-- ┌─────────────────────────┐
-- │ One row per customer    │
-- │                         │
-- │ customer | total spend  │
-- └─────────────────────────┘
--      │
--      │ NTILE(4)
--      ↓
-- ┌─────────────────────────┐
-- │ Customer + Quartile     │
-- │                         │
-- │ A | ₹1,000 | 1          │
-- │ B | ₹2,000 | 1          │
-- │ C | ₹5,000 | 2          │
-- │ ...                     │
-- └─────────────────────────┘
--      │
--      │ GROUP BY quartile
--      ↓
-- ┌──────────────────────────────┐
-- │ Quartile | Count | Avg Spend │
-- │    1     |   25  | ₹1,200    │
-- │    2     |   25  | ₹2,500    │
-- │    3     |   25  | ₹4,000    │
-- │    4     |   25  | ₹9,000    │
-- └──────────────────────────────┘
SELECT *
FROM fact_orders
SELECT customer_id,
    order_total
FROM fact_orders
WHERE order_status = 'Completed'
GROUP BY customer_id,
    order_total
select customer_id,
    sum(order_total) as lifetime_spend
from fact_orders
where order_status = 'Completed'
group by customer_id;
--  explian this
WITH customer_spend AS (
    SELECT customer_id,
        SUM(order_total) AS lifetime_spend
    FROM fact_orders
    WHERE order_status = 'Completed'
    GROUP BY customer_id
),
customer_quartiles AS (
    SELECT customer_id,
        lifetime_spend,
        NTILE(4) OVER (
            ORDER BY lifetime_spend
        ) AS spend_quartile
    FROM customer_spend
)
SELECT spend_quartile,
    COUNT(*) AS customer_count,
    AVG (lifetime_spend) AS avg_lifetime_spend
from customer_quartiles
GROUP BY spend_quartile
ORDER BY spend_quartile;