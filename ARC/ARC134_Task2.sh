SA=$(gcloud iam service-accounts list --format="value(email)" --filter "displayName=devops")

echo $SA


gcloud compute instances create vm-2 --service-account=$SA --zone=$ZONE


cat > role-definition.yaml <<EOF
title: Custom Role
description: Custom role with cloudsql.instances.connect and cloudsql.instances.get permissions
includedPermissions:
- cloudsql.instances.connect
- cloudsql.instances.get
EOF


export PROJECT_ID=$(gcloud config get-value project)


gcloud iam roles create customRole --project=$PROJECT_ID --file=role-definition.yaml

gcloud iam service-accounts create bigquery-qwiklab --display-name bigquery-qwiklab

SSA=$(gcloud iam service-accounts list --format="value(email)" --filter "displayName=bigquery-qwiklab")

gcloud projects add-iam-policy-binding $PROJECT_ID --member=serviceAccount:$SSA --role=roles/bigquery.dataViewer

gcloud projects add-iam-policy-binding $PROJECT_ID --member=serviceAccount:$SSA --role=roles/bigquery.user


gcloud compute instances create bigquery-instance --service-account=$SSA --scopes=https://www.googleapis.com/auth/bigquery --zone=$ZONE
