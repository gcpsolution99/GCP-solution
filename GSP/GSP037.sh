gcloud alpha services api-keys create --display-name="awesome" 

KEY_NAME=$(gcloud alpha services api-keys list --format="value(name)" --filter "displayName=awesome")

export API_KEY=$(gcloud alpha services api-keys get-key-string $KEY_NAME --format="value(keyString)")

export PROJECT_ID=$(gcloud config list --format 'value(core.project)')

gsutil mb gs://$PROJECT_ID

curl -LO raw.githubusercontent.com/gcpsolution99/GCP-solution/main/city.png

curl -LO raw.githubusercontent.com/gcpsolution99/GCP-solution/main/donuts.png

curl -LO raw.githubusercontent.com/gcpsolution99/GCP-solution/main/selfie.png

gsutil cp donuts.png gs://$PROJECT_ID

gsutil cp selfie.png gs://$PROJECT_ID

gsutil cp city.png gs://$PROJECT_ID

gsutil acl ch -u AllUsers:R gs://$PROJECT_ID/donuts.png

gsutil acl ch -u AllUsers:R gs://$PROJECT_ID/selfie.png

gsutil acl ch -u AllUsers:R gs://$PROJECT_ID/city.png
