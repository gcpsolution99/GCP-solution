gcloud config set project $DEVSHELL_PROJECT_ID
gsutil mb gs://$DEVSHELL_PROJECT_ID-bucket
gsutil bucketpolicyonly set off gs://$DEVSHELL_PROJECT_ID-bucket
gsutil iam ch allUsers:objectViewer gs://$DEVSHELL_PROJECT_ID-bucket


curl -L -o demo-image.jpg https://raw.githubusercontent.com/gcpsolution99/GCP-solution/main/APIs%20Explorer%3A%20Qwik%20Start/demo-image.jpg

mv world.jpeg demo-image.jpg

gsutil cp demo-image.jpg  gs://$DEVSHELL_PROJECT_ID-bucket

gsutil acl ch -u allUsers:R gs://$DEVSHELL_PROJECT_ID-bucket/demo-image.jpg


