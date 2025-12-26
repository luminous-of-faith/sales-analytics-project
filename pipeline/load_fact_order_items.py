import pandas as pd
from sqlalchemy import create_engine
import urllib

# -------------------------------
# SQL Server connection (Windows Auth)
# -------------------------------
server = r".\\SQLEXPRESS"   # adjust if needed
database = "sales-analytics"

params = urllib.parse.quote_plus(
    f"DRIVER=ODBC Driver 17 for SQL Server;"
    f"SERVER={server};"
    f"DATABASE={database};"
    f"Trusted_Connection=yes;"
)

engine = create_engine(f"mssql+pyodbc:///?odbc_connect={params}")

# -------------------------------
# Load clean order_items data
# -------------------------------
order_items = pd.read_csv(
    "data/clean/order_items_clean.csv",
    parse_dates=["shipping_limit_date"]
)

fact_order_items_cols = [
    "order_id",
    "order_item_id",
    "product_id",
    "seller_id",
    "price",
    "freight_value",
    "shipping_limit_date",
    "is_zero_price",
    "is_negative_price",
    "is_high_freight"
]

fact_order_items_df = order_items[fact_order_items_cols]

# -------------------------------
# Load into SQL Server
# -------------------------------
fact_order_items_df.to_sql(
    name="fact_order_items",
    con=engine,
    schema="dbo",
    if_exists="append",
    index=False,
    chunksize=1000
)

print("fact_order_items load completed")
print("Rows loaded:", len(fact_order_items_df))
print("Distinct orders:", fact_order_items_df["order_id"].nunique())
