CREATE VIEW vw_items_per_order_daily AS
SELECT
    o.order_purchase_date,
    AVG(r.items_in_order * 1.0) AS avg_items_per_order
FROM vw_orders_base o
JOIN vw_order_revenue r
    ON o.order_id = r.order_id
WHERE o.is_canceled = 0
GROUP BY o.order_purchase_date;
