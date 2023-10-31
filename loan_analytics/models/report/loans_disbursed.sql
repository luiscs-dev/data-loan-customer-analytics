--How many loans have been disbursed in December 2021?
WITH loan_disbursed_group AS (
	SELECT 
		sdd.`year`
		, sdd.`month`
		, countIf(1, slf.is_disbursed) as loans_disbursed
	FROM
	    {{ ref("stag_loan_fact") }} AS slf 
    RIGHT JOIN
	    {{ ref("stag_date_dim") }} AS sdd
	ON
		slf.application_date = sdd.date_key 
	WHERE
		sdd.`year` IN ('2020', '2021', '2022', '2023')
	GROUP BY 
		sdd.`year`
		, sdd.`month`
	ORDER BY 
		sdd.`year` 
		, sdd.`month`
)
SELECT 
	year
	, multiIf(
		`month` = 1, 'January', 
		`month` = 2, 'February',
		`month` = 3, 'March',
		`month` = 4, 'April',
		`month` = 5, 'May',
		`month` = 6, 'June',
		`month` = 7, 'July',
		`month` = 8, 'August',
		`month` = 9, 'September',
		`month` = 10, 'October',
		`month` = 11, 'November',
		`month` = 12, 'December',
		''
	) as month_name
	, loans_disbursed
FROM
	loan_disbursed_group
