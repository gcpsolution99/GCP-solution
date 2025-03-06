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
export TAXONOMY_NAME=$(gcloud data-catalog taxonomies list \
  --location=us \
  --project=$DEVSHELL_PROJECT_ID \
  --format="value(displayName)" \
  --limit=1)

export TAXONOMY_ID=$(gcloud data-catalog taxonomies list \
  --location=us \
  --format="value(name)" \
  --filter="displayName=$TAXONOMY_NAME" | awk -F'/' '{print $6}')

export POLICY_TAG=$(gcloud data-catalog taxonomies policy-tags list \
  --location=us \
  --taxonomy=$TAXONOMY_ID \
  --format="value(name)" \
  --limit=1)

bq mk online_shop

bq mk --connection --location=US --project_id=$DEVSHELL_PROJECT_ID --connection_type=CLOUD_RESOURCE user_data_connection

export SERVICE_ACCOUNT=$(bq show --format=json --connection $DEVSHELL_PROJECT_ID.US.user_data_connection | jq -r '.cloudResource.serviceAccountId')

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member=serviceAccount:$SERVICE_ACCOUNT \
  --role=roles/storage.objectViewer

bq mkdef \
--autodetect \
--connection_id=$DEVSHELL_PROJECT_ID.US.user_data_connection \
--source_format=CSV \
"gs://$DEVSHELL_PROJECT_ID-bucket/user-online-sessions.csv" > /tmp/tabledef.json

bq mk --external_table_definition=/tmp/tabledef.json \
--project_id=$DEVSHELL_PROJECT_ID \
online_shop.user_online_sessions

cat > schema.json << EOM
[
  {
    "mode": "NULLABLE",
    "name": "ad_event_id",
    "type": "INTEGER"
  },
  {
    "mode": "NULLABLE",
    "name": "user_id",
    "type": "INTEGER"
  },
  {
    "mode": "NULLABLE",
    "name": "uri",
    "type": "STRING"
  },
  {
    "mode": "NULLABLE",
    "name": "traffic_source",
    "type": "STRING"
  },
  {
    "mode": "NULLABLE",
    "name": "zip",
    "policyTags": {
      "names": [
        "$POLICY_TAG"
      ]
    },
    "type": "STRING"
  },
  {
    "mode": "NULLABLE",
    "name": "event_type",
    "type": "STRING"
  },
  {
    "mode": "NULLABLE",
    "name": "state",
    "type": "STRING"
  },
  {
    "mode": "NULLABLE",
    "name": "country",
    "type": "STRING"
  },
  {
    "mode": "NULLABLE",
    "name": "city",
    "type": "STRING"
  },
  {
    "mode": "NULLABLE",
    "name": "latitude",
    "policyTags": {
      "names": [
        "$POLICY_TAG"
      ]
    },
    "type": "FLOAT"
  },
  {
    "mode": "NULLABLE",
    "name": "created_at",
    "type": "TIMESTAMP"
  },
  {
    "mode": "NULLABLE",
    "name": "ip_address",
    "policyTags": {
      "names": [
        "$POLICY_TAG"
      ]
    },
    "type": "STRING"
  },
  {
    "mode": "NULLABLE",
    "name": "session_id",
    "type": "STRING"
  },
  {
    "mode": "NULLABLE",
    "name": "longitude",
    "policyTags": {
      "names": [
        "$POLICY_TAG"
      ]
    },
    "type": "FLOAT"
  },
  {
    "mode": "NULLABLE",
    "name": "id",
    "type": "INTEGER"
  }
]
EOM

bq update --schema schema.json $DEVSHELL_PROJECT_ID:online_shop.user_online_sessions

bq query --use_legacy_sql=false --format=csv \
"SELECT * EXCEPT(zip, latitude, ip_address, longitude) 
FROM \`${DEVSHELL_PROJECT_ID}.online_shop.user_online_sessions\`"

gcloud projects remove-iam-policy-binding ${DEVSHELL_PROJECT_ID} \
  --member="user:$IAM_USER" \
  --role="roles/storage.objectViewer"
  
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





