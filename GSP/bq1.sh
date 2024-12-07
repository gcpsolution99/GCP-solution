#!/bin/bash

YELLOW='\033[0;33m'
NC='\033[0m' 

pattern=(
"**********************************************************"
"**                 S U B S C R I B E  TO                **"
"**                 ABHI ARCADE SOLUTION                 **"
"**                                                      **"
"**********************************************************"
)

for line in "${pattern[@]}"
do
    echo -e "${YELLOW}${line}${NC}"
done
export PROJECT_ID=$(gcloud config get-value project)
export BUCKET=$(gcloud storage buckets list --format="value(name)" | head -n 1)
echo '[
  {
    "name": "employee_id",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "device_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "username",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "department",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "office",
    "type": "STRING",
    "mode": "NULLABLE"
  }
]' > schema.json
bq mk work_day
bq mk --table --schema=schema.json $PROJECT_ID:work_day.employee
bq load --source_format=CSV --skip_leading_rows=1 --schema=schema.json $PROJECT_ID:work_day.employee gs://$BUCKET/employees.csv
pattern=(
"**********************************************************"
"**                 S U B S C R I B E  TO                **"
"**                 ABHI ARCADE SOLUTION                 **"
"**                                                      **"
"**********************************************************"
)

for line in "${pattern[@]}"
do
    echo -e "${YELLOW}${line}${NC}"
done
