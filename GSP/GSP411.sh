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
curl -LO raw.githubusercontent.com/gcpsolution99/GCP-solution/refs/heads/main/GSP411.sh
curl -LO raw.githubusercontent.com/gcpsolution99/GCP-solution/refs/heads/main/products.csv
bq mk ecommerce
gsutil mb gs://$DEVSHELL_PROJECT_ID/
gsutil cp products.csv gs://$DEVSHELL_PROJECT_ID/
gsutil cp gsp411.csv gs://$DEVSHELL_PROJECT_ID/
bq --location=US load --source_format=CSV --autodetect --skip_leading_rows=1 ecommerce.products gs://$DEVSHELL_PROJECT_ID/products.csv
bq --location=US load --source_format=CSV --autodetect --skip_leading_rows=1 ecommerce.products gs://data-insights-course/exports/products.csv
bq query --use_legacy_sql=false \
"
#standardSQL
SELECT
  *,
  SAFE_DIVIDE(orderedQuantity,stockLevel) AS ratio
FROM
  ecommerce.products
WHERE
# include products that have been ordered and
# are 80% through their inventory
orderedQuantity > 0
AND SAFE_DIVIDE(orderedQuantity,stockLevel) >= .8
ORDER BY
  restockingLeadTime DESC
"
cat > external_table_definition.json <<EOF
{
  "sourceFormat": "GOOGLE_SHEETS",
  "sourceUris": ["https://docs.google.com/spreadsheets/d/1Pyr2ifVgC82eCDNxBKgEXc33fkzMTPa2/edit?usp=sharing"],
  "schema": {
    "fields": [
      {"name": "column1", "type": "STRING"},
      {"name": "column2", "type": "INTEGER"},
      {"name": "column3", "type": "FLOAT"}
    ]
  }
}
EOF
bq mk --external_table_definition=external_table_definition.json ecommerce.products_comments
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
