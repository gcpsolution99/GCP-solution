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
gcloud auth list
gcloud config set compute/region $region
gcloud services disable dataflow.googleapis.com
gcloud services enable \
dataflow.googleapis.com \
cloudscheduler.googleapis.com
sleep 45
PROJECT_ID=$(gcloud config get-value project)
BUCKET_NAME="${PROJECT_ID}-bucket"
gsutil mb gs://$BUCKET_NAME
gcloud pubsub topics create $topic
if [ "$region" == "us-central1" ]; then
  gcloud app create --region us-central
elif [ "$region" == "europe-west1" ]; then
  gcloud app create --region europe-west
else
  gcloud app create --region "$region"
fi
gcloud scheduler jobs create pubsub publisher-job --schedule="* * * * *" \
    --topic=$topic --message-body="$message"
#!/bin/bash
while true; do
    if gcloud scheduler jobs run publisher-job --location="$region"; then
        echo "Command executed successfully. Now running next command.."
        break 
    else
        echo ""
        sleep 10 
    fi
done
cat > abhi.sh <<EOF_CP
#!/bin/bash
git clone https://github.com/GoogleCloudPlatform/python-docs-samples.git
cd python-docs-samples/pubsub/streaming-analytics
pip install -U -r requirements.txt
python PubSubToGCS.py \
--project=$PROJECT_ID \
--region=$region \
--input_topic=projects/$PROJECT_ID/topics/$topic \
--output_path=gs://$BUCKET_NAME/samples/output \
--runner=DataflowRunner \
--window_size=2 \
--num_shards=2 \
--temp_location=gs://$BUCKET_NAME/temp
EOF_CP
chmod +x abhi.sh
docker run -it -e DEVSHELL_PROJECT_ID=$DEVSHELL_PROJECT_ID -e BUCKET_NAME=$BUCKET_NAME -e PROJECT_ID=$PROJECT_ID -e region=$region -e topic=$topic -v $(pwd)/abhi.sh:/abhi.sh python:3.7 /bin/bash -c "/abhi.sh"
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
