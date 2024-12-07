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
gcloud storage buckets create gs://$BUCKET_NEW --location=$REGION
gcloud storage cp --recursive gs://$BUCKET_OLD/* gs://$BUCKET_NEW
gcloud storage buckets update gs://$BUCKET_NEW --no-uniform-bucket-level-access
gcloud storage buckets add-iam-policy-binding gs://$BUCKET_NEW --member=allUsers --role=roles/storage.admin
gcloud storage buckets update gs://$BUCKET_NEW --web-main-page-suffix=index.html --web-error-page=error.html
gcloud compute addresses create example-ip --network-tier=PREMIUM --ip-version=IPV4 --global
gcloud compute addresses describe example-ip --format="get(address)" --global
gcloud compute backend-buckets create cp-backend-bucket --gcs-bucket-name=$BUCKET_NEW
gcloud compute url-maps create cp-load-balancer --default-backend-bucket=cp-backend-bucket
gcloud compute target-http-proxies create cp-tp --url-map=cp-load-balancer
gcloud compute forwarding-rules create cp-ff --load-balancing-scheme=EXTERNAL --network-tier=PREMIUM --target-http-proxy=cp-tp --ports=80 --address=example-ip --global
sleep 45
IP_ADDRESS=$(gcloud compute addresses describe example-ip --format="get(address)" --global)
curl http://$IP_ADDRESS
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



