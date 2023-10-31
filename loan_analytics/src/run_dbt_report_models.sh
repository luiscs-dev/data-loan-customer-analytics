#!/usr/bin/env bash

DBT_ENV=~/.zshrc  

source $DBT_ENV

pyenv activate analytics_env

echo "Current path"
echo $PWD
cd ../
$
dbt run --select models/report/loans_disbursed.sql
dbt run --select models/report/loans_risk_fraud_score.sql
dbt run --select models/report/loans_term_preference.sql
dbt run --select models/report/loans_top_states.sql
dbt run --select models/report/revenue_by_interests.sql
dbt run --select models/report/customer_merchant_preference.sql
dbt run --select models/report/customer_recurrence_history.sql
dbt run --select models/report/loans_recurrent.sql

cd -
pyenv deactivate