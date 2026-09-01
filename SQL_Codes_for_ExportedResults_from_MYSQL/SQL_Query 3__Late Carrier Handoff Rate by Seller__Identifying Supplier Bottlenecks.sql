SELECT 
    s.seller_id,
    s.seller_state,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_sales_value,
    ROUND(100.0 * SUM(CASE WHEN oi.shipping_limit_date < o.order_delivered_carrier_date THEN 1 ELSE 0 END) / COUNT(oi.order_id), 2) AS late_carrier_handoff_pct
FROM fact_order_items oi
JOIN fact_orders o ON oi.order_id = o.order_id
JOIN dim_sellers s ON oi.seller_id = s.seller_id
WHERE o.order_delivered_carrier_date IS NOT NULL
GROUP BY s.seller_id, s.seller_state
HAVING total_orders >= 50
ORDER BY late_carrier_handoff_pct DESC
LIMIT 10;