CREATE TABLE agg_revenue_daily (
    order_date DATE NOT NULL,
    gross_revenue DECIMAL(18,2) NOT NULL,
    total_freight DECIMAL(18,2) NOT NULL,
    aov DECIMAL(10,2) NOT NULL,
    avg_items_per_order DECIMAL(10,4) NOT NULL,
    CONSTRAINT pk_agg_revenue_daily PRIMARY KEY (order_date)
);
