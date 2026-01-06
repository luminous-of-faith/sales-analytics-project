CREATE VIEW vw_cancellation_rate_daily AS
SELECT
    order_purchase_date,
    canceled_orders * 1.0 / COALESCE(total_orders, 0) AS cancellation_rate
FROM vw_orders_daily;
