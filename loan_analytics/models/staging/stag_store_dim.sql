SELECT
    DISTINCT
    if(store_id == 0, -999, store_id) AS store_id
    , if(store_id == 0, 'No Store Info', store_name) AS store_name
FROM
    {{ source("raw", "raw_loan_data") }}
