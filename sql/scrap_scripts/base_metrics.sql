--cancelation rate
with orders_details as(
select
count(*) as Total_orders,
sum(case when is_canceled=1 then 1 else 0 end) as cancled_orders,
sum(case when is_canceled=0 then 1 else 0 end) as non_canceled_orders
from fact_orders
)
select
cancled_orders,
total_orders,
cast(cancled_orders as decimal(10,2))*100/cast(Total_orders as decimal(10,2)) as cancelation_rate
from orders_details

--gross Revenue
with gross_revenue as (
select
order_id,
SUM(COALESCE(cast(price as decimal(10,2)),0)+COALESCE(cast(freight_value as decimal(10,2)),0)) as Revenue
from fact_order_items
group by order_id
)
select
g.order_id,
g.revenue
from gross_revenue g
join fact_orders f on f.order_id=g.order_id
where is_canceled=0


--Aov
with AOV as (
select
oi.order_id,
count(*) as non_canceled_orders,
SUM(COALESCE(cast(price as decimal(10,2)),0)+COALESCE(cast(freight_value as decimal(10,2)),0)) as Revenue
from fact_order_items oi
join fact_orders o on o.order_id=oi.order_id
where is_canceled=0
group by oi.order_id
)
select
CAST(sum(revenue)/sum(non_canceled_orders) as decimal(5,2)) as Average_Order_Value
from AOV

-- Daily orders

select
order_purchase_date,
count(*) as Total_orders,
sum(case when is_canceled=1 then 1 else 0 end) as cancled_orders,
sum(case when is_canceled=0 then 1 else 0 end) as non_canceled_orders
from fact_orders
group by order_purchase_date


select top 100 * from fact_orders

--Delivered order

select
count(*) as Delivered_orders

from fact_orders
where has_delivery_date=1 AND is_canceled=0


---Average delivery days

select
order_id,
order_purchase_timestamp,
order_delivered_customer_date,
datediff(DAY,order_purchase_timestamp,order_delivered_customer_date) as average_delivery_day
from fact_orders
where is_canceled=0 and has_delivery_date=1


--- on time delivery rate
with delivered_orders as
(
select
count(*) as delivered_orders,
sum(case when order_delivered_customer_date <= order_estimated_delivery_date then 1 else 0 End) as delivered_on_time
from fact_orders
where has_delivery_date=1 AND is_canceled=0
)
select

CAST(cast(delivered_on_time as decimal(10,2)) * 100/ cast(delivered_orders as decimal(10,2)) as Decimal(5,2)) as on_time_delivery_rate
from delivered_orders

---items per orders

Select
order_id,
count(*) as total_items

from fact_order_items
group by order_id

--- Freight as % of revenue
with freight_pct_as_revenue as
(
select
oi.order_id,
count(*) as non_canceled_orders,
SUM(CAST(COALESCE(price,0) as decimal(10,2)) + CAST(COALESCE(freight_value,0) as DECIMAL(10,2))) as Revenue,
SUM(price+freight_value) as demop_revenue,
SUM(COALESCE(cast(freight_value as decimal(10,2)),0)) as freight_revenue
from fact_order_items oi
left join fact_orders o on o.order_id=oi.order_id
group by oi.order_id
)
select

-- Zero price orde price


select top 100 * from fact_orders


