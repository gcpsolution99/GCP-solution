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
export PROJECT_ID=$(gcloud config get-value project)
export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')
gcloud config set compute/region $REGION
gcloud services enable \
cloudresourcemanager.googleapis.com \
container.googleapis.com \
sourcerepo.googleapis.com \
cloudbuild.googleapis.com \
containerregistry.googleapis.com \
run.googleapis.com
gcloud projects add-iam-policy-binding $PROJECT_ID \
--member=serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com \
--role=roles/run.admin
gcloud iam service-accounts add-iam-policy-binding \
$PROJECT_NUMBER-compute@developer.gserviceaccount.com \
--member=serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com \
--role=roles/iam.serviceAccountUser
git config --global user.email "$USER@@abhi.net"
git config --global user.name "abhi"
git clone https://github.com/GoogleCloudPlatform/training-data-analyst
cd training-data-analyst/self-paced-labs/cloud-run/canary
rm -rf ../../.git
sed -i "s/us-central1/$REGION/g" branch-cloudbuild.yaml
sed -i "s/us-central1/$REGION/g" master-cloudbuild.yaml
sed -i "s/us-central1/$REGION/g" tag-cloudbuild.yaml
sed -e "s/PROJECT/${PROJECT_ID}/g" -e "s/NUMBER/${PROJECT_NUMBER}/g" branch-trigger.json-tmpl > branch-trigger.json
sed -e "s/PROJECT/${PROJECT_ID}/g" -e "s/NUMBER/${PROJECT_NUMBER}/g" master-trigger.json-tmpl > master-trigger.json
sed -e "s/PROJECT/${PROJECT_ID}/g" -e "s/NUMBER/${PROJECT_NUMBER}/g" tag-trigger.json-tmpl > tag-trigger.json
gcloud source repos create cloudrun-progression
git init
git config credential.helper gcloud.sh
git remote add gcp https://source.developers.google.com/p/$PROJECT_ID/r/cloudrun-progression
git branch -m master
git add . && git commit -m "initial commit"
git push gcp master
sleep 60
gcloud builds submit --tag gcr.io/$PROJECT_ID/hello-cloudrun
gcloud run deploy hello-cloudrun \
--image gcr.io/$PROJECT_ID/hello-cloudrun \
--platform managed \
--region $REGION \
--tag=prod -q
PROD_URL=$(gcloud run services describe hello-cloudrun --platform managed --region $REGION --format=json | jq --raw-output ".status.url")
echo $PROD_URL
curl -H "Authorization: Bearer $(gcloud auth print-identity-token)" $PROD_URL
gcloud beta builds triggers create cloud-source-repositories --trigger-config branch-trigger.json
git checkout -b new-feature-1
rm -f app.py
cat > app.py <<EOF
import os

from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello World v1.1'

if __name__ == "__main__":
    app.run(debug=True,host='0.0.0.0',port=int(os.environ.get('PORT', 8080)))

EOF
git add . && git commit -m "updated" && git push gcp new-feature-1
BRANCH_URL=$(gcloud run services describe hello-cloudrun --platform managed --region $REGION --format=json | jq --raw-output ".status.traffic[] | select (.tag==\"new-feature-1\")|.url")
echo $BRANCH_URL
curl -H "Authorization: Bearer $(gcloud auth print-identity-token)" $BRANCH_URL
sleep 60
gcloud beta builds triggers create cloud-source-repositories --trigger-config master-trigger.json
git checkout master
git merge new-feature-1
git push gcp master
CANARY_URL=$(gcloud run services describe hello-cloudrun --platform managed --region $REGION --format=json | jq --raw-output ".status.traffic[] | select (.tag==\"canary\")|.url")
echo $CANARY_URL
curl -H "Authorization: Bearer $(gcloud auth print-identity-token)" $CANARY_URL
LIVE_URL=$(gcloud run services describe hello-cloudrun --platform managed --region $REGION --format=json | jq --raw-output ".status.url")
for i in {0..20};do
curl -H "Authorization: Bearer $(gcloud auth print-identity-token)" $LIVE_URL; echo \n
done
gcloud beta builds triggers create cloud-source-repositories --trigger-config tag-trigger.json
git tag 1.1
git push gcp 1.1
for line in "${pattern[@]}"
do
    echo -e "${YELLOW}${line}${NC}"
done