-- zero-ticket months would be rejected by the original > 0 check
ALTER TABLE fact_account_month DROP CONSTRAINT fact_account_month_support_tickets_check;
ALTER TABLE fact_account_month ADD CHECK (support_tickets >= 0);

-- fix the typo (check your CSV header says effective_from)
ALTER TABLE dim_plans RENAME COLUMN effective_form TO effective_from;

-- widen the short columns so longer values don't fail
ALTER TABLE fact_account_month ALTER COLUMN movement_type TYPE VARCHAR(30);
ALTER TABLE fact_account_month ALTER COLUMN status TYPE VARCHAR(30);

ALTER TABLE "Zuri".dim_customers RENAME COLUMN campaign TO campaign_id;