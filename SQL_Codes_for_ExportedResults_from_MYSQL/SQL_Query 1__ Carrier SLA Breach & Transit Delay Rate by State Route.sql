USE olist_analytics;

SELECT 
    c.customer_state AS state,
    COUNT(o.order_id) AS total_orders,
    ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)), 1) AS avg_delivery_days,
    ROUND(AVG(DATEDIFF(o.order_estimated_delivery_date, o.order_purchase_timestamp)), 1) AS avg_estimated_days,
    ROUND(100.0 * SUM(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END) / COUNT(o.order_id), 2) AS sla_breach_rate_pct
FROM fact_orders o
JOIN dim_customers c ON o.customer_id = c.customer_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
HAVING total_orders > 500
ORDER BY sla_breach_rate_pct DESC;