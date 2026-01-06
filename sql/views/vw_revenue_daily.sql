CREATE VIEW vw_revenue_daily AS
SELECT
    o.order_purchase_date,
    COUNT(o.order_id) AS non_canceled_orders,
    SUM(r.order_gross_revenue) AS gross_revenue,
    SUM(r.order_freight) AS total_freight
FROM vw_orders_base o
JOIN vw_order_revenue r
    ON o.order_id = r.order_id
WHERE o.is_canceled = 0
GROUP BY o.order_purchase_date;
