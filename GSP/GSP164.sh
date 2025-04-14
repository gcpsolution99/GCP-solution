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
export ZONE=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-zone])")

export REGION=$(echo "$ZONE" | cut -d '-' -f 1-2)

gcloud services enable apikeys.googleapis.com

gsutil cp gs://spls/gsp164/endpoints-quickstart.zip .
unzip endpoints-quickstart.zip

cd endpoints-quickstart
cd scripts

./deploy_api.sh

sleep 60

./deploy_app.sh ../app/app_template.yaml $REGION

sleep 60

./query_api.sh

./query_api.sh JFK

./deploy_api.sh ../openapi_with_ratelimit.yaml

sleep 60

./deploy_app.sh ../app/app_template.yaml $REGION

sleep 60

gcloud alpha services api-keys create --display-name="awesome" 

KEY_NAME=$(gcloud alpha services api-keys list --format="value(name)" --filter "displayName=awesome")

export API_KEY=$(gcloud alpha services api-keys get-key-string $KEY_NAME --format="value(keyString)")

./query_api_with_key.sh $API_KEY

./generate_traffic_with_key.sh $API_KEY

./query_api_with_key.sh $API_KEY
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
