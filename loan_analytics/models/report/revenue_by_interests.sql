--How much Revenue by Interest did the company get by week?
SELECT 
	sdd.`year`
	, sdd.`week` 
	, SUM(interests_paid) as revenue_by_interest 
FROM 
	{{ ref("stag_installment_fact") }} AS  sif 
RIGHT JOIN
	{{ ref("stag_date_dim") }} AS sdd 
ON
	sif.repaid_date = sdd.date_key 
GROUP BY
	sdd.`year`
	, sdd.`week` 
ORDER BY
	sdd.`year`
	, sdd.`week`