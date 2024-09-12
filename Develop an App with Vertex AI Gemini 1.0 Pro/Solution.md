# Please like share & subscribe to [Abhi arcade solution](http://www.youtube.com/@Abhi_Arcade_Solution)

## Run in CloudShell and follow video:

```
export REGION=
```

## Command 1:

```
PROJECT_ID=$(gcloud config get-value project)
echo "PROJECT_ID=${PROJECT_ID}"
echo "REGION=${REGION}"
gcloud services enable cloudbuild.googleapis.com cloudfunctions.googleapis.com run.googleapis.com logging.googleapis.com storage-component.googleapis.com aiplatform.googleapis.com

sleep 10

mkdir ~/gemini-app
cd ~/gemini-app
python3 -m venv gemini-streamlit
source gemini-streamlit/bin/activate
```
## Command 2:
```
curl -LO raw.githubusercontent.com/gcpsolution99/GCP-solution/main/GSP/Gemini2.sh
sudo chmod +x Gemini2.sh
./Gemini2.sh
```
## Command 3:
```
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
```

## Congratulations !!
