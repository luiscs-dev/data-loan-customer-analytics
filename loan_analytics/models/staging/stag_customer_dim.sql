SELECT
    DISTINCT
    customer_id
    , full_name
    , age
    , gender
    , tel_number AS telephone_number
    , email
    , first_vintage_pay AS first_loan_date
FROM
    {{ source("raw", "raw_loan_data") }}