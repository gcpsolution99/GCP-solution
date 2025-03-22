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
gcloud services enable bigqueryconnection.googleapis.com
bq mk --connection --connection_type=CLOUD_RESOURCE --location=$REGION continuous-queries-connection
bq show --format=prettyjson --connection $REGION.continuous-queries-connection | grep serviceAccountId
SERVICE_ACCOUNT=$(bq show --format=json --connection $REGION.continuous-queries-connection | jq -r '.cloudResource.serviceAccountId')
echo $SERVICE_ACCOUNT
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member="serviceAccount:$SERVICE_ACCOUNT" \
    --role="roles/aiplatform.user"
gcloud projects get-iam-policy $DEVSHELL_PROJECT_ID \
    --flatten="bindings[].members" --format="table(bindings.role, bindings.members)" | grep "bqcx-"
bq query --use_legacy_sql=false "
CREATE MODEL \`continuous_queries.gemini_1_5_pro\`
REMOTE WITH CONNECTION \`$REGION.continuous-queries-connection\`
OPTIONS(endpoint = 'gemini-1.5-pro');"
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
