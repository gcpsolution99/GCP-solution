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
export ZONE=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-zone])")
gcloud compute instances create gcelab --zone=$ZONE --machine-type=e2-medium --boot-disk-size=10GB --image-family=debian-11 --image-project=debian-cloud --create-disk=size=10GB,type=pd-balanced --tags=http-server
gcloud compute instances create gcelab2 --machine-type e2-medium --zone=$ZONE
gcloud compute firewall-rules create allow-http --action=ALLOW --direction=INGRESS --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server
gcloud compute ssh gcelab --zone=$ZONE --quiet --command "sudo apt-get update && sudo apt-get install -y nginx && ps auwx | grep nginx "
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
