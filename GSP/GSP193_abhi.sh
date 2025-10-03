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
export PROJECT_ID=$DEVSHELL_PROJECT_ID
export REGION_1="${ZONE%-*}"
export REGION_2="${ZONE_2%-*}"
gcloud config set project $PROJECT_ID
gcloud compute networks create network-a --subnet-mode custom
gcloud compute networks subnets create network-a-subnet --network network-a \
    --range 10.0.0.0/16 --region $REGION_1

gcloud compute instances create vm-a --zone $ZONE --network network-a --subnet network-a-subnet --machine-type e2-small
gcloud compute firewall-rules create network-a-fw --network network-a --allow tcp:22,icmp
gcloud config set project $PROJECT_ID_2
gcloud compute networks create network-b --subnet-mode custom
gcloud compute networks subnets create network-b-subnet --network network-b \
    --range 10.8.0.0/16 --region $REGION_2

gcloud compute instances create vm-b --zone $ZONE_2 --network network-b --subnet network-b-subnet --machine-type e2-small
gcloud compute firewall-rules create network-b-fw --network network-b --allow tcp:22,icmp
gcloud config set project $PROJECT_ID

gcloud compute networks peerings create peer-ab \
    --network=network-a \
    --peer-project=$PROJECT_ID_2 \
    --peer-network=network-b 

gcloud config set project $PROJECT_ID_2

gcloud compute networks peerings create peer-ba \
    --network=network-b \
    --peer-project=$PROJECT_ID \
    --peer-network=network-a
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
