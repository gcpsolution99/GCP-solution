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
git clone --depth 1 https://github.com/GoogleCloudPlatform/training-data-analyst.git
cd ~/training-data-analyst/courses/design-process/deploying-apps-to-gcp
sudo pip install -r requirements.txt
echo "runtime: python39" > app.yaml
gcloud app create --region=$LOCATION
gcloud app deploy --version=one --quiet
cat > pubsub-channel.json <<EOF_END
    {
      "type": "pubsub",
      "displayName": "a",
      "description": "a",
      "labels": {
        "topic": "projects/$DEVSHELL_PROJECT_ID/topics/notificationTopic"
      },
    }
EOF_END
gcloud beta monitoring channels create --channel-content-from-file="pubsub-channel.json"
channel_info=$(gcloud beta monitoring channels list)
channel_id=$(echo "$channel_info" | grep -oP 'name: \K[^ ]+' | head -n 1)
cat > app-engine-error-percent-policy.json <<EOF_END
{
  "displayName": "Hello too slow",
  "userLabels": {},
  "conditions": [
    {
      "displayName": "Response latency [MEAN] for 99th% over 8s",
      "conditionThreshold": {
        "filter": "resource.type = \"gae_app\" AND metric.type = \"appengine.googleapis.com/http/server/response_latencies\"",
        "aggregations": [
          {
            "alignmentPeriod": "60s",
            "crossSeriesReducer": "REDUCE_NONE",
            "perSeriesAligner": "ALIGN_PERCENTILE_99"
          }
        ],
        "comparison": "COMPARISON_GT",
        "duration": "0s",
        "trigger": {
          "count": 1
        },
        "thresholdValue": 8000
      }
    }
  ],
  "alertStrategy": {
    "autoClose": "604800s"
  },
  "combiner": "OR",
  "enabled": true,
  "notificationChannels": [
    "$channel_id"
  ]
}
EOF_END
cd ~/training-data-analyst/courses/design-process/deploying-apps-to-gcp
gcloud alpha monitoring policies create --policy-from-file="app-engine-error-percent-policy.json"
cat > main.py <<EOF_END
from flask import Flask, render_template, request
import time
import random
import json
app = Flask(__name__)

@app.route("/")
def main():
    model = {"title": "Hello GCP."}
    time.sleep(10)
    return render_template('index.html', model=model)
EOF_END
gcloud app deploy --version=two --quiet
while true; do curl -s https://$DEVSHELL_PROJECT_ID.appspot.com/ | grep -e "<title>" -e "error";sleep .$[( $RANDOM % 10 )]s;done
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
