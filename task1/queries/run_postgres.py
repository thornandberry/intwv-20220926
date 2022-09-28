import psycopg2
import sys


def run_sql():

    dag_dir = "/opt/airflow"

    # Create star schema
    query1 = open(f'{dag_dir}/queries/{filename}').read()
    print("Reading query success")

    conn_source = psycopg2.connect(user='postgres', password='passwd', host='127.0.0.1', port= '5432')
    print("Connect db source success")

    cur_src = conn_source.cursor()
    cur_src.executescript(query1)
    
    print("Query executed successfully in source")


if __name__ == '__main__':
    filename = sys.argv[1]

    run_sql()