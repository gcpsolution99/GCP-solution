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
bq load --source_format=CSV \
  --skip_leading_rows=1 \
  --autodetect \
  '$project_id:customer_details.customers' \
  gs://$project_id-bucket/customers.csv



bq query --use_legacy_sql=false \
  'CREATE OR REPLACE TABLE `$project_id.customer_details.male_customers` AS
   SELECT customer_id, gender, other_columns
   FROM `$project_id.customer_details.customers`
   WHERE gender = "Male";'



bq extract \
  --destination_format=CSV \
  --field_delimiter=',' \
  --print_header=true \
  '$project_id:customer_details.male_customers' \
  gs://$project_id-bucket/exported_male_customers.csv
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
