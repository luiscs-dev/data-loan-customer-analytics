SELECT
    DISTINCT
    merchant_id
    , merchant_name
    , merchant_size
    , merchant_status
FROM
    {{ source("raw", "raw_loan_data") }}
