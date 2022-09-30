from airflow.settings import AIRFLOW_HOME
import pendulum
from airflow.utils.task_group import TaskGroup
from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.operators.dummy import DummyOperator

# Define DAG
yesterday = pendulum.today(tz="Asia/Jakarta").add(days=-1)

dag_dir = "/opt/airflow"

default_args = {
        'depends_on_past': False,
        'email_on_failure': False,
        'email_on_retry': False,
        'start_date': yesterday,
        'end_date': None
    }

dag = DAG(  'task1',
            default_args=default_args,
            tags=['task1', 'eka'],
            schedule_interval='0 7 * * *',
            catchup=False,
            concurrency=5)

# Define Arguments
postgres_args = "{} {} {} {} {} {}".format(
    "postgres","postgres","passwd","'127.0.0.1'","5432","chinook"
)
postgres_tables = "['dimDate','dimCustomer','dimTrack','dimInvoice','factInvoiceLine']"

mysql_args = "{} {} {} {} {} {}".format(
    "mysql","root","passwd","'127.0.0.1'","3306","hr"
)
mysql_tables = "['countries','departments','employees','job_history','jobs','locations','regions']"

# Define Function
def run_py(folder, py_file, sql_file='', args=''):
    op = BashOperator(
        task_id=py_file + "_" + sql_file.split('.')[0] + "_" + args.split(' ')[0],
        bash_command=f'python3 {AIRFLOW_HOME}/{folder}/{py_file}.py {sql_file} {args}',
        dag=dag
    )

    return op

with TaskGroup(group_id='ddl', prefix_group_id=False, dag=dag) as ddl:
    run_py("data", "ddl_postgres")
    run_py("data", "ddl_mysql")

with TaskGroup(group_id='ingestion', prefix_group_id=False, dag=dag) as ing:
    dim_pg = run_py("queries","run_query","dim_postgres.sql",postgres_args)
    fact_pg = run_py("queries","run_query","fact_postgres.sql",postgres_args)
    load_pg = run_py("queries","load_dwh",args=postgres_args+" "+postgres_tables)

    load_mysql = run_py("queries","load_dwh",args=mysql_args+" "+mysql_tables)

    dim_pg >> fact_pg >> load_pg

start = DummyOperator(task_id='start', dag=dag)
end = DummyOperator(task_id='end', dag=dag)

start >> ddl >> ing >> end