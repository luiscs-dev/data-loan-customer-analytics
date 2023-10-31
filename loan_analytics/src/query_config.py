raw_repayment_data = """
CREATE TABLE IF NOT EXISTS raw_repayment_data
(
    loan_id String, 
    installment_id String,
    installment_number UInt8,
    installment_duedate Date32,
    repaid_date Nullable(Date32),
    capital_due Float64,
    capital_paid Float64,
    interests_paid Float64
)
ENGINE = MergeTree()
PRIMARY KEY (installment_id)
"""

raw_loan_data = """
CREATE TABLE IF NOT EXISTS raw_loan_data
(
	customer_id String, 
	merchant_id UInt64, 
	loan_id String, 
	application_date DateTime64, 
	currency String,
	transaction_fee Float32, 
	merchant_status String, 
	store_id Int64, 
	term UInt8, 
	risk_score Float32,
	disbursed_date Nullable(Date32), 
	loanamount Float64, 
	paid_date Nullable(Date32), 
	city String, 
	state String, 
	channel String,
	is_disbursed Bool, 
	first_vintage_pay Date32, 
	full_name String, 
	age UInt8, 
	gender String,
	tel_number UInt8, 
	email String, 
	merchant_name String, 
	merchant_size String, 
	store_name String,
	fraud_score Float32
)
ENGINE = MergeTree()
PRIMARY KEY (loan_id)
"""

mx_cities = """
CREATE TABLE IF NOT EXISTS mx_cities
(
    `city` String,
    `lat` Float32,
    `lng` Float32,
    `country` String,
    `iso2` String,
    `admin_name` String,
    `capital` String,
    `population` Int32,
    `population_proper` Int32
)
ENGINE = Log;
"""


tables_dict = {
    "repayment_data": raw_repayment_data,
    "loan_data": raw_loan_data,
    "mx_cities": mx_cities
}