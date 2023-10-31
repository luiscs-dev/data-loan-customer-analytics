{% macro generate_dates_dimension(start_date, end_date) %}

WITH dates AS (
     WITH
    toStartOfDay(toDate('{{ start_date }}')) AS start,
    toStartOfDay(toDate('{{ end_date }}')) AS end
    SELECT 
        arrayJoin( 
            arrayMap( 
                x -> toDateTime(x),
                range( 
                    toUInt32(toStartOfDay(toDate(start))),
                    toUInt32(toStartOfDay(toDate(end))), 
                    86400
                ) 
            ) 
        ) 
        AS date_key
)
SELECT 
    toDate(date_key) as date_key
    , toYear(date_key) AS year
    , toQuarter(date_key) AS quarter
    , toMonth(date_key) AS month
    , toWeek(date_key) AS week
    , toDayOfYear(date_key) AS day_of_year
    , toDayOfMonth(date_key) AS day_of_month
    , toDayOfWeek(date_key) AS day_of_week
FROM 
  dates
WHERE
  dates.date_key <= DATEADD(MONTH, 12, CURRENT_DATE())

{% endmacro %}