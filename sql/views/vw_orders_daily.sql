CREATE VIEW vw_orders_daily AS
SELECT
    order_purchase_date,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN is_canceled = 0 THEN 1 ELSE 0 END) AS non_canceled_orders,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) AS canceled_orders
FROM fact_orders
GROUP BY order_purchase_date;
