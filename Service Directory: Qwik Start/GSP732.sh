gcloud services enable servicedirectory.googleapis.com

sleep 10

gcloud beta service-directory namespaces create example-namespace --project=$DEVSHELL_PROJECT_ID --location=region
gcloud beta service-directory namespaces list --project=$DEVSHELL_PROJECT_ID --location=region
gcloud beta service-directory namespaces describe example-namespace --project=$DEVSHELL_PROJECT_ID --location=region


gcloud beta service-directory services create example-service --project=$DEVSHELL_PROJECT_ID --namespace=example-namespace --location=region
gcloud beta service-directory services list --project=$DEVSHELL_PROJECT_ID --namespace=example-namespace --location=region
gcloud beta service-directory services describe example-service --project=$DEVSHELL_PROJECT_ID --namespace=example-namespace --location=region

gcloud beta service-directory endpoints create example-endpoint \
--project=$DEVSHELL_PROJECT_ID \
--service=example-service \
--namespace=example-namespace \
--location=region \
--address=0.0.0.0 \
--port=80


gcloud beta service-directory endpoints list --project=$DEVSHELL_PROJECT_ID --service=example-service --namespace=example-namespace --location=region
gcloud beta service-directory endpoints describe --project=$DEVSHELL_PROJECT_ID my-endpoint --service=example-service --namespace=example-namespace --location=region 

gcloud dns
--project=$DEVSHELL_PROJECT_ID managed-zones create example-zone-name \
--description="abc" \
--dns-name="myzone.example.com." \
--visibility="private" \
--networks="https://compute.googleapis.com/compute/v1/projects/$DEVSHELL_PROJECT_ID/global/networks/default" \
--service-directory-namespace="https://servicedirectory.googleapis.com/v1/projects/$DEVSHELL_PROJECT_ID/locations/$REGION/namespaces/example-namespace"
