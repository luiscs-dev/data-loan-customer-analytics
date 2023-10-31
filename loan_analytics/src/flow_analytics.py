
import httpx
from prefect import flow, task
from prefect.task_runners import ConcurrentTaskRunner
import clickhouse_connect
from clickhouse_connect.driver.tools import insert_file
import sys
from query_config import tables_dict
from clickhouse_connect import common
from prefect.task_runners import SequentialTaskRunner
import os 
from prefect.blocks.notifications import SlackWebhook
from datetime import datetime
import json
from slack_message import send_message

RAW_FILES = ["loan_data", "repayment_data", "mx_cities"]
MODELS_STAGING = [
    "stag_customer_dim",
    "stag_loan_dim",
    "stag_store_dim",
]

@task(name="Notification")
def send_slack():
    metrics = [
        "loans_disbursed",
        "loans_risk_fraud_score",
        "loans_term_preference",
        "loans_top_states",
        "revenue_by_interests",
        "customer_merchant_preference",
        "customer_recurrence_history",
        "loans_recurrent"
    ]
    send_message("Analytics Dashboard", metrics)

@task(name="Create Table", task_run_name="{table}" )
def create_table(client, table):
    create_query = tables_dict.get(table)
    client.command(create_query)

@flow(name="Create Tables for Raw",task_runner=ConcurrentTaskRunner())
def build_tables_flow(client):
    for _file in RAW_FILES:
        table = f'raw_{_file}' if "mx" not in _file else _file
        client.command(f"DROP TABLE IF EXISTS {table}")
        create_table.submit(client, _file)

@task(name="Inser Data on Table", task_run_name="{table}" )
def insert_data(client, table):
    insert_file(
        client=client, 
        table=f'raw_{table}' if "mx" not in table else table, 
        file_path=f'data/{table}.csv',
        settings={
            "format_csv_null_representation": 'NA'
        }
    )

@flow(name="Load Data to ClickHouse", task_runner=ConcurrentTaskRunner())
def bulk_files_flow(client):
    for table in RAW_FILES:
        insert_data.submit(client, table)
       
@task(name="Run DBT Models", task_run_name="{schema} models")
def run_model(schema):
    os.system("echo $PWD")
    os.system(f"cd loan_analytics/src/ ; sh run_dbt_{schema}_models.sh ; cd -")
    
@flow(name="Running Models Staging", task_runner=SequentialTaskRunner())
def run_models_staging():
    for model in MODELS_STAGING:
        run_model.submit("staging", model)
        
@flow(name="Analytics", log_prints=True)
def analytics_flow():
    common.set_setting('autogenerate_session_id', False)  
    client = clickhouse_connect.get_client(
        host='localhost', 
        database='analytics_raw',
        username='default', 
        password=''
    )
    # Create Files
    build_tables_flow(client)
    # Load Data
    bulk_files_flow(client)
    # Staging models
    run_model("stag")
    # Staging models
    run_model("report")

    send_slack()
    
if __name__ == "__main__":
    analytics_flow.serve(name="analytics_flow")