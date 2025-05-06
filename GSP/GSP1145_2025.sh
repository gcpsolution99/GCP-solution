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
gcloud auth list

export ZONE=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-zone])")

export REGION=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-region])")

export PROJECT_ID=$(gcloud config get-value project)

gcloud config set compute/zone "$ZONE"

gcloud config set compute/region "$REGION"

export PROJECT_ID=$DEVSHELL_PROJECT_ID

gcloud services enable dataplex.googleapis.com datacatalog.googleapis.com --project=$DEVSHELL_PROJECT_ID

sleep 10

gcloud dataplex lakes create orders-lake --location=$REGION --display-name="Orders Lake"

gcloud dataplex zones create customer-curated-zone --location=$REGION --display-name="Customer Curated Zone" --lake=orders-lake --resource-location-type=SINGLE_REGION --type=CURATED --discovery-enabled --discovery-schedule="0 * * * *"

gcloud dataplex assets create customer-details-dataset --location=$REGION --display-name="Customer Details Dataset" --lake=orders-lake --zone=customer-curated-zone --resource-type=BIGQUERY_DATASET --resource-name=projects/$DEVSHELL_PROJECT_ID/datasets/customers --discovery-enabled

gcloud data-catalog tag-templates create protected_data_template --location=$REGION --display-name="Protected Data Template" --field=id=protected_data_flag,display-name="Protected Data Flag",type='enum(YES|NO)'
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
