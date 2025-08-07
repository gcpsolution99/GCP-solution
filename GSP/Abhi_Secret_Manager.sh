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
ZONE=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-zone])")
REGION=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-region])")
PROJECT_ID=$(gcloud config get-value project)

gcloud services enable secretmanager.googleapis.com run.googleapis.com artifactregistry.googleapis.com

gcloud secrets create arcade-secret --replication-policy=automatic

echo -n "t0ps3cr3t!" | gcloud secrets versions add arcade-secret --data-file=-

terraform init

cat > app.py <<EOF_END
import os
from flask import Flask, jsonify, request
from google.cloud import secretmanager
import logging

app = Flask(__name__)

# Configure logging
logging.basicConfig(level=logging.INFO)

# Initialize Secret Manager client
# The client will automatically use the service account credentials of the Cloud Run service
secret_manager_client = secretmanager.SecretManagerServiceClient()

# Hardcoded Project ID and Secret ID as per your request
SECRET_ID = "arcade-secret"   # Secret Identifier

@app.route('/')
def get_secret():
    """
    Retrieves the specified secret from Secret Manager and returns its payload.
    The SECRET_ID and PROJECT_ID are now hardcoded in the application.
    """
    if not SECRET_ID or not PROJECT_ID:
        logging.error("SECRET_ID or PROJECT_ID not configured (should be hardcoded).")
        return jsonify({"error": "Secret ID or Project ID not configured."}), 500

    secret_version_name = f"projects/{PROJECT_ID}/secrets/{SECRET_ID}/versions/latest"

    try:
        logging.info(f"Accessing secret: {secret_version_name}")
        # Access the secret version
        response = secret_manager_client.access_secret_version(request={"name": secret_version_name})
        secret_payload = response.payload.data.decode("UTF-8")

        # IMPORTANT: In a real application, you would process or use the secret
        # here, not return it directly in an HTTP response, especially if the
        # secret is sensitive. This example is for demonstration purposes only.
        return jsonify({"secret_id": SECRET_ID, "secret_value": secret_payload})

    except Exception as e:
        logging.error(f"Failed to retrieve secret '{SECRET_ID}': {e}")
        return jsonify({"error": f"Failed to retrieve secret: {str(e)}"}), 500

if __name__ == '__main__':
    # When running locally, Flask will use the hardcoded values directly.
    # In Cloud Run, these values are used without needing environment variables.
    app.run(host='0.0.0.0', port=int(os.environ.get('PORT', 8080)))
EOF_END


cat > requirements.txt <<EOF_END
Flask==3.*
google-cloud-secret-manager==2.*
EOF_END


sleep 20

FROM python:3.9-slim-buster

WORKDIR /app

COPY requirements.txt .
RUN pip3 install -r requirements.txt

COPY . .

CMD ["python3", "app.py"]

sleep 20

gcloud artifacts repositories create arcade-images --repository-format=docker --location=$REGION --description="Docker repository"

docker build -t us-west1-docker.pkg.dev/$PROJECT_ID/arcade-images/arcade-secret:latest .

docker run --rm -p 8080:8080 us-west1-docker.pkg.dev/$PROJECT_ID/arcade-images/arcade-secret:latest

sleep 20

docker push us-west1-docker.pkg.dev/$PROJECT_ID/arcade-images/arcade-secret:latest


gcloud iam service-accounts create arcade-service \
  --display-name="Arcade Service Account" \
  --description="Service account for Cloud Run application"

  gcloud secrets add-iam-policy-binding arcade-secret \
--member="serviceAccount:arcade-service@qwiklabs-gcp-04-920c0e8b7d64.iam.gserviceaccount.com" \
--role="roles/secretmanager.secretAccessor"


gcloud run deploy arcade-service \
  --image=us-west1-docker.pkg.dev/$PROJECT_ID/arcade-images/arcade-secret:latest \
  --region=us-west1 \
  --set-secrets SECRET_ENV_VAR=arcade-secret:latest \
  --service-account arcade-service@$PROJECT_ID.gserviceaccount.com \
  --allow-unauthenticated


  gcloud run services describe arcade-service --region=$REGION --format='value(status.url)'

  curl $(gcloud run services describe arcade-service --region=$REGION --format='value(status.url)') | jq

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
