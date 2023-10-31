--Do the customers prefer to obtain a loan with a specific term (tenure) or it is
--indistinct?
WITH term_preference AS(	
	SELECT
		slf.loan_term
		, COUNT(loan_id) AS loan_term_count
		, DENSE_RANK() OVER( ORDER BY COUNT(loan_id) DESC) AS term_preference_rank
	FROM
	 {{ ref("stag_loan_fact") }} AS slf 
	GROUP BY 
		slf.loan_term 
)
SELECT
	loan_term
	,multiIf(
		loan_term = 0, 'Instant Payment', 
		CONCAT('Term ', toString(loan_term)) 
	)
	, loan_term_count
	, term_preference_rank
FROM
	term_preference