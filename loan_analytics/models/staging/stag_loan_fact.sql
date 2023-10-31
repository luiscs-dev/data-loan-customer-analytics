SELECT
    loan_id
    , customer_id
    , merchant_id
    , if(store_id == 0, -999, store_id) AS store_id
    , toDate(application_date) AS application_date
    , term AS loan_term
    , is_disbursed
    , loanamount as loan_amount
    , transaction_fee
    , risk_score
    , fraud_score
FROM
    {{ source("raw", "raw_loan_data") }}
