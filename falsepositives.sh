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
gcloud iam service-accounts create test-account \
  --description="Test account for project management" \
  --display-name="Test Account"
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member="serviceAccount:test-account@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/owner"
gcloud iam service-accounts keys create ~/test-account.json \
    --iam-account="test-account@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com"
export PROJECT_ID=$(gcloud info --format='value(config.project)')
export SA_NAME="test-account@${PROJECT_ID}.iam.gserviceaccount.com"
gcloud auth activate-service-account ${SA_NAME} --key-file=test-account.json
gcloud projects add-iam-policy-binding $PROJECT_ID --member user:$username2 --role roles/editor
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
