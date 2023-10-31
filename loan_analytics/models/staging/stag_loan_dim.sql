SELECT
    DISTINCT
    loan_id
    , currency
    , if(city = '', 'Sin Ciudad', city) AS city 
    , if(state = '', 'Sin Estado', state) AS state 
    , channel
    , disbursed_date
    , paid_date
FROM
    {{ source("raw", "raw_loan_data") }}
