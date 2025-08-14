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

gcloud compute instances create www-1 \
    --image-family debian-11 \
    --image-project debian-cloud \
    --machine-type e2-micro \
    --zone $REGION1-d \
    --tags http-tag \
    --metadata startup-script="#! /bin/bash
      apt-get update
      apt-get install apache2 -y
      service apache2 restart
      echo '<!doctype html><html><body><h1>www-1</h1></body></html>' | tee /var/www/html/index.html
"


gcloud compute instances create www-2 \
    --image-family debian-11 \
    --image-project debian-cloud \
    --machine-type e2-micro \
    --zone $REGION1-d \
    --tags http-tag \
    --metadata startup-script="#! /bin/bash
      apt-get update
      apt-get install apache2 -y
      service apache2 restart
      echo '<!doctype html><html><body><h1>www-2</h1></body></html>' | tee /var/www/html/index.html
"


gcloud compute instances create www-3 \
    --image-family debian-11 \
    --image-project debian-cloud \
    --machine-type e2-micro \
    --zone $REGION2-c \
    --tags http-tag \
    --metadata startup-script="#! /bin/bash
      apt-get update
      apt-get install apache2 -y
      service apache2 restart
      echo '<!doctype html><html><body><h1>www-3</h1></body></html>' | tee /var/www/html/index.html
"


gcloud compute instances create www-4 \
    --image-family debian-11 \
    --image-project debian-cloud \
    --machine-type e2-micro \
    --zone $REGION2-c \
    --tags http-tag \
    --metadata startup-script="#! /bin/bash
      apt-get update
      apt-get install apache2 -y
      service apache2 restart
      echo '<!doctype html><html><body><h1>www-4</h1></body></html>' | tee /var/www/html/index.html
"

gcloud compute firewall-rules create www-firewall \
    --target-tags http-tag --allow tcp:80

gcloud compute instances list


gcloud compute addresses create lb-ip-cr \
    --ip-version=IPV4 \
    --global


gcloud compute instance-groups unmanaged create $REGION1-resources-w --zone $REGION1-d


gcloud compute instance-groups unmanaged create $REGION2-resources-w --zone $REGION2-c


gcloud compute instance-groups unmanaged add-instances $REGION1-resources-w \
    --instances www-1,www-2 \
    --zone $REGION1-d

gcloud compute instance-groups unmanaged add-instances $REGION2-resources-w \
    --instances www-3,www-4 \
    --zone $REGION2-c

gcloud compute health-checks create http http-basic-check




gcloud compute instance-groups unmanaged set-named-ports $REGION1-resources-w \
    --named-ports http:80 \
    --zone $REGION1-d


gcloud compute instance-groups unmanaged set-named-ports $REGION2-resources-w \
    --named-ports http:80 \
    --zone $REGION2-c


gcloud compute backend-services create web-map-backend-service \
    --protocol HTTP \
    --health-checks http-basic-check \
    --global


gcloud compute backend-services add-backend web-map-backend-service \
    --balancing-mode UTILIZATION \
    --max-utilization 0.8 \
    --capacity-scaler 1 \
    --instance-group $REGION1-resources-w \
    --instance-group-zone $REGION1-d \
    --global


gcloud compute backend-services add-backend web-map-backend-service \
    --balancing-mode UTILIZATION \
    --max-utilization 0.8 \
    --capacity-scaler 1 \
    --instance-group $REGION2-resources-w \
    --instance-group-zone $REGION2-c \
    --global


gcloud compute url-maps create web-map \
    --default-service web-map-backend-service


gcloud compute target-http-proxies create http-lb-proxy \
    --url-map web-map


gcloud compute addresses list
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
