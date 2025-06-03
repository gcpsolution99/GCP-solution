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
export BUCKET="$(gcloud config get-value project)"
gsutil mb -p $BUCKET gs://$BUCKET-bucket
curl -LO raw.githubusercontent.com/ArcadeCrew/Google-Cloud-Labs/refs/heads/main/APIs%20Explorer%20Qwik%20Start/demo-image.jpg
gsutil cp demo-image.jpg gs://$BUCKET-bucket/demo-image.jpg
gsutil acl ch -u allUsers:R gs://$BUCKET-bucket/demo-image.jpg  
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
