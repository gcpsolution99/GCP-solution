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

gcloud services enable cloudscheduler.googleapis.com

gcloud services enable run.googleapis.com

sleep 15

export ZONE=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-zone])")

export REGION=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-region])")

gcloud storage cp -r gs://spls/gsp649/* . && cd gcf-automated-resource-cleanup/

export PROJECT_ID=$(gcloud config list --format 'value(core.project)' 2>/dev/null)
WORKDIR=$(pwd)

sudo apt-get update
sudo apt-get install apache2-utils -y

cd $WORKDIR/migrate-storage

export PROJECT_ID=$(gcloud config list --format 'value(core.project)' 2>/dev/null)
gcloud storage buckets create  gs://${PROJECT_ID}-serving-bucket -l $REGION

gsutil acl ch -u allUsers:R gs://${PROJECT_ID}-serving-bucket

gcloud storage cp $WORKDIR/migrate-storage/testfile.txt  gs://${PROJECT_ID}-serving-bucket

gsutil acl ch -u allUsers:R gs://${PROJECT_ID}-serving-bucket/testfile.txt

curl http://storage.googleapis.com/${PROJECT_ID}-serving-bucket/testfile.txt

gcloud storage buckets create gs://${PROJECT_ID}-idle-bucket -l $REGION
export IDLE_BUCKET_NAME=$PROJECT_ID-idle-bucket

gcloud services enable monitoring.googleapis.com

cat > bucket_usage_dashboard.json <<EOF_CP
{
  "displayName": "Bucket Usage",
  "gridLayout": {
    "columns": 1,
    "widgets": [
      {
        "title": "Bucket Access",
        "xyChart": {
          "dataSets": [
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "metric.type=\"storage.googleapis.com/api/request_count\" AND metric.label.method=\"ReadObject\"",
                  "aggregation": {
                    "alignmentPeriod": "60s",
                    "perSeriesAligner": "ALIGN_RATE"
                  }
                }
              }
            }
          ],
          "timeshiftDuration": "0s",
          "yAxis": {
            "label": "Request Count",
            "scale": "LINEAR"
          }
        }
      }
    ]
  }
}
EOF_CP

gcloud monitoring dashboards create --config-from-file=bucket_usage_dashboard.json


echo "Test content" > testfile.txt
gsutil cp testfile.txt gs://$PROJECT_ID-idle-bucket/
gsutil cat gs://$PROJECT_ID-idle-bucket/testfile.txt


gcloud services enable run.googleapis.com

cat $WORKDIR/migrate-storage/main.py | grep "migrate_storage(" -A 15

sed -i "s/<project-id>/$PROJECT_ID/" $WORKDIR/migrate-storage/main.py

gcloud services disable cloudfunctions.googleapis.com

gcloud services enable cloudfunctions.googleapis.com

export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")

gcloud projects add-iam-policy-binding $PROJECT_ID \
--member="serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com" \
--role="roles/artifactregistry.reader"

export REGION=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-region])")
export PROJECT_ID=$(gcloud config get-value project)
export WORKDIR=~/gcf-automated-resource-cleanup

cd $WORKDIR/migrate-storage


#!/bin/bash
SERVICE_NAME="migrate_storage"

deploy_function() {
  gcloud functions deploy migrate_storage \
  --gen2 \
  --region=$REGION \
  --runtime=python39 \
  --entry-point=migrate_storage \
  --trigger-http \
  --source=. \
  --quiet
}

while true; do
  deploy_function
  if gcloud functions describe $SERVICE_NAME --region $REGION &> /dev/null; then
    echo ""
    break
  else
    echo ""
    sleep 10
  fi
done

sleep 10

export FUNCTION_URL=$(gcloud functions describe migrate_storage --format=json --region $REGION | jq -r '.url')

export IDLE_BUCKET_NAME=$PROJECT_ID-idle-bucket
sed -i "s/\\\$IDLE_BUCKET_NAME/$IDLE_BUCKET_NAME/" $WORKDIR/migrate-storage/incident.json

envsubst < $WORKDIR/migrate-storage/incident.json | curl -X POST -H "Content-Type: application/json" $FUNCTION_URL -d @-

gsutil defstorageclass set nearline gs://$PROJECT_ID-idle-bucket

gsutil defstorageclass get gs://$PROJECT_ID-idle-bucket
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
 
