CREATE TABLE agg_orders_daily (
    order_date DATE NOT NULL,
    total_orders INT NOT NULL,
    non_canceled_orders INT NOT NULL,
    canceled_orders INT NOT NULL,
    cancellation_rate DECIMAL(5,4) NOT NULL,
    CONSTRAINT pk_agg_orders_daily PRIMARY KEY (order_date)
);
