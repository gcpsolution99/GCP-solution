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
gcloud container clusters create gmp-cluster --num-nodes=3 --zone=$ZONE
gcloud container clusters get-credentials gmp-cluster --zone=$ZONE
kubectl create ns gmp-test
kubectl -n gmp-test apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/prometheus-engine/v0.2.3/manifests/setup.yaml
kubectl -n gmp-test apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/prometheus-engine/v0.2.3/manifests/operator.yaml
kubectl -n gmp-test apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/prometheus-engine/v0.2.3/examples/example-app.yaml
cat > op-config.yaml <<'EOF_END'
apiVersion: monitoring.googleapis.com/v1alpha1
collection:
  filter:
    matchOneOf:
    - '{job="prom-example"}'
    - '{__name__=~"job:.+"}'
kind: OperatorConfig
metadata:
  annotations:
    components.gke.io/layer: addon
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"monitoring.googleapis.com/v1alpha1","kind":"OperatorConfig","metadata":{"annotations":{"components.gke.io/layer":"addon"},"labels":{"addonmanager.kubernetes.io/mode":"Reconcile"},"name":"config","namespace":"gmp-public"}}
  creationTimestamp: "2022-03-14T22:34:23Z"
  generation: 1
  labels:
    addonmanager.kubernetes.io/mode: Reconcile
  name: config
  namespace: gmp-public
  resourceVersion: "2882"
  uid: 4ad23359-efeb-42bb-b689-045bd704f295
EOF_END

export PROJECT=$(gcloud config get-value project)
gsutil mb -p $PROJECT gs://$PROJECT
gsutil cp op-config.yaml gs://$PROJECT
gsutil -m acl set -R -a public-read gs://$PROJECT
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
