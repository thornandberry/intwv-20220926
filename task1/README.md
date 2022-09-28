# TASK 1

## Setup Virtual Environment
### Prerequisite
- WSL
- Python 3.7 or above
### Command
Run this in WSL

```
sudo pip install virtualenv
virtualenv -p python3 venv
source venv/bin/activate
```

## Setup Airflow
1. Run this in WSL to install Airflow in your desired directory.
```
export AIRFLOW_HOME=$(pwd)
AIRFLOW_VERSION=2.3.4
PYTHON_VERSION="$(python --version | cut -d " " -f 2 | cut -d "." -f 1-2)"
CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt"
pip install "apache-airflow==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"
```
2. Initialize db
``` 
airflow db init
```
3. Create user account
```
airflow users create \
    --username admin \
    --firstname Peter \
    --lastname Parker \
    --role Admin \
    --email spiderman@superhero.org
```
Then input password.
4. Run airflow
```
airflow webserver --port 8080
```
Open in different terminal
```
airflow scheduler
```
5. Your airflow is ready on `http://localhost:8080/`. Login with your created credential when creating user.

## Execute Data Definition Language (DDL) to Create Tables
Run these python scripts to generate tables
```
python 
```