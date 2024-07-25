gcloud services enable fitness.googleapis.com
export OAUTH2_TOKEN=$(gcloud auth print-access-token)
echo '{
  "name": "'"$DEVSHELL_PROJECT_ID"'-bucket-1",
  "location": "us",
  "storageClass": "multi_regional"
}
' > values.json
curl -X POST --data-binary @values.json \
    -H "Authorization: Bearer $OAUTH2_TOKEN" \
    -H "Content-Type: application/json" \
    "https://www.googleapis.com/storage/v1/b?project=$DEVSHELL_PROJECT_ID"
echo '{
  "name": "'"$DEVSHELL_PROJECT_ID"'-bucket-2",
  "location": "us",
  "storageClass": "multi_regional"
}' > values.json
curl -X POST --data-binary @values.json \
    -H "Authorization: Bearer $OAUTH2_TOKEN" \
    -H "Content-Type: application/json" \
    "https://www.googleapis.com/storage/v1/b?project=$DEVSHELL_PROJECT_ID"

