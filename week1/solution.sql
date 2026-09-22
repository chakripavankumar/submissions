--  question 1
-- Voltkart's commercial team wants a quick look at the biggest sales. Return the
-- top 20 completed orders by value, with the customer and the sales rep behind each one. 
-- Required output: order_id, order_date, customer_name, sales_rep_name, order_total.
SELECT TOP 20 fo.order_id,
    fo.order_date,
    dc.customer_name,
    de.employee_name as sales_rep_name,
    fo.order_total
FROM fact_orders fo
    JOIN dim_customer dc ON fo.customer_id = dc.customer_id
    JOIN dim_employee de ON fo.sales_rep_id = de.employee_id
WHERE fo.order_status = 'Completed'
ORDER BY fo.order_total DESC;
-- Intuition:
-- We need to find the top 20 completed orders based on their total value and display relevant customer and sales representative information.
-- Approach:
-- 1. What is being asked?
--     * Top 20 completed orders.
-- 2. Which table contains the main business event?
--     * fact_orders.
-- 3. Which IDs need descriptive values?
--     * customer_id → dim_customer
--     * sales_rep_id → dim_employee
-- 4. Any filtering?
--     * order_status = 'Completed'
-- 5. Any sorting?
--     * Highest order_total.
-- 6. Any limiting?
--     * LIMIT 20.      
-- Explanation:
-- The query selects the top 20 completed orders from the fact_orders table, 
-- joining with dim_customer and dim_employee to retrieve the customer name and sales representative name. 
-- The results are filtered to include only completed orders and sorted by order total in descending order.
-- 1st join means initially we are joining the fact_orders table with dim_customer and dim_employee tables to get the customer name and sales rep name respectively.
-- 2nd join means we are joining the result of the first join with dim_employee table to get the sales rep name.
-- why are we doing the join with dim_customer and dim_employee tables?
-- We are joining with dim_customer and dim_employee tables to retrieve the descriptive names (customer_name and employee_name) corresponding to the customer_id and sales_rep_id present in the fact_orders table.
-- why are we  doing the join fact_orders table with dim_customer and dim_employee tables?
-- We are joining the fact_orders table with dim_customer and dim_employee tables to get the customer name and sales representative name for each order, as the fact_orders table only contains IDs (customer_id and sales_rep_id) which are not descriptive. The joins allow us to replace these IDs with meaningful