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

gcloud services enable securitycenter.googleapis.com

while true; do
  SERVICE_STATUS=$(gcloud services list --enabled | grep "securitycenter.googleapis.com")
  if [ -n "$SERVICE_STATUS" ]; then
    break
  fi
done

gcloud scc muteconfigs create muting-pga-findings \
  --project=$DEVSHELL_PROJECT_ID \
  --description="Mute rule for VPC Flow Logs" \
  --filter="category=\"FLOW_LOGS_DISABLED\""

gcloud compute networks create scc-lab-net --subnet-mode=auto
gcloud compute firewall-rules update default-allow-rdp --source-ranges=35.235.240.0/20
gcloud compute firewall-rules update default-allow-ssh --source-ranges=35.235.240.0/20
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
