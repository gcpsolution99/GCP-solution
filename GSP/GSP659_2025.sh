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

export REGION=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-region])")

git clone https://github.com/googlecodelabs/monolith-to-microservices.git

cd ~/monolith-to-microservices

./setup.sh

cd ~/monolith-to-microservices/monolith

gcloud artifacts repositories create monolith-demo --location=$REGION --repository-format=docker --description="Subscribe to techcps" 

gcloud auth configure-docker $REGION-docker.pkg.dev

gcloud services enable artifactregistry.googleapis.com \
    cloudbuild.googleapis.com \
    run.googleapis.com

gcloud builds submit --tag $REGION-docker.pkg.dev/${GOOGLE_CLOUD_PROJECT}/monolith-demo/monolith:1.0.0

gcloud run deploy monolith --image $REGION-docker.pkg.dev/${GOOGLE_CLOUD_PROJECT}/monolith-demo/monolith:1.0.0 --allow-unauthenticated --region $REGION

gcloud run deploy monolith --image $REGION-docker.pkg.dev/${GOOGLE_CLOUD_PROJECT}/monolith-demo/monolith:1.0.0 --allow-unauthenticated --region $REGION --concurrency 1

gcloud run deploy monolith --image $REGION-docker.pkg.dev/${GOOGLE_CLOUD_PROJECT}/monolith-demo/monolith:1.0.0 --allow-unauthenticated --region $REGION --concurrency 80

cd ~/monolith-to-microservices/react-app/src/pages/Home

mv index.js.new index.js

cat ~/monolith-to-microservices/react-app/src/pages/Home/index.js

cd ~/monolith-to-microservices/react-app

npm run build:monolith

cd ~/monolith-to-microservices/monolith

gcloud builds submit --tag $REGION-docker.pkg.dev/${GOOGLE_CLOUD_PROJECT}/monolith-demo/monolith:2.0.0

gcloud run deploy monolith --image $REGION-docker.pkg.dev/${GOOGLE_CLOUD_PROJECT}/monolith-demo/monolith:2.0.0 --allow-unauthenticated --region $REGION

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
