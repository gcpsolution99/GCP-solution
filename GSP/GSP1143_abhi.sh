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
export REGION=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-region])")
gcloud services enable dataplex.googleapis.com
sleep 20
gcloud alpha dataplex lakes create sensors --location=$REGION
gcloud alpha dataplex zones create temperature-raw-data --location=$REGION --lake=sensors --resource-location-type=SINGLE_REGION --type=RAW
gsutil mb -l $REGION gs://$DEVSHELL_PROJECT_ID
gcloud dataplex assets create measurements --location=$REGION --lake=sensors --zone=temperature-raw-data --resource-type=STORAGE_BUCKET --resource-name=projects/$DEVSHELL_PROJECT_ID/buckets/$DEVSHELL_PROJECT_ID
gcloud dataplex assets delete measurements --zone=temperature-raw-data --location=$REGION --lake=sensors --quiet
gcloud dataplex zones delete temperature-raw-data --lake=sensors --location=$REGION --quiet
gcloud dataplex lakes delete sensors --location=$REGION --quiet
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
