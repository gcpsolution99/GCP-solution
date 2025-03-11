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
export REGION=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-region])")

gcloud services enable iap.googleapis.com

gcloud config set project $DEVSHELL_PROJECT_ID

git clone https://github.com/GoogleCloudPlatform/python-docs-samples.git

cd python-docs-samples/appengine/standard_python3/hello_world/

gcloud app create --project=$(gcloud config get-value project) --region=$REGION

gcloud app deploy --quiet

export AUTH_DOMAIN=$(gcloud config get-value project).uc.r.appspot.com

EMAIL="$(gcloud config get-value core/account)"

cat > details.json << EOF
  App name: AbhiArcadeSolution
  Contact email: $EMAIL
EOF

cat details.json

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
