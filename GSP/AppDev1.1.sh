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
cd ~/training-data-analyst/courses/developingapps/nodejs/cloudstorage/start
. prepare_environment.sh
gsutil mb gs://$DEVSHELL_PROJECT_ID-media
export GCLOUD_BUCKET=$DEVSHELL_PROJECT_ID-media
cd ~/training-data-analyst/courses/developingapps/nodejs/cloudstorage/start/server/gcp
rm cloudstorage.js
wget https://raw.githubusercontent.com/gcpsolution99/GCP-solution/refs/heads/main/App%20Dev%3A%20Storing%20Image%20and%20Video%20Files%20in%20Cloud%20Storage%20v1.1/cloudstorage.js
npm start
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
