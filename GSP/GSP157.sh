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
gcloud compute instances create www-1 \
--image-family debian-11 \
--image-project debian-cloud \
--zone $ZONE_1 \
--tags http-tag \
--metadata startup-script="#! /bin/bash
apt-get update
apt-get install apache2 -y
service apache2 restart
Code
EOF"

sleep 15

gcloud compute instances create www-2 \
--image-family debian-11 \
--image-project debian-cloud \
--zone $ZONE_1 \
--tags http-tag \
--metadata startup-script="#! /bin/bash
apt-get update
apt-get install apache2 -y
service apache2 restart
Code
EOF"


sleep 15

gcloud compute instances create www-3 \
--image-family debian-11 \
--image-project debian-cloud \
--zone $ZONE_2 \
--tags http-tag \
--metadata startup-script="#! /bin/bash
apt-get update
apt-get install apache2 -y
service apache2 restart
Code
EOF"

sleep 15

gcloud compute instances create www-4 \
--image-family debian-11 \
--image-project debian-cloud \
--zone $ZONE_2 \
--tags http-tag \
--metadata startup-script="#! /bin/bash
apt-get update
apt-get install apache2 -y
service apache2 restart
Code
EOF"
gcloud compute instances list
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
