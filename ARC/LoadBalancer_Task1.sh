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
gcloud compute instances create utility-vm --project=$DEVSHELL_PROJECT_ID --zone=$FIRST_ZONE --machine-type=e2-medium --network-interface=private-network-ip=10.10.20.50,stack-type=IPV4_ONLY,subnet=subnet-a,no-address --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --create-disk=auto-delete=yes,boot=yes,device-name=utility-vm,image=projects/debian-cloud/global/images/debian-11-bullseye-v20231010,mode=rw,size=10,type=projects/$DEVSHELL_PROJECT_ID/zones/us-central1-f/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any
gcloud compute networks subnets create my-proxy-subnet \
    --purpose=REGIONAL_MANAGED_PROXY \
    --role=ACTIVE \
    --region=$REGION_VALUE \
    --network=my-internal-app \
    --range=10.10.40.0/24
sleep 20
DEVSHELL_PROJECT_ID=$(gcloud config get-value project)
TOKEN=$(gcloud auth application-default print-access-token)
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
