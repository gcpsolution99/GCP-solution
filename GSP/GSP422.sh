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
git clone https://github.com/GoogleCloudPlatform/python-docs-samples
cd ~/python-docs-samples/appengine/standard_python3/hello_world
export PROJECT_ID=$DEVSHELL_PROJECT_ID
gcloud app create --project $PROJECT_ID --region=$REGION
echo "Y" | gcloud app deploy app.yaml --project $PROJECT_ID
echo "Y" | gcloud app deploy -v v1
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
