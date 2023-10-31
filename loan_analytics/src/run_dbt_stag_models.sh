#!/usr/bin/env bash

DBT_ENV=~/.zshrc  

source $DBT_ENV

pyenv activate analytics_env

echo "Current path"
echo $PWD
cd ../
$
#dbt run --select models/${1}/${2}.sql
dbt run --select models/staging/stag_customer_dim.sql
dbt run --select models/staging/stag_date_dim.sql
dbt run --select models/staging/stag_installment_dim.sql
dbt run --select models/staging/stag_loan_dim.sql
dbt run --select models/staging/stag_merchant_dim.sql
dbt run --select models/staging/stag_store_dim.sql
dbt run --select models/staging/stag_loan_fact.sql
dbt run --select models/staging/stag_installment_fact.sql

cd -
pyenv deactivate