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
export REGION_1=${FIRST_ZONE%-*}
export REGION_2=${SECOND_ZONE%-*}
export VM_1=us-test-01
export VM_2=us-test-02
gcloud compute networks create $VPC_NETWORK_NAME \
    --project=$DEVSHELL_PROJECT_ID \
    --subnet-mode=custom \
    --mtu=1460 \
    --bgp-routing-mode=regional

gcloud compute networks subnets create $FIRST_SUBNET \
    --project=$DEVSHELL_PROJECT_ID \
    --region=$REGION_1 \
    --network=$VPC_NETWORK_NAME \
    --range=10.10.10.0/24 \
    --stack-type=IPV4_ONLY

gcloud compute networks subnets create $SECOND_SUBNET \
    --project=$DEVSHELL_PROJECT_ID \
    --region=$REGION_2 \
    --network=$VPC_NETWORK_NAME \
    --range=10.10.20.0/24 \
    --stack-type=IPV4_ONLY

gcloud compute firewall-rules create $FIREWALL_RULE_1 \
    --project=$DEVSHELL_PROJECT_ID \
    --network=$VPC_NETWORK_NAME \
    --direction=INGRESS \
    --priority=1000 \
    --action=ALLOW \
    --rules=tcp:22 \
    --source-ranges=0.0.0.0/0 \
    --target-tags=all

gcloud compute firewall-rules create $FIREWALL_RULE_2 \
    --project=$DEVSHELL_PROJECT_ID \
    --network=$VPC_NETWORK_NAME \
    --direction=INGRESS \
    --priority=65535 \
    --action=ALLOW \
    --rules=tcp:3389 \
    --source-ranges=0.0.0.0/24 \
    --target-tags=all

gcloud compute firewall-rules create $FIREWALL_RULE_3 \
    --project=$DEVSHELL_PROJECT_ID \
    --network=$VPC_NETWORK_NAME \
    --direction=INGRESS \
    --priority=1000 \
    --action=ALLOW \
    --rules=icmp \
    --source-ranges=0.0.0.0/24 \
    --target-tags=all

gcloud compute instances create $VM_1 \
    --project=$DEVSHELL_PROJECT_ID \
    --zone=$FIRST_ZONE \
    --subnet=$FIRST_SUBNET \
    --tags=allow-icmp

gcloud compute instances create $VM_2 \
    --project=$DEVSHELL_PROJECT_ID \
    --zone=$SECOND_ZONE \
    --subnet=$SECOND_SUBNET \
    --tags=allow-icmp

sleep 30

export EXTERNAL_IP2=$(gcloud compute instances describe $VM_2 \
    --zone=$SECOND_ZONE \
    --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

gcloud compute ssh $VM_1 \
    --zone=$FIRST_ZONE \
    --project=$DEVSHELL_PROJECT_ID \
    --quiet \
    --command="ping -c 3 $EXTERNAL_IP2 && ping -c 3 $VM_2.$SECOND_ZONE"
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
