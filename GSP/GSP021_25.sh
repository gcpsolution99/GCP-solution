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
echo "Enter ZONE:"
read -p "Zone: " ZONE
export ZONE

echo
gcloud config set compute/zone $ZONE

echo
gcloud container clusters create io

echo
gsutil cp -r gs://spls/gsp021/* .

echo
cd orchestrate-with-kubernetes/kubernetes

echo
kubectl create deployment nginx --image=nginx:1.10.0

echo
sleep 20

echo
kubectl expose deployment nginx --port 80 --type LoadBalancer

echo
sleep 80

echo
kubectl get services

echo
cd ~/orchestrate-with-kubernetes/kubernetes

echo
kubectl create -f pods/monolith.yaml

echo
kubectl create secret generic tls-certs --from-file tls/
kubectl create configmap nginx-proxy-conf --from-file nginx/proxy.conf

echo
kubectl create -f pods/secure-monolith.yaml

echo
kubectl create -f services/monolith.yaml

echo
gcloud compute firewall-rules create allow-monolith-nodeport \
  --allow=tcp:31000

echo
kubectl label pods secure-monolith 'secure=enabled'
kubectl get pods secure-monolith --show-labels

echo
kubectl create -f deployments/auth.yaml
kubectl create -f services/auth.yaml

echo
kubectl create -f deployments/hello.yaml
kubectl create -f services/hello.yaml

echo
kubectl create configmap nginx-frontend-conf --from-file=nginx/frontend.conf
kubectl create -f deployments/frontend.yaml
kubectl create -f services/frontend.yaml

echo

SCRIPT_NAME="arcadecrew.sh"
if [ -f "$SCRIPT_NAME" ]; then
    echo -e "${BOLD_TEXT}${RED_TEXT}Deleting the script ($SCRIPT_NAME) for safety purposes...${RESET_FORMAT}${NO_COLOR}"
    rm -- "$SCRIPT_NAME"
fi

echo
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
