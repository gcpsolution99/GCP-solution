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
gcloud compute instances create access-test --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --machine-type=e2-medium
IP_ADDRESS=$(gcloud compute instances describe access-test --zone=$ZONE --format="get(networkInterfaces[0].accessConfigs[0].natIP)")
echo $IP_ADDRESS
ACCESS_TOKEN=$(gcloud auth print-access-token) 
echo $ACCESS_TOKEN
export PROJECT_ID=$(gcloud config get-value project)
export DEVSHELL_PROJECT_ID=$PROJECT_ID
sleep 40
curl -X POST \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  https://compute.googleapis.com/compute/v1/projects/$DEVSHELL_PROJECT_ID/global/securityPolicies \
  -d "{
    \"adaptiveProtectionConfig\": {
      \"layer7DdosDefenseConfig\": {
        \"enable\": false
      }
    },
    \"description\": \"\",
    \"name\": \"blocklist-access-test\",
    \"rules\": [
      {
        \"action\": \"deny(404)\",
        \"description\": \"\",
        \"match\": {
          \"config\": {
            \"srcIpRanges\": [
              \"$IP_ADDRESS\"
            ]
          },
          \"versionedExpr\": \"SRC_IPS_V1\"
        },
        \"preview\": false,
        \"priority\": 1000
      },
      {
        \"action\": \"allow\",
        \"description\": \"Default rule, higher priority overrides it\",
        \"match\": {
          \"config\": {
            \"srcIpRanges\": [
              \"*\"
            ]
          },
          \"versionedExpr\": \"SRC_IPS_V1\"
        },
        \"preview\": false,
        \"priority\": 2147483647
      }
    ],
    \"type\": \"CLOUD_ARMOR\"
  }"
sleep 40
curl -X POST \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  https://compute.googleapis.com/compute/v1/projects/$DEVSHELL_PROJECT_ID/global/backendServices/web-backend/setSecurityPolicy \
  -d "{
    \"securityPolicy\": \"projects/$DEVSHELL_PROJECT_ID/global/securityPolicies/blocklist-access-test\"
  }"
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
