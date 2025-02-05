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
export ZONE=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-zone])")
export REGION=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-region])")

gcloud dataproc clusters create qlab \
  --enable-component-gateway \
  --region $REGION \
  --zone $ZONE \
  --master-machine-type e2-standard-4 \
  --master-boot-disk-type pd-balanced \
  --master-boot-disk-size 100 \
  --num-workers 2 \
  --worker-machine-type e2-standard-2 \
  --worker-boot-disk-size 100 \
  --image-version 2.2-debian12 \
  --project $DEVSHELL_PROJECT_ID
  
sleep 30

gcloud dataproc jobs submit spark \
  --region $REGION \
  --cluster qlab \
  --class org.apache.spark.examples.SparkPi \
  --jars file:///usr/lib/spark/examples/jars/spark-examples.jar \
  -- 1000
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
