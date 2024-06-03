
export PROJECT_ID=$(gcloud config get-value project)

gsutil mb -l $REGION -c Standard gs://$PROJECT_ID

curl -O https://github.com/gcpsolution99/GCP-solution/blob/main/kitten.png

gsutil cp kitten.png gs://$PROJECT_ID/kitten.png

gsutil iam ch allUsers:objectViewer gs://$PROJECT_ID
