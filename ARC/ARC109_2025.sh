#!/bin/bash
YELLOW='\033[0;33m'
NC='\033[0m' 
pattern=(
"**********************************************************"
"**                 S U B S C R I B E  TO                **"
"**                 ABHI ARCADE SOLUTION                 **"
"**                                                      **"
"**********************************************************"
)
for line in "${pattern[@]}"
do
    echo -e "${YELLOW}${line}${NC}"
done
echo -n "ENTER YOUR REGION:"
read REGION
export REGION=$REGION

gcloud services enable apigateway.googleapis.com --project=$DEVSHELL_PROJECT_ID

sleep 15
mkdir lol
cd lol

cat > index.js <<EOF
/**
 * Responds to any HTTP request.
 *
 * @param {!express:Request} req HTTP request context.
 * @param {!express:Response} res HTTP response context.
 */
exports.helloWorld = (req, res) => {
    let message = req.query.message || req.body.message || 'Hello World!';
    res.status(200).send(message);
};
EOF

cat > package.json <<EOF
{
    "name": "sample-http",
    "version": "0.0.1"
}
EOF

sleep 45

export PROJECT_NUMBER=$(gcloud projects describe $DEVSHELL_PROJECT_ID --format="json(projectNumber)" --quiet | jq -r '.projectNumber')

SERVICE_ACCOUNT=$(gsutil kms serviceaccount -p $PROJECT_NUMBER)

IAM_POLICY=$(gcloud projects get-iam-policy $DEVSHELL_PROJECT_ID --format=json)

if [[ "$IAM_POLICY" == *"$SERVICE_ACCOUNT"* && "$IAM_POLICY" == *"roles/artifactregistry.reader"* ]]; then
    echo "${GREEN_TEXT}${BOLD_TEXT}IAM binding exists:${RESET_FORMAT} $SERVICE_ACCOUNT with role roles/artifactregistry.reader"
else
    echo "${RED_TEXT}${BOLD_TEXT}IAM binding does not exist:${RESET_FORMAT} $SERVICE_ACCOUNT with role roles/artifactregistry.reader"
    
    echo "${CYAN_TEXT}${BOLD_TEXT}Creating IAM binding...${RESET_FORMAT}"
    gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member=serviceAccount:$SERVICE_ACCOUNT --role=roles/artifactregistry.reader

    echo "${GREEN_TEXT}${BOLD_TEXT}IAM binding created:${RESET_FORMAT} $SERVICE_ACCOUNT with role roles/artifactregistry.reader"
fi

gcloud functions deploy GCFunction --region=$REGION --runtime=nodejs22 --trigger-http --gen2 --allow-unauthenticated --entry-point=helloWorld --max-instances 5 --source=./

gcloud pubsub topics create demo-topic

cat > index.js <<EOF_CP
/**
 * Responds to any HTTP request.
 *
 * @param {!express:Request} req HTTP request context.
 * @param {!express:Response} res HTTP response context.
 */
const {PubSub} = require('@google-cloud/pubsub');
const pubsub = new PubSub();
const topic = pubsub.topic('demo-topic');
exports.helloWorld = (req, res) => {
    
    // Send a message to the topic
    topic.publishMessage({data: Buffer.from('Hello from Cloud Functions!')});
    res.status(200).send("Message sent to Topic demo-topic!");
};
EOF_CP

cat > package.json <<EOF_CP
{
    "name": "sample-http",
    "version": "0.0.1",
    "dependencies": {
        "@google-cloud/pubsub": "^3.4.1"
    }
}
EOF_CP

gcloud functions deploy GCFunction --region=$REGION --runtime=nodejs22 --trigger-http --gen2 --allow-unauthenticated --entry-point=helloWorld --max-instances 5 --source=./

cat > openapispec.yaml <<EOF_CP
swagger: '2.0'
info:
    title: GCFunction API
    description: Sample API on API Gateway with a Google Cloud Functions backend
    version: 1.0.0
schemes:
    - https
produces:
    - application/json
paths:
    /GCFunction:
        get:
            summary: gcfunction
            operationId: gcfunction
            x-google-backend:
                address: https://$REGION-$DEVSHELL_PROJECT_ID.cloudfunctions.net/GCFunction
            responses:
             '200':
                    description: A successful response
                    schema:
                        type: string
EOF_CP

export PROJECT_NUMBER=$(gcloud projects describe $DEVSHELL_PROJECT_ID --format="value(projectNumber)")
export API_ID="gcfunction-api-$(cat /dev/urandom | tr -dc 'a-z' | fold -w ${1:-8} | head -n 1)"
gcloud api-gateway apis create $API_ID --project=$DEVSHELL_PROJECT_ID
gcloud api-gateway api-configs create gcfunction-api --api=$API_ID --openapi-spec=openapispec.yaml --project=$DEVSHELL_PROJECT_ID --backend-auth-service-account=$PROJECT_NUMBER-compute@developer.gserviceaccount.com
gcloud api-gateway gateways create gcfunction-api --api=$API_ID --api-config=gcfunction-api --location=$REGION --project=$DEVSHELL_PROJECT_ID
pattern=(
"**********************************************************"
"**                 S U B S C R I B E  TO                **"
"**                 ABHI ARCADE SOLUTION                 **"
"**                                                      **"
"**********************************************************"
)
for line in "${pattern[@]}"
do
    echo -e "${YELLOW}${line}${NC}"
done
