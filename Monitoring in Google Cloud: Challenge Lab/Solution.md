# Please like share & subscribe to [Abhi arcade solution](http://www.youtube.com/@Abhi_Arcade_Solution)

### Task 1: Run the following Commands in CloudShell

```
cat > prepare_disk.sh <<'EOF_END'

curl -sSO https://dl.google.com/cloudagents/add-logging-agent-repo.sh
sudo bash add-logging-agent-repo.sh --also-install

curl -sSO https://dl.google.com/cloudagents/add-monitoring-agent-repo.sh
sudo bash add-monitoring-agent-repo.sh --also-install

(cd /etc/stackdriver/collectd.d/ && sudo curl -O https://raw.githubusercontent.com/Stackdriver/stackdriver-agent-service-configs/master/etc/collectd.d/apache.conf)

sudo service stackdriver-agent restart

timeout 120 bash -c -- 'while true; do curl localhost; sleep $((RANDOM % 4)) ; done'

EOF_END

export ZONE=$(gcloud compute instances list apache-vm --format 'csv[no-heading](zone)')

gcloud compute scp prepare_disk.sh apache-vm:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet

gcloud compute ssh apache-vm --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet --command="bash /tmp/prepare_disk.sh"

sleep 60

cat > email-channel.json <<EOF_END
{
  "type": "email",
  "displayName": "quickgcplab",
  "description": "Awesome",
  "labels": {
    "email_address": "$USER_EMAIL"
  }
}
EOF_END

gcloud beta monitoring channels create --channel-content-from-file="email-channel.json"

# Get the channel ID
email_channel_info=$(gcloud beta monitoring channels list)
email_channel_id=$(echo "$email_channel_info" | grep -oP 'name: \K[^ ]+' | head -n 1)

# Create an email notification channel

# Create the alert policy

cat > stopped-vm-alert-policy.json <<EOF_END
{
  "displayName": "quick gcp lab",
  "userLabels": {},
  "conditions": [
    {
      "displayName": "VM Instance - Traffic",
      "conditionThreshold": {
        "filter": "resource.type = \"gce_instance\" AND metric.type = \"agent.googleapis.com/apache/traffic\"",
        "aggregations": [
          {
            "alignmentPeriod": "60s",
            "crossSeriesReducer": "REDUCE_NONE",
            "perSeriesAligner": "ALIGN_RATE"
          }
        ],
        "comparison": "COMPARISON_GT",
        "duration": "0s",
        "trigger": {
          "count": 1
        },
        "thresholdValue": 3072
      }
    }
  ],
  "alertStrategy": {},
  "combiner": "OR",
  "enabled": true,
  "notificationChannels": [
    "$email_channel_id"
  ],
  "severity": "SEVERITY_UNSPECIFIED"
}


EOF_END

# Create the alert policy
gcloud alpha monitoring policies create --policy-from-file=stopped-vm-alert-policy.json
```

### Task 2: Follow video
### Task 3: Follow video
### Task 4: Follow video

### Task 5: Create Log-based metric

1. Create Log-based metric `AbhiArcadeSolution`
2. Paste in `Build filter` & Replace PROJECT_ID
```
resource.type="gce_instance"
logName="projects/PROJECT_ID/logs/apache-access"
textPayload:"200"
```
3. Paste in `Regular Expression` field:
```
execution took (\d+)
```


## Congratulations !!
