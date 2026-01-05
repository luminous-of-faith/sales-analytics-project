import pandas as pd
import urllib
import os
from sqlalchemy import create_engine
from logging_config import get_logger

logger = get_logger("load_fact_order_items")

def main():
    logger.info("Starting load_fact_order_items pipeline")

    try:
        # -------------------------------
        # Resolve paths
        # -------------------------------
        BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        DATA_DIR = os.path.join(BASE_DIR, "data", "clean")
        ITEMS_FILE = os.path.join(DATA_DIR, "order_items_clean.csv")

        if not os.path.exists(ITEMS_FILE):
            raise FileNotFoundError(f"Order items file not found: {ITEMS_FILE}")

        # -------------------------------
        # SQL Server connection
        # -------------------------------
        server = r".\SQLEXPRESS"
        database = "sales-analytics"

        params = urllib.parse.quote_plus(
            f"DRIVER=ODBC Driver 17 for SQL Server;"
            f"SERVER={server};"
            f"DATABASE={database};"
            f"Trusted_Connection=yes;"
        )

        engine = create_engine(f"mssql+pyodbc:///?odbc_connect={params}")
        logger.info("SQL Server connection created")

        # -------------------------------
        # Read data
        # -------------------------------
        order_items = pd.read_csv(
            ITEMS_FILE,
            parse_dates=["shipping_limit_date"]
        )

        logger.info("Order items CSV loaded | rows=%d", len(order_items))

        # -------------------------------
        # Transform
        # -------------------------------
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

        if fact_order_items_df["order_id"].isnull().any():
            raise ValueError("Null order_id detected in order_items")

        logger.info(
            "Prepared fact_order_items dataframe | rows=%d | distinct_orders=%d",
            len(fact_order_items_df),
            fact_order_items_df["order_id"].nunique()
        )

        # -------------------------------
        # Load
        # -------------------------------
        fact_order_items_df.to_sql(
            name="fact_order_items",
            con=engine,
            schema="dbo",
            if_exists="append",
            index=False,
            chunksize=1000
        )

        logger.info("fact_order_items successfully loaded")

    except Exception:
        logger.exception("fact_order_items load FAILED")
        raise

    finally:
        logger.info("Ending load_fact_order_items pipeline")


if __name__ == "__main__":
    main()
