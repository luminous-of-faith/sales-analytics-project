CREATE VIEW vw_delivery_days_daily AS
SELECT
    order_purchase_date,
    AVG(
        DATEDIFF(
            DAY,
            order_purchase_date,
            order_delivered_customer_date
        )
    ) AS avg_delivery_days
FROM vw_orders_base
WHERE
    is_canceled = 0
    AND order_delivered_customer_date IS NOT NULL
GROUP BY order_purchase_date;
