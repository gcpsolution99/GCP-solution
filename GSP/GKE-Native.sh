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
source <(kubectl completion bash)

gcloud container clusters create $my_cluster \
   --num-nodes 3 --enable-ip-alias --zone $my_zone  \
   --logging=SYSTEM \
   --monitoring=SYSTEM

gcloud container clusters get-credentials $my_cluster --zone $my_zone

git clone https://github.com/GoogleCloudPlatform/training-data-analyst

ln -s ~/training-data-analyst/courses/ak8s/v1.1 ~/ak8s

cd ~/ak8s/Monitoring/

kubectl create -f hello-v2.yaml

kubectl get deployments

export PROJECT_ID="$(gcloud config get-value project -q)"

cd gcp-gke-monitor-test

gcloud builds submit --tag=gcr.io/$PROJECT_ID/gcp-gke-monitor-test .

docker build -t gcr.io/${PROJECT_ID}/gcp-gke-monitor-test .

cd ..

sed -i "s/\[DOCKER-IMAGE\]/gcr\.io\/${PROJECT_ID}\/gcp-gke-monitor-test\:latest/" gcp-gke-monitor-test.yaml

kubectl create -f gcp-gke-monitor-test.yaml

kubectl get deployments

kubectl get service
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
