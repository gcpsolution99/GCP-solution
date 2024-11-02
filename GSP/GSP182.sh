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
PROJECT=$(gcloud config get-value project)
CLUSTER=gke-load-test
TARGET=${PROJECT}.appspot.com
gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE
gsutil -m cp -r gs://spls/gsp182/distributed-load-testing-using-kubernetes .
cd distributed-load-testing-using-kubernetes/sample-webapp/
sed -i "s/python37/python39/g" app.yaml
cd ..
gcloud builds submit --tag gcr.io/$PROJECT/locust-tasks:latest docker-image/.
gcloud app create --region=$REGION
gcloud app deploy sample-webapp/app.yaml --quiet
gcloud container clusters create $CLUSTER \
  --zone $ZONE \
  --num-nodes=5
sed -i -e "s/\[TARGET_HOST\]/$TARGET/g" kubernetes-config/locust-master-controller.yaml
sed -i -e "s/\[TARGET_HOST\]/$TARGET/g" kubernetes-config/locust-worker-controller.yaml
sed -i -e "s/\[PROJECT_ID\]/$PROJECT/g" kubernetes-config/locust-master-controller.yaml
sed -i -e "s/\[PROJECT_ID\]/$PROJECT/g" kubernetes-config/locust-worker-controller.yaml
kubectl apply -f kubernetes-config/locust-master-controller.yaml
kubectl get pods -l app=locust-master
kubectl apply -f kubernetes-config/locust-master-service.yaml
kubectl get svc locust-master
kubectl apply -f kubernetes-config/locust-worker-controller.yaml
kubectl get pods -l app=locust-worker
kubectl scale deployment/locust-worker --replicas=20
kubectl get pods -l app=locust-worker
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
