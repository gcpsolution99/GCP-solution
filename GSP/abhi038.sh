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
gcloud services enable apikeys.googleapis.com
export ZONE=$(gcloud compute instances list --filter="name=('linux-instance')" --format="value(zone)")
gcloud alpha services api-keys create --display-name="abhi"
KEY_NAME=$(gcloud alpha services api-keys list --format="value(name)" --filter="displayName=abhi")
API_KEY=$(gcloud alpha services api-keys get-key-string $KEY_NAME --format="value(keyString)")

cat > abhi.sh <<EOF_CP
KEY_NAME=$(gcloud alpha services api-keys list --format="value(name)" --filter="displayName=abhi")

API_KEY=$(gcloud alpha services api-keys get-key-string $KEY_NAME --format="value(keyString)")

echo $API_KEY

cat > request.json <<EOF
{
  "document":{
    "type":"PLAIN_TEXT",
    "content":"Joanne Rowling, who writes under the pen names J. K. Rowling and Robert Galbraith, is a British novelist and screenwriter who wrote the Harry Potter fantasy series."
  },
  "encodingType":"UTF8"
}
EOF

curl "https://language.googleapis.com/v1/documents:analyzeEntities?key=${API_KEY}" \
  -s -X POST -H "Content-Type: application/json" --data-binary @request.json > result.json

cat result.json
EOF_CP

gcloud compute scp abhi.sh linux-instance:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet
gcloud compute ssh linux-instance --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet --command="bash /tmp/abhi.sh"
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
