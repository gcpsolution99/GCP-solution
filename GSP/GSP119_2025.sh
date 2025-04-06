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

gcloud alpha services api-keys create --display-name="abhi"

KEY_NAME=$(gcloud alpha services api-keys list --format="value(name)" --filter="displayName=abhi")

export API_KEY=$(gcloud alpha services api-keys get-key-string "$KEY_NAME" --format="value(keyString)")

gcloud services enable speech.googleapis.com
gcloud services enable apikeys.googleapis.com

echo "export API_KEY='${API_KEY}'" > /tmp/cp_disk.sh

cat > cp_env.sh <<EOF
KEY_NAME=\$(gcloud alpha services api-keys list --format="value(name)" --filter="displayName=abhi")
export API_KEY=\$(gcloud alpha services api-keys get-key-string "\$KEY_NAME" --format="value(keyString)")
EOF


echo "export API_KEY='${API_KEY}'" > /tmp/cp_env.sh

cat > cp_disk.sh <<'EOF_CP'
cat > request.json <<EOF
{
  "config": {
    "encoding": "FLAC",
    "languageCode": "en-US"
  },
  "audio": {
    "uri": "gs://cloud-samples-tests/speech/brooklyn.flac"
  }
}
EOF

# Load the API key
source /tmp/cp_env.sh

# Make the API call and display the response
curl -s -X POST -H "Content-Type: application/json" --data-binary @request.json \
"https://speech.googleapis.com/v1/speech:recognize?key=${API_KEY}"

# Save the response to result.json
curl -s -X POST -H "Content-Type: application/json" --data-binary @request.json \
"https://speech.googleapis.com/v1/speech:recognize?key=${API_KEY}" > result.json
EOF_CP

ZONE=$(gcloud compute instances list --project="$DEVSHELL_PROJECT_ID" --filter="name=('linux-instance')" --format="value(zone)")

gcloud compute scp cp_env.sh cp_disk.sh linux-instance:/tmp --project="$DEVSHELL_PROJECT_ID" --zone="$ZONE" --quiet

gcloud compute ssh linux-instance --project="$DEVSHELL_PROJECT_ID" --zone="$ZONE" --quiet --command="bash /tmp/cp_disk.sh"

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
