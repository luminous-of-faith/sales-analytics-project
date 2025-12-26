/* =========================================================
   FACT TABLE: fact_order_items
   Grain: 1 row = 1 item in an order
   Purpose: revenue components, product mix, freight analysis
   ========================================================= */

CREATE TABLE fact_order_items (
    order_id VARCHAR(50) NOT NULL,
    order_item_id INT NOT NULL,

    product_id VARCHAR(50) NOT NULL,
    seller_id VARCHAR(50) NOT NULL,

    -- Raw economic values (no revenue logic)
    price DECIMAL(10,2) NOT NULL,
    freight_value DECIMAL(10,2) NOT NULL,

    -- SLA-related (date-level by design)
    shipping_limit_date DATE NULL,

    -- Sanity flags
    is_zero_price BIT NOT NULL,
    is_negative_price BIT NOT NULL,
    is_high_freight BIT NOT NULL,

    CONSTRAINT pk_fact_order_items
        PRIMARY KEY (order_id, order_item_id),

    CONSTRAINT fk_fact_order_items_orders
        FOREIGN KEY (order_id)
        REFERENCES fact_orders(order_id)
);

-- Indexes for joins and analysis
CREATE INDEX idx_fact_order_items_order
    ON fact_order_items (order_id);

CREATE INDEX idx_fact_order_items_product
    ON fact_order_items (product_id);
