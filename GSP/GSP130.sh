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
git clone https://github.com/GoogleCloudPlatform/training-data-analyst
cd training-data-analyst/blogs
PROJECT_ID=`gcloud config get-value project`
BUCKET=${PROJECT_ID}-bucket
gsutil mb -c multi_regional gs://${BUCKET}
gsutil -m cp -r endpointslambda gs://${BUCKET}
gsutil -m acl set -R -a public-read gs://${BUCKET}
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
