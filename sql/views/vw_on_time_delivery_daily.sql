CREATE VIEW vw_on_time_delivery_daily AS
SELECT
    order_purchase_date,
    SUM(
        CASE
            WHEN order_delivered_customer_date <= order_estimated_delivery_date
            THEN 1 ELSE 0
        END
    ) * 1.0 / COALESCE(COUNT(order_id), 0) AS on_time_delivery_rate
FROM vw_orders_base
WHERE
    is_canceled = 0
    AND order_delivered_customer_date IS NOT NULL
GROUP BY order_purchase_date;
