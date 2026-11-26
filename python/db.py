import os
from urllib.parse import quote_plus
from dotenv import load_dotenv
from sqlalchemy import create_engine
import pandas as pd

load_dotenv()

user = os.environ["DB_USER"]
password = quote_plus(os.environ["DB_PASSWORD"])
host = os.environ["DB_HOST"]
port = os.environ["DB_PORT"]
dbname = os.environ["DB_NAME"]

engine = create_engine(f"postgresql+psycopg2://{user}:{password}@{host}:{port}/{dbname}")

dim_campaigns=pd.read_csv("../data/dim_campaigns.csv")
dim_csm=pd.read_csv("../data/dim_csm.csv")
dim_customers=pd.read_csv("../data/dim_customers.csv")
#dim_date=pd.read_csv("../data/dim_date.csv")
dim_incidents=pd.read_csv("../data/dim_incidents.csv")
dim_plans=pd.read_csv("../data/dim_plans.csv")
fact_account_month=pd.read_csv("../data/fact_account_month.csv")
fact_cancellations=pd.read_csv("../data/fact_cancellations.csv")
fact_invoices=pd.read_csv("../data/fact_invoices.csv")
fact_marketing_monthly=pd.read_csv("../data/fact_marketing_monthly.csv")
fact_nps_surveys=pd.read_csv("../data/fact_nps_surveys.csv")
fact_support_tickets=pd.read_csv("../data/fact_support_tickets.csv")

try:
    # Clear existing rows in dependency order so re-runs don't hit UniqueViolation
    with engine.begin() as conn:
        conn.execute(text('''
            TRUNCATE TABLE
                "Zuri".fact_account_month,
                "Zuri".fact_cancellations,
                "Zuri".fact_invoices,
                "Zuri".fact_marketing_monthly,
                "Zuri".fact_nps_surveys,
                "Zuri".fact_support_tickets,
                "Zuri".dim_campaigns,
                "Zuri".dim_csm,
                "Zuri".dim_customers,
                "Zuri".dim_incidents,
                "Zuri".dim_plans
            RESTART IDENTITY
        '''))

    dim_campaigns.to_sql(
        name="dim_campaigns",
        schema="Zuri",
        con=engine,
        if_exists="append",
        index=False,
        chunksize=1000,
        method="multi",
    )

    dim_csm.to_sql(
        name="dim_csm",
        schema="Zuri",
        con=engine,
        if_exists="append",
        index=False,
        chunksize=1000,
        method="multi",
    )

    dim_customers.to_sql(
        name="dim_customers",
        schema="Zuri",
        con=engine,
        if_exists="append",
        index=False,
        chunksize=1000,
        method="multi",
    )

    # dim_date.to_sql(
    #     name="dim_date",
    #     schema="Zuri",
    #     con=engine,
    #     if_exists="append",
    #     index=False,
    #     chunksize=1000,
    #     method="multi",
    # )

    dim_incidents.to_sql(
        name="dim_incidents",
        schema="Zuri",
        con=engine,
        if_exists="append",
        index=False,
        chunksize=1000,
        method="multi",
    )

    dim_plans.to_sql(
        name="dim_plans",
        schema="Zuri",
        con=engine,
        if_exists="append",
        index=False,
        chunksize=1000,
        method="multi",
    )

    fact_account_month.to_sql(
        name="fact_account_month",
        schema="Zuri",
        con=engine,
        if_exists="append",
        index=False,
        chunksize=1000,
        method="multi",
    )

    fact_cancellations.to_sql(
        name="fact_cancellations",
        schema="Zuri",
        con=engine,
        if_exists="append",
        index=False,
        chunksize=1000,
        method="multi",
    )

    fact_invoices.to_sql(
        name="fact_invoices",
        schema="Zuri",
        con=engine,
        if_exists="append",
        index=False,
        chunksize=1000,
        method="multi",
    )

    fact_marketing_monthly.to_sql(
        name="fact_marketing_monthly",
        schema="Zuri",
        con=engine,
        if_exists="append",
        index=False,
        chunksize=1000,
        method="multi",
    )

    fact_nps_surveys.to_sql(
        name="fact_nps_surveys",
        schema="Zuri",
        con=engine,
        if_exists="append",
        index=False,
        chunksize=1000,
        method="multi",
    )

    fact_support_tickets.to_sql(
        name="fact_support_tickets",
        schema="Zuri",
        con=engine,
        if_exists="append",
        index=False,
        chunksize=1000,
        method="multi",
    )

finally:
    engine.dispose()



