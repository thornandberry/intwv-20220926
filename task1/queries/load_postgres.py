import psycopg2
import sqlite3
import pandas as pd

dag_dir = "/opt/airflow"

def pd_read_load(sql, conn_src, conn_tgt, tblnm_tgt):
    pd.read_sql_query(sql, conn_src).to_sql(tblnm_tgt, conn_tgt, if_exists="replace", index=False)

conn_source = psycopg2.connect(user='postgres', password='passwd', host='127.0.0.1', port= '5432')
conn_dwh = sqlite3.connect(f'{dag_dir}/data/dwh_chinook.db')

tables = ["dimDate", "dimAlbum"]

for table in tables:
    pd_read_load(f"SELECT * FROM {table}", conn_source, conn_dwh, table)

conn_source.close()
conn_dwh.close()