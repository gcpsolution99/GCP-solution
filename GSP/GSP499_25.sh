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
export REGION=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-region])")

if [ -z "$REGION" ]; then
  echo ""
  echo ""
  read -p "Enter region: " REGION
fi

echo

gcloud services enable iap.googleapis.com
echo

gcloud auth list
echo

gcloud config list project
echo

gsutil cp gs://spls/gsp499/user-authentication-with-iap.zip .
echo

unzip user-authentication-with-iap.zip
echo

cd user-authentication-with-iap
echo

gcloud services enable appengineflex.googleapis.com
echo

cd 1-HelloWorld
echo

sed -i 's/python37/python39/g' app.yaml
echo

gcloud app create --region=$REGION
echo

deploy_function() {
  yes | gcloud app deploy
}

deploy_success=false
while [ "$deploy_success" = false ]; do
  echo ""
  if deploy_function; then
    echo ""
    deploy_success=true
  else
    echo ""
    for i in $(seq 10 -1 1); do
      echo -ne ""
      sleep 1
    done
    echo -e "\r Retrying now!             "
  fi
done
echo

cd ~/user-authentication-with-iap/2-HelloUser
echo

sed -i 's/python37/python39/g' app.yaml
echo

deploy_function() {
  yes | gcloud app deploy
}

deploy_success=false
while [ "$deploy_success" = false ]; do
  echo ""
  if deploy_function; then
    echo ""
    deploy_success=true
  else
    echo ""
    for i in $(seq 10 -1 1); do
      echo -ne ""
      sleep 1
    done
    echo -e "\r Retrying now!             "
  fi
done
echo

cd ~/user-authentication-with-iap/3-HelloVerifiedUser
echo

sed -i 's/python37/python39/g' app.yaml
echo

deploy_function() {
  yes | gcloud app deploy
}

deploy_success=false
while [ "$deploy_success" = false ]; do
  echo ""
  if deploy_function; then
    echo ""
    deploy_success=true
  else
    echo ""
    for i in $(seq 10 -1 1); do
      echo -ne ""
      sleep 1
    done
    echo -e "\r Retrying now!             "
  fi
done
echo

EMAIL="$(gcloud config get-value core/account)"
echo

LINK=$(gcloud app browse)

LINKU=${LINK#https://}
echo

cat > details.json << EOF
{
  App name: IAP Example
  Application home page: $LINK
  Application privacy Policy link: $LINK/privacy
  Authorized domains: $LINKU
  Developer Contact Information: $EMAIL
}
EOF
echo

cat details.json

echo "Open OAuth consent screen:"
echo "https://console.cloud.google.com/apis/credentials/consent?project=${PROJECT_ID}"
echo
echo " Open Identity-Aware Proxy:"
echo "https://console.cloud.google.com/security/iap?project=${PROJECT_ID}"

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
