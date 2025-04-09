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
export REGION="${ZONE%-*}"
export KEY_1=domain_type
export VALUE_1=source_data

gcloud alpha dataplex lakes create customer-lake \
    --display-name="Customer-Lake" \
    --location=$REGION \
    --labels="key_1=$KEY_1,value_1=$VALUE_1"

gcloud dataplex zones create public-zone \
    --lake=customer-lake \
    --location=$REGION \
    --type=RAW \
    --resource-location-type=SINGLE_REGION \
    --display-name="Public-Zone"

gcloud dataplex environments create dataplex-lake-env \
    --project=$DEVSHELL_PROJECT_ID \
    --location=$REGION \
    --lake=customer-lake \
    --os-image-version=1.0 \
    --compute-node-count 3 \
    --compute-max-node-count 3

gcloud dataplex assets create customer-raw-data \
    --location=$REGION \
    --lake=customer-lake \
    --zone=public-zone \
    --resource-type=STORAGE_BUCKET \
    --resource-name=projects/$DEVSHELL_PROJECT_ID/buckets/$DEVSHELL_PROJECT_ID-customer-bucket \
    --discovery-enabled \
    --display-name="Customer Raw Data"

gcloud dataplex assets create customer-reference-data \
    --location=$REGION \
    --lake=customer-lake \
    --zone=public-zone \
    --resource-type=BIGQUERY_DATASET \
    --resource-name=projects/$DEVSHELL_PROJECT_ID/datasets/customer_reference_data \
    --display-name="Customer Reference Data"

gcloud data-catalog tag-templates create customer_data_tag_template \
    --location=$REGION \
    --display-name="Customer Data Tag Template" \
    --field=id=data_owner,display-name="Data Owner",type=string,required=TRUE \
    --field=id=pii_data,display-name="PII Data",type='enum(Yes|No)',required=TRUE

echo "OPEN LINK: https://console.cloud.google.com/projectselector2/dataplex/groups"
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
