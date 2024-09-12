gcloud services disable pubsub.googleapis.com --force

gcloud services enable pubsub.googleapis.com

gcloud services enable run.googleapis.com

sleep 20

gcloud config set compute/LOCATION $LOCATION

 gcloud run deploy store-service \
  --image gcr.io/qwiklabs-resources/gsp724-store-service \
  --LOCATION $LOCATION \
  --allow-unauthenticated

 gcloud run deploy order-service \
  --image gcr.io/qwiklabs-resources/gsp724-order-service \
  --LOCATION $LOCATION \
  --no-allow-unauthenticated


gcloud pubsub topics create ORDER_PLACED

 gcloud iam service-accounts create pubsub-cloud-run-invoker \
  --display-name "Order Initiator"

gcloud iam service-accounts list --filter="Order Initiator"

sleep 20

 gcloud run services add-iam-policy-binding order-service --LOCATION $LOCATION \
  --member=serviceAccount:pubsub-cloud-run-invoker@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com \
  --role=roles/run.invoker --platform managed

 PROJECT_NUMBER=$(gcloud projects list \
  --filter="qwiklabs-gcp" \
  --format='value(PROJECT_NUMBER)')

sleep 20


 ORDER_SERVICE_URL=$(gcloud run services describe order-service \
   --LOCATION $LOCATION \
   --format="value(status.address.url)")


 gcloud pubsub subscriptions create order-service-sub \
   --topic ORDER_PLACED \
   --push-endpoint=$ORDER_SERVICE_URL \
   --push-auth-service-account=pubsub-cloud-run-invoker@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com
