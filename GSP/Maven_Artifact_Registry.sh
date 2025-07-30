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
gcloud artifacts repositories create my-maven-repo \
    --repository-format=maven \
    --location="$REGION" \
    --description="Maven repository"

gcloud artifacts repositories list --location="$REGION"
gcloud artifacts print-settings mvn --repository=my-maven-repo --project="$PROJECT_ID" --location="$REGION"
mvn archetype:generate \
    -DgroupId=com.example \
    -DartifactId=my-app \
    -Dversion=1.0-SNAPSHOT \
    -DarchetypeArtifactId=maven-archetype-quickstart \
    -DinteractiveMode=false

cd my-app
gcloud artifacts print-settings mvn --repository=my-maven-repo --project="$PROJECT_ID" --location="$REGION" > example.pom
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
