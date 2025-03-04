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
gcloud compute networks create taw-custom-network --subnet-mode custom

gcloud compute networks subnets create subnet-$FIRST_REGION \
   --network taw-custom-network \
   --region $FIRST_REGION \
   --range 10.0.0.0/16

gcloud compute networks subnets create subnet-$SECOND_REGION \
   --network taw-custom-network \
   --region $SECOND_REGION \
   --range 10.1.0.0/16

gcloud compute networks subnets create subnet-$THIRD_REGION \
   --network taw-custom-network \
   --region $THIRD_REGION \
   --range 10.2.0.0/16

gcloud compute networks subnets list \
   --network taw-custom-network

gcloud compute firewall-rules create nw101-allow-http \
   --allow tcp:80 --network taw-custom-network --source-ranges 0.0.0.0/0 \
   --target-tags http

gcloud compute firewall-rules create nw101-allow-icmp \
   --allow icmp --network taw-custom-network --target-tags rules

gcloud compute firewall-rules create nw101-allow-internal \
   --allow tcp:0-65535,udp:0-65535,icmp --network taw-custom-network \
   --source-ranges "10.0.0.0/16","10.2.0.0/16","10.1.0.0/16"

gcloud compute firewall-rules create nw101-allow-ssh \
   --allow tcp:22 --network taw-custom-network --target-tags ssh

gcloud compute firewall-rules create nw101-allow-rdp \
   --allow tcp:3389 --network taw-custom-network
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
