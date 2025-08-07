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

gcloud services enable secretmanager.googleapis.com --project=$PROJECT_ID

gcloud secrets create my-secret --project=$PROJECT_ID

echo -n "super-secret-password" | gcloud secrets versions add my-secret --data-file=- --project=$PROJECT_ID

echo "$(gcloud secrets versions access latest --secret=my-secret --project=$PROJECT_ID)"

export MY_SECRET=$(gcloud secrets versions access latest --secret=my-secret --project=$PROJECT_ID)

echo "${MY_SECRET}"

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
