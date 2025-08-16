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
gcloud config list project

gcloud services enable compute.googleapis.com
gcloud services enable dns.googleapis.com

sleep 20

gcloud services list | grep -E 'compute|dns'


gcloud compute firewall-rules create fw-default-iapproxy \
--direction=INGRESS \
--priority=1000 \
--network=default \
--action=ALLOW \
--rules=tcp:22,icmp \
--source-ranges=35.235.240.0/20


gcloud compute firewall-rules create allow-http-traffic --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server


gcloud compute instances create us-client-vm --machine-type e2-micro --zone $zone1

gcloud compute instances create europe-client-vm --machine-type e2-micro --zone $zone2

gcloud compute instances create asia-client-vm --machine-type e2-micro --zone $zone3




gcloud compute instances create us-web-vm \
--zone=$zone1 \
--machine-type=e2-micro \
--network=default \
--subnet=default \
--tags=http-server \
--metadata=startup-script='#! /bin/bash
 apt-get update
 apt-get install apache2 -y
 echo "Page served from: us-east1" | \
 tee /var/www/html/index.html
 systemctl restart apache2'


gcloud compute instances create europe-web-vm \
--zone=$zone2 \
--machine-type=e2-micro \
--network=default \
--subnet=default \
--tags=http-server \
--metadata=startup-script='#! /bin/bash
 apt-get update
 apt-get install apache2 -y
 echo "Page served from: europe-west4" | \
 tee /var/www/html/index.html
 systemctl restart apache2'


sleep 20

export US_WEB_IP=$(gcloud compute instances describe us-web-vm --zone=$zone1 --format="value(networkInterfaces.networkIP)")

export EUROPE_WEB_IP=$(gcloud compute instances describe europe-web-vm --zone=$zone2 --format="value(networkInterfaces.networkIP)")



gcloud dns managed-zones create example --description=test --dns-name=example.com --networks=default --visibility=private



gcloud dns record-sets create geo.example.com \
--ttl=5 --type=A --zone=example \
--routing-policy-type=GEO \
--routing-policy-data="$region1=$US_WEB_IP;$region2=$EUROPE_WEB_IP"



gcloud dns record-sets list --zone=example
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
