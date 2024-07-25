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


    sleep 10


    curl -X POST --data-binary @/home/gcpstaging25084_student/demo-image.png \
    -H "Authorization: Bearer $OAUTH2_TOKEN" \
    -H "Content-Type: image/png" \
    "https://www.googleapis.com/upload/storage/v1/b/$DEVSHELL_PROJECT_ID-bucket-1/o?uploadType=media&name=demo-image"
curl -X POST \
  -H "Authorization: Bearer $OAUTH2_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "destination": "gs://$DEVSHELL_PROJECT_ID-bucket-2/demo-image"
   }' \
   "https://storage.googleapis.com/storage/v1/b/$DEVSHELL_PROJECT_ID-bucket-1/o/demo-image/copyTo/b/$DEVSHELL_PROJECT_ID-bucket-2/o/demo-image"
echo '{
  "entity": "allUsers",
  "role": "READER"
}
' > values.json
curl -X POST --data-binary @values.json \
  -H "Authorization: Bearer $OAUTH2_TOKEN" \
  -H "Content-Type: application/json" \
  "https://storage.googleapis.com/storage/v1/b/$DEVSHELL_PROJECT_ID-bucket-1/o/demo-image/acl"
curl -X DELETE \
  -H "Authorization: Bearer $OAUTH2_TOKEN" \
  "https://storage.googleapis.com/storage/v1/b/gs://$DEVSHELL_PROJECT_ID-bucket-1/o/demo-image"
curl -X DELETE \
  -H "Authorization: Bearer $OAUTH2_TOKEN" \
  "https://storage.googleapis.com/storage/v1/b/$DEVSHELL_PROJECT_ID-bucket-1/o/demo-image"
curl -X DELETE \
  -H "Authorization: Bearer $OAUTH2_TOKEN" \
  "https://storage.googleapis.com/storage/v1/b/$DEVSHELL_PROJECT_ID-bucket-1"
