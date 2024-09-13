
gcloud services enable run.googleapis.com

sleep 10

gcloud config set compute/region $LOCATION

gcloud run deploy store-service \
--image gcr.io/qwiklabs-resources/gsp724-store-service \
--region $LOCATION \
--allow-unauthenticated


sleep 10

gcloud run deploy order-service \
--image gcr.io/qwiklabs-resources/gsp724-order-service \
--region $LOCATION \
--no-allow-unauthenticated



gcloud pubsub topics create ORDER_PLACED


gcloud iam service-accounts create pubsub-cloud-run-invoker \
--display-name "Order Initiator"


gcloud iam service-accounts list --filter="Order Initiator"


gcloud run services add-iam-policy-binding order-service --region $LOCATION \
--member=serviceAccount:pubsub-cloud-run-invoker@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com \
--role=roles/run.invoker --platform managed

PROJECT_NUMBER=$(gcloud projects list \
--filter="qwiklabs-gcp" \
--format='value(PROJECT_NUMBER)')

gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT \
--member=serviceAccount:service-$PROJECT_NUMBER@gcp-sa-pubsub.iam.gserviceaccount.com \
--role=roles/iam.serviceAccountTokenCreator



ORDER_SERVICE_URL=$(gcloud run services describe order-service \
--region $LOCATION \
--format="value(status.address.url)")


gcloud pubsub subscriptions create order-service-sub \
--topic ORDER_PLACED \
--push-endpoint=$ORDER_SERVICE_URL \
--push-auth-service-account=pubsub-cloud-run-invoker@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com
