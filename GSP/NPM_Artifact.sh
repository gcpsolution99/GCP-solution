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
gcloud services enable artifactregistry.googleapis.com
export REGION=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-region])")
export PROJECT_ID=$(gcloud config get-value project)
gcloud config set compute/region $REGION
gcloud config set project $PROJECT_ID
gcloud artifacts repositories create my-npm-repo \
    --repository-format=npm \
    --location="$REGION" \
    --description="NPM repository"

mkdir my-npm-package
cd my-npm-package

npm init --scope=@"$PROJECT_ID" -y
echo 'console.log(`Hello from my-npm-package!`);' > index.js
gcloud artifacts print-settings npm \
    --project="$PROJECT_ID" \
    --repository=my-npm-repo \
    --location="$REGION" \
    --scope=@"$PROJECT_ID" > ./.npmrc

gcloud auth configure-docker "$REGION"-npm.pkg.dev

cat > package.json <<EOF
{
  "name": "@"$PROJECT_ID"/my-npm-package",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "artifactregistry-login": "npx google-artifactregistry-auth --repo-config=./.npmrc --credential-config=./.npmrc",
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "type": "commonjs"
}
EOF

npm run artifactregistry-login

cat .npmrc

npm publish --registry=https://"$REGION"-npm.pkg.dev/"$PROJECT_ID"/my-npm-repo/
gcloud artifacts packages list --repository=my-npm-repo --location="$REGION"
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
