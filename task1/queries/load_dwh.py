import psycopg2
import mysql.connector
import sqlite3
import pandas as pd
import sys
import ast
from airflow.settings import AIRFLOW_HOME

def pd_read_load(sql, conn_src, conn_tgt, tblnm_tgt):
    pd.read_sql_query(sql, conn_src).to_sql(tblnm_tgt, conn_tgt, if_exists="replace", index=False)

def load():

    if db_type == 'postgres':
        conn_source = psycopg2.connect(user=user, password=password, host=host, port=port, database=database)
        conn_source.autocommit = True
        print("Connect db source success")
        conn_dwh = sqlite3.connect(f'{AIRFLOW_HOME}/data/dwh_chinook.db')
        print("Connect db target success")
    else:
        conn_source = mysql.connector.connect(user=user, password=password, host=host, port=port, database=database)
        print("Connect db source success")
        conn_dwh = sqlite3.connect(f'{AIRFLOW_HOME}/data/dwh_hr.db')
        print("Connect db target success")

    for table in ast.literal_eval(tables):
        pd_read_load(f"SELECT * FROM {table}", conn_source, conn_dwh, table)

    conn_source.close()
    conn_dwh.close()

if __name__ == '__main__':
    db_type = sys.argv[1]
    user = sys.argv[2]
    password = sys.argv[3]
    host = sys.argv[4]
    port = sys.argv[5]
    database = sys.argv[6]
    tables = sys.argv[7]

    load()