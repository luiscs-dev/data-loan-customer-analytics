SELECT
    installment_id
    , loan_id
    , repaid_date
    , capital_due
    , capital_paid
    , interests_paid
FROM
    {{ source("raw", "raw_repayment_data") }}
