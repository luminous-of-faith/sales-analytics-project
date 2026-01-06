CREATE VIEW vw_order_revenue AS
SELECT
    order_id,
    COUNT(*) AS items_in_order,
    SUM(price) AS order_price,
    SUM(freight_value) AS order_freight,
    SUM(price + freight_value) AS order_gross_revenue
FROM fact_order_items
GROUP BY order_id;
