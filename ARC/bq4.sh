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

bq load --source_format=CSV --autodetect products.products_information gs://$PROJECT_ID-bucket/*.csv

bq query --use_legacy_sql=false 'CREATE SEARCH INDEX products_info_search_index ON products.products_information (ALL COLUMNS);'

bq query --use_legacy_sql=false 'SELECT * FROM products.products_information WHERE SEARCH(products_information, "22 oz Water Bottle");'
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
