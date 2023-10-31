--Do the customers prefer to get a loan to buy things from any particular
--merchant?

WITH merchants AS (	
	SELECT
		merchant_id
		, COUNT(loan_id) AS loan_applications_count
		, DENSE_RANK() OVER( ORDER BY COUNT(loan_id) DESC) AS merchant_popularity
	FROM
		{{ ref("stag_loan_fact") }}  AS slf 
	GROUP BY 
		merchant_id 
)
SELECT 
	smd.merchant_name
	, m.loan_applications_count
	, smd.merchant_size
	, smd.merchant_status
	, merchant_popularity
FROM
	merchants AS m
JOIN
	{{ ref("stag_merchant_dim") }}  AS smd 
ON
	m.merchant_id = smd.merchant_id 
WHERE 
	m.merchant_popularity <= 20
