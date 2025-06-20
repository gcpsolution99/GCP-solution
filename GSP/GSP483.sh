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

export ZONE=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-zone])")
export REGION=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-region])")
export PROJECT_ID=$(gcloud config get-value project)
gcloud config set project $DEVSHELL_PROJECT_ID
gcloud config set compute/zone "$ZONE"
gcloud config set compute/region "$REGION"
git clone https://github.com/GoogleCloudPlatform/gke-logging-sinks-demo
sleep 10
cd gke-logging-sinks-demo
sleep 10

sed -i 's/  version = "~> 2.11.0"/  version = "~> 2.19.0"/g' terraform/provider.tf

sed -i 's/  filter      = "resource.type = container"/  filter      = "resource.type = k8s_container"/g' terraform/main.tf

make create
make validate
gcloud logging read "resource.type=k8s_container AND resource.labels.cluster_name=stackdriver-logging" --project=$PROJECT_ID
gcloud logging read "resource.type=k8s_container AND resource.labels.cluster_name=stackdriver-logging" --project=$PROJECT_ID --format=json
gcloud logging sinks create abhi \
    bigquery.googleapis.com/projects/$PROJECT_ID/datasets/bq_logs \
    --log-filter='resource.type="k8s_container" 
resource.labels.cluster_name="stackdriver-logging"' \
    --include-children \
    --format='json'

sleep 20

bq query --use_legacy_sql=false \
"
SELECT * FROM \`$DEVSHELL_PROJECT_ID.gke_logs_dataset.diagnostic_log_*\`
WHERE _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d', CURRENT_DATE() - INTERVAL 1 DAY) AND FORMAT_DATE('%Y%m%d', CURRENT_DATE()) 
"
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
