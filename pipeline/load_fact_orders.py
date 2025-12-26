import pandas as pd
from sqlalchemy import create_engine
import urllib

# -------------------------------
# SQL Server connection (Windows Auth)
# -------------------------------

server = ".\\SQLEXPRESS"
database = "sales-analytics"

params = urllib.parse.quote_plus(
    f"DRIVER=ODBC Driver 17 for SQL Server;"
    f"SERVER={server};"
    f"DATABASE={database};"
    f"Trusted_Connection=yes;"
)

engine = create_engine(f"mssql+pyodbc:///?odbc_connect={params}")

# -------------------------------
# Load clean orders data
# -------------------------------
orders = pd.read_csv(
    "data/clean/orders_clean.csv",
    parse_dates=[
        "order_purchase_timestamp",
        "order_approved_at",
        "order_delivered_carrier_date",
        "order_delivered_customer_date",
        "order_estimated_delivery_date"
    ]
)

# Derive analytics-friendly date
orders["order_purchase_date"] = orders["order_purchase_timestamp"].dt.date

fact_orders_cols = [
    "order_id",
    "customer_id",
    "order_status",
    "order_purchase_date",
    "order_purchase_timestamp",
    "order_approved_at",
    "order_delivered_carrier_date",
    "order_delivered_customer_date",
    "order_estimated_delivery_date",
    "has_approved_date",
    "has_carrier_date",
    "has_delivery_date",
    "is_canceled"
]

fact_orders_df = orders[fact_orders_cols]

# -------------------------------
# Load into SQL Server
# -------------------------------
fact_orders_df.to_sql(
    name="fact_orders",
    con=engine,
    schema="dbo",
    if_exists="append",
    index=False,
    chunksize=5000,
    method="multi"
)

print("fact_orders load completed")
print("Rows loaded:", len(fact_orders_df))
print("Distinct orders:", fact_orders_df["order_id"].nunique())
