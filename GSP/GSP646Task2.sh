export FUNCTION_URL=$(gcloud functions describe unused_ip_function --format=json | jq -r '.httpsTrigger.url')
gcloud app create --region us-central
gcloud scheduler jobs create http unused-ip-job \
--schedule="* 2 * * *" \
--uri=$FUNCTION_URL \
--location=us-central1
gcloud scheduler jobs run unused-ip-job \
--location=us-central1
gcloud compute addresses list --filter="region:(us-central1)"
