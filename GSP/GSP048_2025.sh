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
cat > prepare_disk.sh <<'EOF_END'

gcloud services enable apikeys.googleapis.com

gcloud alpha services api-keys create --display-name="awesome" 

KEY_NAME=$(gcloud alpha services api-keys list --format="value(name)" --filter "displayName=awesome")

API_KEY=$(gcloud alpha services api-keys get-key-string $KEY_NAME --format="value(keyString)")

cat > request.json <<EOF

{
    "config": {
            "encoding":"FLAC",
            "languageCode": "en-US"
    },
    "audio": {
            "uri":"gs://cloud-samples-data/speech/brooklyn_bridge.flac"
    }
}

EOF

curl -s -X POST -H "Content-Type: application/json" --data-binary @request.json \
"https://speech.googleapis.com/v1/speech:recognize?key=${API_KEY}" > result.json

cat result.json

EOF_END
export ZONE=$(gcloud compute instances list linux-instance --format 'csv[no-heading](zone)')

gcloud compute scp prepare_disk.sh linux-instance:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet
gcloud compute ssh linux-instance --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet --command="bash /tmp/prepare_disk.sh"

read -p "CHECK MY PROGRESS DONE TILL TASK 3 (Y/N)?" response

if [[ "$response" =~ ^[Yy]$ ]]; then
        echo "Proceeding with next steps!"
else
        echo "Please check the progress before proceeding."
fi


cat > prepare_disk.sh <<'EOF_END'

KEY_NAME=$(gcloud alpha services api-keys list --format="value(name)" --filter "displayName=awesome")

API_KEY=$(gcloud alpha services api-keys get-key-string $KEY_NAME --format="value(keyString)")

rm -f request.json

cat >> request.json <<EOF

 {
    "config": {
            "encoding":"FLAC",
            "languageCode": "fr"
    },
    "audio": {
            "uri":"gs://cloud-samples-data/speech/corbeau_renard.flac"
    }
}

EOF

curl -s -X POST -H "Content-Type: application/json" --data-binary @request.json \
"https://speech.googleapis.com/v1/speech:recognize?key=${API_KEY}" > result.json

cat result.json

EOF_END

export ZONE=$(gcloud compute instances list linux-instance --format 'csv[no-heading](zone)')

gcloud compute scp prepare_disk.sh linux-instance:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet

gcloud compute ssh linux-instance --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet --command="bash /tmp/prepare_disk.sh"
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
