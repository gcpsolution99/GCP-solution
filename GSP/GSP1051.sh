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
gcloud services enable spanner.googleapis.com
gcloud services enable artifactregistry.googleapis.com
gcloud services enable containerregistry.googleapis.com
gcloud services enable run.googleapis.com

sleep 20

git clone https://github.com/GoogleCloudPlatform/training-data-analyst

cd training-data-analyst/courses/cloud-spanner/omegatrade/backend

cat > .env <<EOF_END
PROJECTID = $DEVSHELL_PROJECT_ID
INSTANCE = omegatrade-instance
DATABASE = omegatrade-db
JWT_KEY = w54p3Y?4dj%8Xqa2jjVC84narhe5Pk
EXPIRE_IN = 30d
EOF_END

npm install npm -g
npm install --loglevel=error

npm install npm latest

npm install --loglevel=error

docker build -t gcr.io/$DEVSHELL_PROJECT_ID/omega-trade/backend:v1 -f dockerfile.prod .

gcloud auth configure-docker --quiet

docker push gcr.io/$DEVSHELL_PROJECT_ID/omega-trade/backend:v1

gcloud run deploy omegatrade-backend --platform managed --region $REGION --image gcr.io/$DEVSHELL_PROJECT_ID/omega-trade/backend:v1 --memory 512Mi --allow-unauthenticated

unset SPANNER_EMULATOR_HOST
node seed-data.js

echo "✅✅✅✅   LAB COMPLETED   ✅✅✅✅"

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
