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
git clone https://github.com/GoogleCloudPlatform/continuous-deployment-on-kubernetes.git
cd continuous-deployment-on-kubernetes
gcloud container clusters create jenkins-cd \
--num-nodes 2 \
--scopes "https://www.googleapis.com/auth/projecthosting,cloud-platform"
gcloud container clusters get-credentials jenkins-cd
helm repo add jenkins https://charts.jenkins.io
helm repo update
helm upgrade --install -f jenkins/values.yaml myjenkins jenkins/jenkins
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
