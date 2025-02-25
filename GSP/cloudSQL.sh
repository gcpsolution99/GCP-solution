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
export ZONE=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-zone])")

export REGION=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-region])")

gcloud services enable servicenetworking.googleapis.com
gcloud services enable sqladmin.googleapis.com

gcloud compute addresses create google-managed-services-default \
    --global \
    --purpose=VPC_PEERING \
    --prefix-length=24 \
    --network=default

sleep 30

gcloud services vpc-peerings connect \
    --service=servicenetworking.googleapis.com \
    --network=default \
    --ranges=google-managed-services-default

gcloud sql instances create wordpress-db \
    --database-version=MYSQL_8_0 \
    --tier=db-custom-1-3840 \
    --region=$REGION \
    --storage-size=10GB \
    --storage-type=SSD \
    --root-password=awesome \
    --network=default \
    --no-assign-ip \
    --enable-google-private-path

gcloud sql databases create wordpress \
  --instance=wordpress-db \
  --charset=utf8 \
  --collation=utf8_general_ci

cat > prepare_disk.sh <<'EOF_END'

export PROJECT_ID=$(gcloud config get-value project)

export ZONE=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-zone])")

export REGION=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-region])")

wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy && chmod +x cloud_sql_proxy

export SQL_CONNECTION=$PROJECT_ID:$REGION:wordpress-db

./cloud_sql_proxy -instances=$SQL_CONNECTION=tcp:3306 &

EOF_END

gcloud compute scp prepare_disk.sh wordpress-proxy:/tmp \
  --project=$(gcloud config get-value project) --zone=$ZONE --quiet

gcloud compute ssh wordpress-proxy \
  --project=$(gcloud config get-value project) --zone=$ZONE --quiet \
  --command="bash /tmp/prepare_disk.sh"
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
