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
export PROJECT_ID=$(gcloud config get-value project)
gcloud services enable compute.googleapis.com
gcloud services enable dns.googleapis.com
gcloud services list | grep -E 'compute|dns'
gcloud compute firewall-rules create fw-default-iapproxy \
--direction=INGRESS \
--priority=1000 \
--network=default \
--action=ALLOW \
--rules=tcp:22,icmp \
--source-ranges=35.235.240.0/20
gcloud compute firewall-rules create allow-http-traffic --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server
gcloud compute instances create us-client-vm --machine-type e2-medium --zone=$FIRST_ZONE
gcloud compute instances create europe-client-vm --machine-type e2-medium --zone=$SECOND_ZONE
gcloud compute instances create asia-client-vm --machine-type e2-medium --zone=$THIRD_ZONE
gcloud compute instances create us-web-vm \
--zone=$FIRST_ZONE \
--machine-type=e2-medium \
--network=default \
--subnet=default \
--tags=http-server \
--metadata=startup-script='#! /bin/bash
 apt-get update
 apt-get install apache2 -y
 echo "" | \
 tee /var/www/html/index.html
 systemctl restart apache2'
gcloud compute instances create europe-web-vm \
--zone=$SECOND_ZONE \
--machine-type=e2-medium \
--network=default \
--subnet=default \
--tags=http-server \
--metadata=startup-script='#! /bin/bash
 apt-get update
 apt-get install apache2 -y
 echo "" | \
 tee /var/www/html/index.html
 systemctl restart apache2' 
export US_WEB_IP=$(gcloud compute instances describe us-web-vm --zone=$FIRST_ZONE --format="value(networkInterfaces.networkIP)")
export EUROPE_WEB_IP=$(gcloud compute instances describe europe-web-vm --zone=$SECOND_ZONE --format="value(networkInterfaces.networkIP)")
gcloud dns managed-zones create example --description=test --dns-name=example.com --networks=default --visibility=private
gcloud beta dns record-sets create geo.example.com \
--ttl=5 --type=A --zone=example \
--routing_policy_type=GEO \
--routing_policy_data="$FIRST_REGION=$US_WEB_IP;$SECOND_REGION=$EUROPE_WEB_IP"
gcloud beta dns record-sets list --zone=example
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
