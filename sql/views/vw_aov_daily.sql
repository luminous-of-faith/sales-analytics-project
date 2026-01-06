CREATE VIEW vw_aov_daily AS
SELECT
    order_purchase_date,
    gross_revenue / COALESCE(non_canceled_orders, 0) AS aov
FROM vw_revenue_daily;
