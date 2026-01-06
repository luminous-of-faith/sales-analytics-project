CREATE VIEW vw_freight_pct_daily AS
SELECT
    order_purchase_date,
    total_freight * 1.0 / COALESCE(gross_revenue, 0) AS freight_pct
FROM vw_revenue_daily;
