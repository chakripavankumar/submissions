-- question
-- Marketing wants to re-engage people who registered but never bought. 
-- List the customers who have never placed an order.
-- Required output: customer_id, customer_name, signup_date.
-- Intuition:
-- We can use a NOT EXISTS clause to filter out customers who have placed orders in the fact_orders table. By selecting from the dim_customer table and checking for the absence of corresponding records in the fact_orders table, we can identify customers who have never made a purchase.
-- We need to find customers from the dimension table who do not have any corresponding records in the fact table.
-- Approach:
-- We will select the customer_id, customer_name, and signup_date from the dim_customer table.
-- We will use a NOT EXISTS clause to filter out customers who have placed orders in the fact_orders table. 
--This will allow us to identify customers who have never made a purchase.
-- Explanation :
-- we're using an anti join pattern here. 
--The NOT EXISTS clause checks for the absence of records in the fact_orders table for each customer in the dim_customer table.
-- If no matching records are found, the customer is included in the result set.
-- why we not using  NOT IN: 
-- NOT IN can lead to unexpected results if the subquery returns NULL values. 
-- In this case, if any customer_id in fact_orders is NULL, the NOT IN condition will not return any rows, even for customers who have never placed an order. 
-- Using NOT EXISTS avoids this issue and ensures accurate results.
-- INSIDE WHERE we are using a correlated subquery to check for the existence of orders for each customer.
SELECT c.customer_id,
    c.customer_name,
    c.signup_date
FROM dim_customer AS c
WHERE NOT EXISTS (
        SELECT 1
        FROM fact_orders AS fa
        WHERE fa.customer_id = c.customer_id
    )