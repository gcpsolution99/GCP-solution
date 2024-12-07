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
export PROJECT_ID=$(gcloud config get-value project)
echo "${BOLD}${CYAN}Updating storage bucket settings...${RESET}"
gcloud storage buckets update gs://$PROJECT_ID-bucket --no-uniform-bucket-level-access
gcloud storage buckets update gs://$PROJECT_ID-bucket --web-main-page-suffix=index.html --web-error-page=error.html
echo "${BOLD}${BLUE}Updating access controls for index.html and error.html...${RESET}"
gcloud storage objects update gs://$PROJECT_ID-bucket/index.html --add-acl-grant=entity=AllUsers,role=READER
gcloud storage objects update gs://$PROJECT_ID-bucket/error.html --add-acl-grant=entity=AllUsers,role=READER
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
