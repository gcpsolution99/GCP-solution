SERVICE_NAME='gemini-app-playground' 
AR_REPO='gemini-app-repo'

gcloud artifacts repositories create "$AR_REPO" --location="$REGION" --repository-format=Docker

gcloud auth configure-docker "$REGION-docker.pkg.dev"

gcloud builds submit --tag "$REGION-docker.pkg.dev/$PROJECT_ID/$AR_REPO/$SERVICE_NAME"

gcloud run deploy "$SERVICE_NAME" \
  --port=8080 \
  --image="$REGION-docker.pkg.dev/$PROJECT_ID/$AR_REPO/$SERVICE_NAME" \
  --allow-unauthenticated \
  --region=$REGION \
  --platform=managed  \
  --project=$PROJECT_ID \
  --set-env-vars=PROJECT_ID=$PROJECT_ID,REGION=$REGION

  echo "Congratulations !!"


  echo "Subscribe to abhi arcade solution"
