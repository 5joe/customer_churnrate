CREATE TABLE dim_campaigns(
campaign_id VARCHAR(10) PRIMARY KEY,
campaign_name VARCHAR(100) NOT NULL,
channel VARCHAR(50) NOT NULL,
start_date date DEFAULT CURRENT_DATE,
end_date date NOT NULL,
target_segment VARCHAR(80) NOT NULL
);

CREATE TABLE dim_csm(
csm_id VARCHAR(10) PRIMARY KEY,
team VARCHAR(20) NOT NULL,
region_focus VARCHAR(20) NOT NULL,
hire_date DATE DEFAULT CURRENT_DATE,
departure_date DATE
);

CREATE TABLE dim_customers(
customer_id VARCHAR(20) PRIMARY KEY,
signup_date DATE DEFAULT CURRENT_DATE,
segment VARCHAR(20),
industry VARCHAR(20),
region VARCHAR(30),
country VARCHAR(80),
employee_count INT CHECK (employee_count >=0),
acquisition_channel VARCHAR(20),
campaign VARCHAR(20),
initial_plan VARCHAR(20),
initial_seats INT CHECK (initial_seats >=0),
initial_contract_type VARCHAR(40),
initial_billing_cycle VARCHAR(40),
payment_method VARCHAR(50),
signup_discount_pct DECIMAL(12,3),
initial_csm_id VARCHAR(20),
onboarding_completed BOOLEAN NOT NULL DEFAULT FALSE,
days_to_first_value INT CHECK (days_to_first_value >=0),
integrations_connected_90d INT,
current_status VARCHAR(20),
current_plan VARCHAR(20),
current_mrr_usd DECIMAL(12,2),
churn_count INT CHECK (churn_count >= 0),
reactivation_count INT CHECK (reactivation_count >=0),
last_churn_date DATE,
months_as_customer INT CHECK (months_as_customer >= 0),
lifetime_revenue_usd DECIMAL(12,2)
);

-- Handle the dim_date table --

CREATE TABLE dim_incidents (
incident_id VARCHAR(20) PRIMARY KEY,
incident_date DATE,
region_affected VARCHAR(20),
severity VARCHAR(10) NOT NULL,
duration INT CHECK (duration >=0),
root_cause VARCHAR(100) NOT NULL
);

CREATE TABLE dim_plans (
plan VARCHAR(20),
price_version INT,
effective_form DATE,
base_fee_usd DECIMAL(12,2),
included_seats INT CHECK(included_seats>=0),
per_extra_seat_usd DECIMAL(12,2),
max_seats_guidance INT CHECK(max_seats_guidance >=0)
);

CREATE TABLE fact_account_month (
month_start DATE NOT NULL DEFAULT CURRENT_DATE,
customer_id VARCHAR(20) NOT NULL,
status VARCHAR(10),
movement_type VARCHAR(10),
plan VARCHAR(20),
seats INT CHECK (seats >= 0),
contract_type VARCHAR(40),
billing_cycle VARCHAR(20),
csm_id VARCHAR(20) NOT NULL,
discount_pct DECIMAL(12, 3),
opening_mrr DECIMAL(12, 3),
new_mrr DECIMAL(12, 3),
reactivation_mrr DECIMAL(12, 3),
expansion_mrr DECIMAL(12, 3),
contraction_mrr DECIMAL(12, 3),
price_change_mrr DECIMAL(12, 3),
churned_mrr DECIMAL(12, 3),
closing_mrr DECIMAL(12, 3),
tenure_months INT CHECK(tenure_months >=0),
active_users INT CHECK(active_users >=0),
utilization_pct DECIMAL(12, 2),
logins INT CHECK(logins >= 0),
key_actions INT CHECK(key_actions >=0),
feature_adoption_pct DECIMAL(12,1),
health_score INT,
support_tickets INT CHECK(support_tickets >0),
CONSTRAINT fk_fact_customer
	FOREIGN KEY (customer_id)
	REFERENCES dim_customers(customer_id),
CONSTRAINT fk_fact_csm
	FOREIGN KEY (csm_id)
	REFERENCES dim_csm(csm_id)
);


CREATE TABLE fact_cancellations (
cancellation_id VARCHAR(20) PRIMARY KEY,
customer_id VARCHAR(20) NOT NULL,
request_date DATE,
churn_type VARCHAR(40) NOT NULL,
reason_primary VARCHAR(50),
reason_secondary VARCHAR(50),
competitor_named VARCHAR(100),
request_channel VARCHAR(40),
outcome VARCHAR(40),
save_offer VARCHAR(50),
discount_pct DECIMAL(12, 2) CHECK (discount_pct >=0),
mrr_at_risk_usd DECIMAL(12, 2) CHECK (mrr_at_risk_usd >=0),
exit_survey_completed BOOLEAN NOT NULL DEFAULT FALSE,
exit_survey_score INT,
CONSTRAINT fk_cancel_cus
	FOREIGN KEY (customer_id)
	REFERENCES dim_customers (customer_id)
);


CREATE TABLE fact_invoices (
invoice_id VARCHAR(30) PRIMARY KEY,
customer_id VARCHAR(30) NOT NULL,
invoice_date DATE,
due_date DATE,
amount_usd DECIMAL(12, 2),
billing_cycle VARCHAR(40),
payment_method VARCHAR(30),
status VARCHAR(30),
paid_date DATE,
days_to_pay INT CHECK (days_to_pay >=0),
retry_count INT CHECK (retry_count >=0)
CONSTRAINT fk_invoices_cust
	FOREIGN KEY (customer_id)
	REFERENCES dim_customers(customer_id)
);

CREATE TABLE fact_marketing_monthly (
month_start,
channel VARCHAR(20),
spend_usd DECIMAL(12, 2),
leads INT CHECK(leads >=0),
trial_signups INT CHECK (trial_signups>=0),
new_customers INT CHECK(new_customers >=0),
cac_usd DECIMAL(12, 2)
);

CREATE TABLE fact_nps_surveys (
survey_id VARCHAR(50) PRIMARY KEY,
customer_id VARCHAR(20) NOT NULL,
survey_date DATE,
nps_score INT CHECK(nps_score >= 0),
nps_category VARCHAR(30),
main_theme VARCHAR(30),
CONSTRAINT fk_nps_cust
	FOREIGN KEY (customer_id)
	REFERENCES dim_customers (customer_id)
);

CREATE TABLE fact_support_tickets (
ticket_id VARCHAR(50) PRIMARY KEY,
customer_id VARCHAR(20) NOT NULL,
created_at TIMESTAMPTZ,
category VARCHAR(80),
priority VARCHAR(10),
channel VARCHAR(20),
first_response_hours DECIMAL(12, 2),
resolution_hours DECIMAL(12, 1),
status VARCHAR(20),
escalated BOOLEAN DEFAULT FALSE,
reopened BOOLEAN DEFAULT FALSE,
csat_score INT,
CONSTRAINT fk_support_cust
	FOREIGN KEY (customer_id)
	REFERENCES dim_customers (customer_id)
);








