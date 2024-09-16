echo "*** Started ***"

gsutil mb gs://$DEVSHELL_PROJECT_ID

gsutil cp gs://sureskills-ql/challenge-labs/ch01-startup-script/install-web.sh gs://$DEVSHELL_PROJECT_ID

gcloud compute instances create abhiarcade --project=$DEVSHELL_PROJECT_ID --zone=$zone --machine-type=n1-standard-1 --tags=http-server --metadata startup-script-url=gs://$DEVSHELL_PROJECT_ID/install-web.sh

gcloud compute firewall-rules create allow-http \
    --allow=tcp:80 \
    --description="awesome lab" \
    --direction=INGRESS \
    --target-tags=http-server

echo "*** Completed !! ***"
