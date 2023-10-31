--What are the top 5 states by loans disbursed?
WITH top_rank AS (
	SELECT 
		sld.state
		, COUNT(slf.loan_id) AS disbursed_loans_count
		, dense_rank() OVER ( ORDER BY COUNT(slf.loan_id) DESC) AS country_rank
	FROM 
		{{ ref("stag_loan_fact") }} AS slf 
	JOIN
		{{ ref("stag_loan_dim") }} sld
	ON
		slf.loan_id = sld.loan_id 
	WHERE
		slf.is_disbursed = True
	GROUP BY
		sld.state
),
cities AS (
	SELECT 
		admin_name 
		, first_value(lat) AS latitude
		, first_value(lng) AS longitude
	FROM 
		{{ source("raw", "mx_cities") }} AS mc 
	GROUP BY
		admin_name
)
SELECT
	state
	, disbursed_loans_count
	, country_rank
	, mc.latitude 
	, mc.longitude 
FROM 
	top_rank
LEFT JOIN
	cities mc 
ON
	top_rank.state = mc.admin_name 
WHERE 
	country_rank <= 10