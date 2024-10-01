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

export PROJECT_ID=$(gcloud info --format='value(config.project)')
export BUCKET=${PROJECT_ID}-ml


gcloud sql instances create taxi \
--tier=db-n1-standard-1 --activation-policy=ALWAYS


gcloud sql users set-password root --host % --instance taxi \
--password Passw0rd


export ADDRESS=$(wget -qO - http://ipecho.net/plain)/32


gcloud sql instances patch taxi --authorized-networks $ADDRESS


MYSQLIP=$(gcloud sql instances describe \
taxi --format="value(ipAddresses.ipAddress)")

echo $MYSQLIP

mysql --host=$MYSQLIP --user=root \
--password --verbose

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
