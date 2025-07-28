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

gcloud services enable artifactregistry.googleapis.com

export REGION=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-region])")

export PROJECT_ID=$(gcloud config get-value project)

gcloud config set compute/region $REGION
gcloud config set project $PROJECT_ID

gcloud artifacts repositories create my-docker-repo \
    --repository-format=docker \
    --location="$REGION" \
    --description="Docker repository"


gcloud auth configure-docker "$REGION"-docker.pkg.dev

mkdir sample-app
cd sample-app
echo "FROM nginx:latest" > Dockerfile

docker build -t nginx-image .

docker tag nginx-image "$REGION"-docker.pkg.dev/"$PROJECT_ID"/my-docker-repo/nginx-image:latest

docker push "$REGION"-docker.pkg.dev/"$PROJECT_ID"/my-docker-repo/nginx-image:latest
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
