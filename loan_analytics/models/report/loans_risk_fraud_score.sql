--Does the risk score is helpful for deciding what application is disbursed or
--not? What about the fraud score?
SELECT 
	multiIf(
		is_disbursed = True, 'Application Disbursed', 
		is_disbursed = False, 'Application Not Disbursed',
		''
	) AS application_status
	, COUNT(loan_id) AS application_count
	, MIN(risk_score) AS min_risk_score
	, AVG(risk_score) AS avg_risk_score
	, MAX(risk_score) AS max_risk_score
	, MIN(fraud_score) AS min_fraud_score
	, AVG(fraud_score) AS avg_fraud_score
	, MAX(fraud_score) AS max_fraud_score
FROM 
	{{ ref("stag_loan_fact") }} AS slf 
GROUP BY
	is_disbursed