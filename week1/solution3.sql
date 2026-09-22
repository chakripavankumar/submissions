-- question 3
-- Merchandising wants the stars of each category. 
-- For every category, return the
-- top 3 products by completed revenue. 
-- Required output: category_name, product_name, total_revenue, revenue_rank
-- Intuition:
-- We can use the RANK() window function to assign a rank to each product within its category based on the total revenue generated from completed orders. 
-- By partitioning the data by category and ordering
-- Approach:
-- we will Join dim_product and dim_category to get names.
-- Filter for order_status = 'Completed' (since merchandising wants revenue from successful sales).
-- Group by category and product to calculate total revenue.
-- Use RANK() to assign a rank to each product within its category based on total revenue
-- Finally, filter to keep only the top 3 products per category.
-- Common Table Expressions Think of these as temporary tables you create just for this calculation.
-- the product_revenue CTE
-- Goal: Calculate the total money earned by every single product.
-- FROM fact_order_items oi: We start here because this table holds the actual money (line_amount).
-- JOIN: We join with other tables to get context:
-- fact_orders: To check if the order was actually paid (Completed).
-- dim_product: To get the product_name.
-- dim_category: To get the category_name.
-- WHERE o.order_status = 'Completed': This is crucial. We ignore Cancelled or Returned orders. Merchandising only cares about revenue actually collected.
-- GROUP BY: A product like "iPhone 15" might appear 1,000 times in fact_order_items. This command squashes those 1,000 rows into one single row per product.
-- SUM(oi.line_amount): Adds up all the sales for that product into total_revenue.
-- Result of Stage 1: A list of every product with its total revenue and category
WITH product_revenue AS (
    SELECT c.category_name,
        p.product_name,
        SUM(oi.line_amount) as total_revenue
    FROM fact_order_items oi
        JOIN fact_orders o ON oi.order_id = o.order_id
        JOIN dim_product p ON oi.product_id = p.product_id
        JOIN dim_category c ON p.category_id = c.category_id
    WHERE o.order_status = 'Completed'
    GROUP BY c.category_name,
        p.product_name
),
ranked_products AS (
    SELECT category_name,
        product_name,
        total_revenue,
        RANK() OVER (
            PARTITION BY category_name
            ORDER BY total_revenue DESC
        ) as revenue_rank
    FROM product_revenue
)
SELECT category_name,
    product_name,
    total_revenue,
    revenue_rank
FROM ranked_products
WHERE revenue_rank <= 3
ORDER BY category_name,
    revenue_rank;