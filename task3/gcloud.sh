#!/bin/bash

# Create GCS Bucket
gsutil mb -p my-sooltan-intvw-20220926 -l asia-southeast2 gs://task3-20220926/

# Upload files to GCS
export BUCKET_NAME=gs://task3-20220926
gsutil cp data/2021-10-10/*.csv $BUCKET_NAME/2021-10-10
gsutil cp data/2021-10-11/*.csv $BUCKET_NAME/2021-10-11

# Create BigQuery tables
gcloud projects add-iam-policy-binding my-sooltan-intvw-20220926 --member group:ekaapramudita73@gmail.com --role roles/bigquery.admin

bq.cmd mk task3

bq.cmd load --autodetect --source_format=CSV task3.inventory $BUCKET_NAME/2021-10-10/2021-10-10-inventory.csv
bq.cmd load --autodetect --source_format=CSV task3.products $BUCKET_NAME/2021-10-10/2021-10-10-products.csv
bq.cmd load --autodetect --source_format=CSV task3.sales $BUCKET_NAME/2021-10-10/2021-10-10-sales.csv
bq.cmd load --autodetect --source_format=CSV task3.stores $BUCKET_NAME/2021-10-10/2021-10-10-stores.csv

bq.cmd load --autodetect --source_format=CSV task3.inventory_new $BUCKET_NAME/2021-10-11/2021-10-11-inventory.csv
bq.cmd load --autodetect --source_format=CSV task3.products_new $BUCKET_NAME/2021-10-11/2021-10-11-products.csv
bq.cmd load --source_format=CSV --skip_leading_rows=1 task3.sales_new $BUCKET_NAME/2021-10-11/2021-10-11-sales.csv \
sale_id:INTEGER,date:STRING,store_id:INTEGER,product_id:INTEGER,units:FLOAT
bq.cmd load --autodetect --source_format=CSV task3.stores_new $BUCKET_NAME/2021-10-11/2021-10-11-stores.csv