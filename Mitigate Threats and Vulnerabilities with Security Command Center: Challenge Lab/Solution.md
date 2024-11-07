
task 1 - 

export ZONE=us-east1-a
export REGION=us-east1

task 2- 

gcloud scc muteconfigs create muting-flow-log-findings \
--description="Rule for muting VPC Flow Logs" \
--filter='category="FLOW_LOGS_DISABLED"' \
--type=STATIC \
--project=$DEVSHELL_PROJECT_ID \
--location=global

gcloud scc muteconfigs create muting-audit-logging-findings \
--description="Rule for muting audit logs" \
--filter='category="AUDIT_LOGGING_DISABLED"' \
--type=STATIC \
--project=$DEVSHELL_PROJECT_ID \
--location=global

gcloud scc muteconfigs create muting-admin-sa-findings \
--description="Rule for muting admin service account findings" \
--filter='category="ADMIN_SERVICE_ACCOUNT"' \
--type=STATIC \
--location=global \
--project=$DEVSHELL_PROJECT_ID \
--location=global

task 3 - open firwall rules - https://console.cloud.google.com/net-security/firewall-manager/firewall-policies/list

task 4 - Open VM instances --> static-ip
                  Open https://console.cloud.google.com/security/web-scanner/scanConfigs

task 5

gsutil mb -p $DEVSHELL_PROJECT_ID -c STANDARD -l $REGION -b on gs://scc-export-bucket-$DEVSHELL_PROJECT_ID

gsutil uniformbucketlevelaccess set off gs://scc-export-bucket-$DEVSHELL_PROJECT_ID

curl -LO raw.githubusercontent.com/gcpsolution99/GCP-solution/refs/heads/main/Mitigate%20Threats%20and%20Vulnerabilities%20with%20Security%20Command%20Center%3A%20Challenge%20Lab/findings.jsonl

gsutil cp findings.jsonl gs://scc-export-bucket-$DEVSHELL_PROJECT_ID
