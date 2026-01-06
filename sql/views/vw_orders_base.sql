CREATE VIEW vw_orders_base AS
SELECT
    order_id,
    customer_id,
    order_purchase_date,
    order_purchase_timestamp,
    order_status,
    is_canceled,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM fact_orders;
