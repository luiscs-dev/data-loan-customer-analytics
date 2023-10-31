SELECT
    DISTINCT
    installment_id
    , installment_number
    , installment_duedate
FROM
    {{ source("raw", "raw_repayment_data") }}
