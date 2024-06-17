gcloud alpha services api-keys create --display-name="Abhi"  
KEY_NAME=$(gcloud alpha services api-keys list --format="value(name)" --filter "displayName=Abhi") 
export API_KEY=$(gcloud alpha services api-keys get-key-string $KEY_NAME --format="value(keyString)") 
echo $API_KEY

gsutil mb gs://$DEVSHELL_PROJECT_ID

gsutil mb gs://$DEVSHELL_PROJECT_ID-abhi

gsutil cp demo-image1.png gs://$DEVSHELL_PROJECT_ID

gsutil cp demo-image2.png gs://$DEVSHELL_PROJECT_ID

gsutil cp demo-image1%20-%20Copy.png gs://$DEVSHELL_PROJECT_ID-abhi

curl -LO raw.githubusercontent.com/gcpsolution99/GCP-solution/main/APIs%20Explorer%20Cloud%20Storage/demo-image1%20-%20Copy.png
curl -LO raw.githubusercontent.com/gcpsolution99/GCP-solution/main/APIs%20Explorer%20Cloud%20Storage/demo-image1.png
curl -LO raw.githubusercontent.com/gcpsolution99/GCP-solution/main/APIs%20Explorer%20Cloud%20Storage/demo-image2.png
