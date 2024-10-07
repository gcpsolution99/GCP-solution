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
gcloud config set compute/zone $LOCATION 
export PROJECT_ID=$(gcloud config get-value project)
export REGION=${LOCATION%-*}
gcloud config set compute/region $REGION
echo "PROJECT_ID=${PROJECT_ID}"
echo "REGION=${REGION}"
USER=$(gcloud config get-value account 2> /dev/null)
echo "USER=${USER}"
gcloud services enable cloudaicompanion.googleapis.com --project ${PROJECT_ID}
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member user:${USER} --role=roles/cloudaicompanion.user
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member user:${USER} --role=roles/serviceusage.serviceUsageViewer
gcloud services enable container.googleapis.com --project ${PROJECT_ID}
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member user:${USER} --role=roles/container.admin
gcloud container clusters create test \
    --project=$PROJECT_ID \
    --zone=$LOCATION \
    --num-nodes=3 \
    --machine-type=e2-standard-4
git clone --depth=1 https://github.com/GoogleCloudPlatform/microservices-demo
cd ~/microservices-demo
kubectl apply -f ./release/kubernetes-manifests.yaml
kubectl get deployments
sleep 25
kubectl get deployments
sleep 25
gcloud builds worker-pools create pool-test \
  --project=$PROJECT_ID \
  --region=$REGION \
  --no-public-egress
gcloud artifacts repositories create my-repo \
  --repository-format=docker \
  --location=$REGION \
  --description="My private Docker repository"      
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
