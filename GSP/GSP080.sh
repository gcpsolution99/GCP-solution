gcloud config set compute/region $REGION

mkdir gcf_hello_world

cd gcf_hello_world

cat > index.js <<'EOF_END'
/**
* Background Cloud Function to be triggered by Pub/Sub.
* This function is exported by index.js, and executed when
* the trigger topic receives a message.
*
* @param {object} data The event payload.
* @param {object} context The event metadata.
*/
exports.helloWorld = (data, context) => {
    const pubSubMessage = data;
    const name = pubSubMessage.data
        ? Buffer.from(pubSubMessage.data, 'base64').toString() : "Hello World";
    
    console.log(`My Cloud Function: ${name}`);
    };
EOF_END


gsutil mb -p $DEVSHELL_PROJECT_ID gs://$DEVSHELL_PROJECT_ID

gcloud services disable cloudfunctions.googleapis.com

gcloud services enable cloudfunctions.googleapis.com

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
--member="serviceAccount:$DEVSHELL_PROJECT_ID@appspot.gserviceaccount.com" \
--role="roles/artifactregistry.reader"

sleep 20

deploy_function() {
  gcloud functions deploy helloWorld \
  --stage-bucket gs://$DEVSHELL_PROJECT_ID \
  --trigger-topic hello_world \
  --runtime nodejs20 \
    --quiet
}


# Loop until the Cloud Run service is created
while true; do
  # Run the deployment command
  deploy_function

  # Check if Cloud Run service is created
  if gcloud functions describe helloWorld --format="value(state)" > /dev/null 2>&1; then
    echo "Cloud Functions is created. Exiting the loop."
    break
  else
    echo "Waiting for Cloud Functions to be created..."
    sleep 30
  fi
done
