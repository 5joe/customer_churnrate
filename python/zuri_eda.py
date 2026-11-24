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

engine = create_engine(f"postgresql+psycopy2://{user}:{password}@{host}:{port}/{dbname}")

dim_campaigns=pd.read_csv("../data/dim_campaigns.csv")
dim_csm=pd.read_csv("../data/dim_csm.csv")
dim_customers=pd.read_csv("../data/dim_customers.csv")
dim_date=pd.read_csv("../data/dim_date.csv")
dim_incidents=pd.read_csv("../data/dim_incidents.csv")
dim_plans=pd.read_csv("../data/dim_plans.csv")
fact_account_month=pd.read_csv("../data/fact_account_month.csv")
fact_cancellations=pd.read_csv("../data/fact_cancellations.csv")
fact_invoices=pd.read_csv("../data/fact_invoices.csv")
fact_marketing_monthly=pd.read_csv("../data/fact_marketing_monthly.csv")
fact_nps_surveys=pd.read_csv("../data/fact_nps_surveys.csv")
fact_support_tickets=pd.read_csv("../data/fact_support_tickets.csv")


