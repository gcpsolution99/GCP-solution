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
bq query --use_legacy_sql=false '
CREATE OR REPLACE TABLE `qwiklabs-gcp-02-a5a4ed789a04.ecommerce.backup_orders` AS
SELECT *
FROM `qwiklabs-gcp-02-a5a4ed789a04.ecommerce.customer_orders`;
'

bq query --use_legacy_sql=false --schedule "every 1 month" --display_name "Monthly Backup of Customer Data" 
--description "This query backs up customer_orders to backup_orders every month" \
'CREATE OR REPLACE TABLE `qwiklabs-gcp-02-a5a4ed789a04.ecommerce.backup_orders` AS
SELECT *
FROM `qwiklabs-gcp-02-a5a4ed789a04.ecommerce.customer_orders`;'
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
