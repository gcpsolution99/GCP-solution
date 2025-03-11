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
git clone https://github.com/GoogleCloudPlatform/ruby-docs-samples.git
cd ruby-docs-samples/run/rails
bundle install
INSTANCE_NAME=postgres-instance
DATABASE_NAME=mydatabase
gcloud services enable secretmanager.googleapis.com
gcloud services enable run.googleapis.com
gcloud sql instances create $INSTANCE_NAME \
  --database-version POSTGRES_12 \
  --tier db-g1-small \
  --region $REGION
gcloud sql databases create $DATABASE_NAME \
  --instance $INSTANCE_NAME

cat /dev/urandom | LC_ALL=C tr -dc '[:alpha:]'| fold -w 50 | head -n1 > dbpassword

 gcloud sql users create qwiklabs_user \
   --instance=$INSTANCE_NAME --password=$(cat dbpassword)

BUCKET_NAME=$DEVSHELL_PROJECT_ID-ruby
gsutil mb -l $REGION gs://$BUCKET_NAME
gsutil iam ch allUsers:objectViewer gs://$BUCKET_NAME
PASSWORD="$(cat ~/ruby-docs-samples/run/rails/dbpassword)"

if [ -z "$PASSWORD" ]; then
  echo ""
  exit 1
fi

EDITOR="sed -i -e '\$a\\gcp:\n  db_password: $PASSWORD'" bin/rails credentials:edit

gcloud secrets create rails_secret --data-file config/master.key

gcloud secrets describe rails_secret

gcloud secrets versions access latest --secret rails_secret

PROJECT_NUMBER=$(gcloud projects describe $DEVSHELL_PROJECT_ID --format='value(projectNumber)')

gcloud secrets add-iam-policy-binding rails_secret \
  --member serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com \
  --role roles/secretmanager.secretAccessor

 gcloud secrets add-iam-policy-binding rails_secret \
   --member serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com \
   --role roles/secretmanager.secretAccessor

cat << EOF > .env
PRODUCTION_DB_NAME: $DATABASE_NAME
PRODUCTION_DB_USERNAME: qwiklabs_user
CLOUD_SQL_CONNECTION_NAME: $DEVSHELL_PROJECT_ID:$REGION:$INSTANCE_NAME
GOOGLE_PROJECT_ID: $DEVSHELL_PROJECT_ID
STORAGE_BUCKET_NAME: $BUCKET_NAME
EOF

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com \
    --role roles/cloudsql.client

RUBY_VERSION=$(ruby -v | cut -d ' ' -f2 | cut -c1-3)
sed -i "/FROM/c\FROM ruby:$RUBY_VERSION-buster" Dockerfile

gcloud artifacts repositories create cloud-run-source-deploy --repository-format=docker --location=$REGION

gcloud services enable run.googleapis.com

APP_NAME=myrubyapp
gcloud builds submit --config cloudbuild.yaml \
    --substitutions _SERVICE_NAME=$APP_NAME,_INSTANCE_NAME=$INSTANCE_NAME,_REGION=$REGION,_SECRET_NAME=rails_secret --timeout=20m


 gcloud run deploy $APP_NAME \
     --platform managed \
     --region $REGION \
     --image $REGION-docker.pkg.dev/$DEVSHELL_PROJECT_ID/cloud-run-source-deploy/$APP_NAME \
     --add-cloudsql-instances $DEVSHELL_PROJECT_ID:$REGION:$INSTANCE_NAME \
     --allow-unauthenticated \
     --max-instances=3
