import psycopg2
import mysql
import sys
from airflow.settings import AIRFLOW_HOME

def run_sql():

    query = open(f'{AIRFLOW_HOME}/queries/{filename}').read()
    print("Reading query success")

    if db_type == 'postgres':
        conn = psycopg2.connect(user=user, password=password, host=host, port=port, database=database)
        conn.autocommit = True
        print("Connect db source success")
    else:
        conn = mysql.connector.connect(user=user, password=password, host=host, port=port, database=database)
        print("Connect db source success")

    cur_src = conn.cursor()
    cur_src.execute(query)

    conn.close()
    
    print("Query executed successfully in source")


if __name__ == '__main__':
    filename = sys.argv[1]
    db_type = sys.argv[2]
    user = sys.argv[3]
    password = sys.argv[4]
    host = sys.argv[5]
    port = sys.argv[6]
    database = sys.argv[7]

    run_sql()