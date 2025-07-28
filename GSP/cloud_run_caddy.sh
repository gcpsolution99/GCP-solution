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
export REGION=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-region])")
export PROJECT_ID=$(gcloud config get-value project)
gcloud config set compute/region "$REGION"
gcloud config set project "$PROJECT_ID"
gcloud services enable run.googleapis.com artifactregistry.googleapis.com cloudbuild.googleapis.com
gcloud artifacts repositories create caddy-repo --repository-format=docker --location="$REGION" --description="Docker repository for Caddy images"


cat > index.html <<EOF_CP
<html>
<head>
  <title>My Static Website</title>
</head>
<body>
  <div>Hello from Caddy on Cloud Run!</div>
  <p>This website is served by Caddy running in a Docker container on Google Cloud Run.</p>
</body>
</html>
EOF_CP


cat > Caddyfile <<EOF_CP
:8080
root * /usr/share/caddy
file_server
EOF_CP

cat > Dockerfile <<EOF_CP
FROM caddy:2-alpine

WORKDIR /usr/share/caddy

COPY index.html .
COPY Caddyfile /etc/caddy/Caddyfile
EOF_CP

docker build -t "$REGION"-docker.pkg.dev/"$PROJECT_ID"/caddy-repo/caddy-static:latest .
docker push "$REGION"-docker.pkg.dev/"$PROJECT_ID"/caddy-repo/caddy-static:latest
gcloud run deploy caddy-static --region=$REGION --image "$REGION"-docker.pkg.dev/"$PROJECT_ID"/caddy-repo/caddy-static:latest --platform managed --allow-unauthenticated
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
