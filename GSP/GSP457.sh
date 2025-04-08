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
gcloud services enable healthcare.googleapis.com --project=$PROJECT_ID

sleep 10

gcloud pubsub topics create $TOPIC --project=$PROJECT_ID

bq --location=$LOCATION mk --dataset --description "HCAPI dataset" $PROJECT_ID:$DATASET_ID

bq --location=$LOCATION mk --dataset --description "HCAPI dataset de-id" $PROJECT_ID:de_id

gcloud healthcare datasets create $DATASET_ID \
  --location=$LOCATION \
  --project=$PROJECT_ID

sleep 15

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:service-$PROJECT_NUMBER@gcp-sa-healthcare.iam.gserviceaccount.com" \
  --role="roles/bigquery.dataEditor"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:service-$PROJECT_NUMBER@gcp-sa-healthcare.iam.gserviceaccount.com" \
  --role="roles/bigquery.jobUser"

gcloud healthcare fhir-stores create $FHIR_STORE_ID \
  --dataset=$DATASET_ID \
  --location=$LOCATION \
  --version=R4 \
  --project=$PROJECT_ID

gcloud healthcare fhir-stores update $FHIR_STORE_ID \
  --dataset=$DATASET_ID \
  --location=$LOCATION \
  --pubsub-topic=projects/$PROJECT_ID/topics/$TOPIC \
  --project=$PROJECT_ID

gcloud healthcare fhir-stores create de_id \
  --dataset=$DATASET_ID \
  --location=$LOCATION \
  --version=R4 \
  --project=$PROJECT_ID

gcloud healthcare fhir-stores import gcs $FHIR_STORE_ID \
  --dataset=$DATASET_ID \
  --location=$LOCATION \
  --gcs-uri=gs://spls/gsp457/fhir_devdays_gcp/fhir1/* \
  --content-structure=BUNDLE_PRETTY \
  --project=$PROJECT_ID

gcloud healthcare fhir-stores export bq $FHIR_STORE_ID \
  --dataset=$DATASET_ID \
  --location=$LOCATION \
  --bq-dataset=bq://$PROJECT_ID.$DATASET_ID \
  --schema-type=analytics \
  --project=$PROJECT_ID
  
echo "COMPLETED MANUAL STEPS (y/n):"
read -r answer
if [[ $answer == "y" || $answer == "Y" ]]; then
    echo "SUBSCRIBE TO ABHI ARCADE SOLUTION....."
else
    "SUBSCRIBE TO ABHI ARCADE SOLUTION....."
fi
echo

sleep 180

gcloud healthcare fhir-stores export bq de_id \
--dataset=$DATASET_ID \
--location=$LOCATION \
--bq-dataset=bq://$PROJECT_ID.de_id \
--schema-type=analytics

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
 
