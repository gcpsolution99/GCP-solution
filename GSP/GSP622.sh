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
bq query --use_legacy_sql=false \
"
SELECT * FROM \`ctg-storage.bigquery_billing_export.gcp_billing_export_v1_01150A_B8F62B_47D999\`
"
bq query --use_legacy_sql=false \
"
SELECT service.description FROM \`ctg-storage.bigquery_billing_export.gcp_billing_export_v1_01150A_B8F62B_47D999\` GROUP BY service.description
"
bq query --use_legacy_sql=false \
"
SELECT service.description, COUNT(*) AS num FROM \`ctg-storage.bigquery_billing_export.gcp_billing_export_v1_01150A_B8F62B_47D999\` GROUP BY service.description
"
bq query --use_legacy_sql=false \
"
SELECT location.region FROM \`ctg-storage.bigquery_billing_export.gcp_billing_export_v1_01150A_B8F62B_47D999\` GROUP BY location.region
"
bq query --use_legacy_sql=false \
"
SELECT location.region, COUNT(*) AS num FROM \`ctg-storage.bigquery_billing_export.gcp_billing_export_v1_01150A_B8F62B_47D999\` GROUP BY location.region
"
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
