gcloud alpha services api-keys create --display-name="AbhiArcade"  
KEY_NAME=$(gcloud alpha services api-keys list --format="value(name)" --filter "displayName=AbhiArcade") 
export API_KEY=$(gcloud alpha services api-keys get-key-string $KEY_NAME --format="value(keyString)") 
echo $API_KEY

gsutil mb gs://$DEVSHELL_PROJECT_ID

gsutil mb gs://$DEVSHELL_PROJECT_ID-AbhiArcade

gsutil cp demo-image1.png gs://$DEVSHELL_PROJECT_ID

gsutil cp demo-image2.png gs://$DEVSHELL_PROJECT_ID

gsutil cp demo-image1-copy.png gs://$DEVSHELL_PROJECT_ID-AbhiArcade

curl -LO https://github.com/gcpsolution99/GCP-solution/blob/main/APIs%20Explorer%20Cloud%20Storage/image1%20-%20Copy.png
curl -LO https://github.com/gcpsolution99/GCP-solution/blob/main/APIs%20Explorer%20Cloud%20Storage/image1.png
curl -LO https://github.com/gcpsolution99/GCP-solution/blob/main/APIs%20Explorer%20Cloud%20Storage/image2.png
