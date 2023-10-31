--A loan is said to be recurrent if, at the disbursement date, the customer has paid any
--loan in its totality or has paid 3 or more installments of its first loan disbursed.
--(TRUE, FALSE)

WITH recurrency AS (
	SELECT  
		crh.loan_id AS loan_id
		, crh.full_name AS customer_name
		, crh.disbursed_date AS disbursed_date
		, countIf(crh.paid_date <= crh.disbursed_date) AS loans_paid_count
		, countIf(crh.first_loan_date  <= sif.repaid_date) AS installment_paid_count
	FROM
		{{ ref("customer_recurrence_history") }} AS crh
	JOIN
		{{ ref("stag_installment_fact") }} AS sif 
	ON
		crh.loan_id = sif.loan_id 
	JOIN 
		{{ ref("stag_installment_dim") }} AS sid 
	ON
		sif.installment_id = sid.installment_id 
	GROUP BY
		crh.loan_id
		, crh.full_name
		, crh.disbursed_date
)
SELECT 
	loan_id
	, customer_name 
	, disbursed_date
	, loans_paid_count
	, installment_paid_count
	, IF(loans_paid_count > 0 OR installment_paid_count >= 3, True, False) AS is_recurrent
FROM
	recurrency r