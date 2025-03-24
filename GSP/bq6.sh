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
bq mk ecommerce

bq mk --table ecommerce.customer_orders \
    customer_orders_id:INTEGER,device_id:STRING,username:STRING,department:STRING,office:STRING

bq mk --table work_day.backup_orders \
    backup_orders_id:INTEGER,device_id:STRING,username:STRING,department:STRING,office:STRING
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
