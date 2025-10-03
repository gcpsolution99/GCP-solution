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
PROJECT_ID=$(gcloud config get-value project)
PROJECT_NUMBER=$(gcloud projects list --filter="project_id:$PROJECT_ID" --format='value(project_number)')
gcloud config set functions/region $REGION

git clone https://github.com/GoogleCloudPlatform/golang-samples.git
cd golang-samples/functions/functionsv2/hellostorage/

deploy_function() {
  gcloud functions deploy "$SERVICE_NAME" \
    --runtime=go121 \
    --region="$REGION" \
    --source=. \
    --entry-point=HelloStorage \
    --trigger-bucket="$DEVSHELL_PROJECT_ID-bucket"
}
SERVICE_NAME="cf-demo"

while true; do

  deploy_function

  if gcloud functions describe "$SERVICE_NAME" --region "$REGION" &> /dev/null; then
    echo ""
    break
  else
    echo ""
    echo ""
    sleep 10
  fi
done
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
