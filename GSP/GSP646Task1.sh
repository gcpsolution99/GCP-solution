gcloud services enable cloudscheduler.googleapis.com
git clone https://github.com/GoogleCloudPlatform/gcf-automated-resource-cleanup.git && cd gcf-automated-resource-cleanup/
export PROJECT_ID=$(gcloud config list --format 'value(core.project)' 2>/dev/null)
export region=us-central1
WORKDIR=$(pwd)
cd $WORKDIR/unused-ip
export USED_IP=used-ip-address
export UNUSED_IP=unused-ip-address
gcloud compute addresses create $USED_IP --project=$PROJECT_ID --region=us-central1
sleep 5
gcloud compute addresses create $UNUSED_IP --project=$PROJECT_ID --region=us-central1
gcloud compute addresses list --filter="region:(us-central1)"
export USED_IP_ADDRESS=$(gcloud compute addresses describe $USED_IP --region=us-central1 --format=json | jq -r '.address')
gcloud compute instances create static-ip-instance \
--zone=us-central1-a \
--machine-type=n1-standard-1 \
--subnet=default \
--address=$USED_IP_ADDRESS
gcloud functions deploy unused_ip_function --trigger-http --runtime=nodejs12 --region=us-central1
