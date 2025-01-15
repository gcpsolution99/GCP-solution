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
export GOOGLE_CLOUD_PROJECT=$(gcloud config get-value project)
gsutil mb gs://$GOOGLE_CLOUD_PROJECT
gsutil cp -r gs://spls/gsp1153/* gs://$GOOGLE_CLOUD_PROJECT
bq --location=us mk --dataset mainframe_import
gsutil cp gs://$GOOGLE_CLOUD_PROJECT/schema_*.json .
bq load --source_format=NEWLINE_DELIMITED_JSON     mainframe_import.accounts gs://$GOOGLE_CLOUD_PROJECT/accounts.json schema_accounts.json
bq load --source_format=NEWLINE_DELIMITED_JSON     mainframe_import.transactions  gs://$GOOGLE_CLOUD_PROJECT/transactions.json schema_transactions.json
bq query --use_legacy_sql=false \
"CREATE OR REPLACE VIEW \`$GOOGLE_CLOUD_PROJECT.mainframe_import.account_transactions\` AS
SELECT t.*, a.* EXCEPT (id)
FROM \`mainframe_import.accounts\` AS a
JOIN \`mainframe_import.transactions\` AS t
ON a.id = t.account_id"
bq query --use_legacy_sql=false \
"SELECT * FROM \`mainframe_import.transactions\` LIMIT 100"
bq query --use_legacy_sql=false \
"SELECT DISTINCT(occupation), COUNT(occupation)
FROM \`mainframe_import.accounts\`
GROUP BY occupation"
bq query --use_legacy_sql=false \
"SELECT *
FROM \`mainframe_import.accounts\`
WHERE salary_range = '110,000+'
ORDER BY name"
gcloud services enable dataflow.googleapis.com
export CONNECTION_URL=170c8c0c2a344f1c973fe3d26c6a1d9c:dXMtY2VudHJhbDEuZ2NwLmNsb3VkLmVzLmlvJDRkMjRiN2M5YzYzYjRhYzk4OTRmMGUzOThkMWI4ZTIxJDRjMmZlMDZhYzNlNTQxMDg5OTY1ZmVkYjRmNjI3OGRm
export API_KEY=ekQwZFlaUUJrMm1lR3c1VHhhUTA6NHNQQ2laeU5RWW0yV0JHSHlnREhfQQ==
sleep 45
gcloud dataflow flex-template run bqtoelastic-`date +%s` --worker-machine-type=e2-standard-2 --template-file-gcs-location gs://dataflow-templates-$REGION/latest/flex/BigQuery_to_Elasticsearch --region $REGION --num-workers 1 --parameters index=transactions,maxNumWorkers=1,query="select * from \`$GOOGLE_CLOUD_PROJECT\`.mainframe_import.account_transactions",connectionUrl=$CONNECTION_URL,apiKey=$API_KEY
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
