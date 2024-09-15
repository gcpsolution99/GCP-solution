export REGION="${location%-*}"

gcloud services enable cloudscheduler.googleapis.com

git clone https://github.com/GoogleCloudPlatform/gcf-automated-resource-cleanup.git && cd gcf-automated-resource-cleanup/

export PROJECT_ID=$(gcloud config list --format 'value(core.project)' 2>/dev/null)
WORKDIR=$(pwd)

cd $WORKDIR/unused-ip

export USED_IP=used-ip-address
export UNUSED_IP=unused-ip-address

gcloud compute addresses create $USED_IP --project=$PROJECT_ID --region=$REGION
gcloud compute addresses create $UNUSED_IP --project=$PROJECT_ID --region=$REGION

gcloud compute addresses list --filter="region:($REGION)"

export USED_IP_ADDRESS=$(gcloud compute addresses describe $USED_IP --region=$REGION --format=json | jq -r '.address')

gcloud compute instances create static-ip-instance \
--location=$location \
--machine-type=e2-medium \
--subnet=default \
--address=$USED_IP_ADDRESS

gcloud compute addresses list --filter="region:($REGION)"

cat $WORKDIR/unused-ip/function.js | grep "const compute" -A 31

gcloud services disable cloudfunctions.googleapis.com

sleep 5

gcloud services enable cloudfunctions.googleapis.com

gcloud projects add-iam-policy-binding $PROJECT_ID \
--member="serviceAccount:$PROJECT_ID@appspot.gserviceaccount.com" \
--role="roles/artifactregistry.reader"

sleep 60

gcloud functions deploy unused_ip_function \
    --runtime nodejs12 \
    --region $REGION \
    --trigger-http \
    --allow-unauthenticated

export FUNCTION_URL=$(gcloud functions describe unused_ip_function --region=$REGION --format=json | jq -r '.httpsTrigger.url')

gcloud app create --region $REGION

gcloud scheduler jobs create http unused-ip-job \
--schedule="* 2 * * *" \
--uri=$FUNCTION_URL \
--location=$REGION

gcloud scheduler jobs run unused-ip-job \
--location=$REGION

gcloud compute addresses list --filter="region:($REGION)"

gcloud scheduler jobs run unused-ip-job \
--location=$REGION
