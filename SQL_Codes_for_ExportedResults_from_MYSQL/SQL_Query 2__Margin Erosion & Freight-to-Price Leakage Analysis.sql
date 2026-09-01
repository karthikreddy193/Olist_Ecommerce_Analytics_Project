SELECT 
    p.product_category_name_english AS category,
    COUNT(oi.order_item_id) AS items_sold,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(SUM(oi.freight_value), 2) AS total_freight_paid,
    ROUND(AVG(oi.freight_value / NULLIF(oi.price, 0)) * 100, 2) AS freight_to_price_ratio_pct
FROM fact_order_items oi
JOIN dim_products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name_english
HAVING items_sold > 100
ORDER BY freight_to_price_ratio_pct DESC
LIMIT 15;