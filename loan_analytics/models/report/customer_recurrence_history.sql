--The number of loans disbursed in the client&#39;s history at the disbursement date,
--including the one being disbursed. (1,2,3,4,...., n)
WITH customer_loans_history AS (
	SELECT 
		slf.customer_id
		, slf.loan_id 
		, sld.disbursed_date 
		, sld.paid_date 
		, DENSE_RANK() OVER( 
			PARTITION BY slf.customer_id 
			ORDER BY sld.disbursed_date desc
		) AS loan_history_order
		, COUNT() OVER( 
			PARTITION BY slf.customer_id 
		) AS customer_history_order
		, (customer_history_order - loan_history_order) + 1 AS loans_disbursed_count
	FROM 
		{{ ref("stag_loan_fact") }} slf 
	JOIN
		{{ ref("stag_loan_dim") }} sld 
	ON
		slf.loan_id = sld.loan_id 
	WHERE 
		slf.is_disbursed = True
	ORDER BY
		slf.customer_id
		, loan_history_order asc
)
SELECT 
	scd.full_name 
	, loan_id
	, scd.age 
	, scd.gender 
	, first_loan_date
	, clh.disbursed_date
	, clh.paid_date
	, clh.loans_disbursed_count
FROM 
	customer_loans_history AS clh
JOIN
	{{ ref("stag_customer_dim") }} scd 
ON
	clh.customer_id = scd.customer_id 
