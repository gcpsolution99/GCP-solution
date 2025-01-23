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
export ZONE=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-zone])")
export REGION=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-region])")
gcloud services enable cloudscheduler.googleapis.com
gsutil cp -r gs://spls/gsp648 . && cd gsp648
export PROJECT_ID=$(gcloud config list --format 'value(core.project)' 2>/dev/null)
WORKDIR=$(pwd)
gcloud config set compute/region $REGION
export REGION=$REGION
export ZONE=$ZONE
cd $WORKDIR/unattached-pd
export ORPHANED_DISK=orphaned-disk
export UNUSED_DISK=unused-disk
gcloud compute disks create $ORPHANED_DISK --project=$PROJECT_ID --type=pd-standard --size=500GB --zone=$ZONE
gcloud compute disks create $UNUSED_DISK --project=$PROJECT_ID --type=pd-standard --size=500GB --zone=$ZONE
gcloud compute disks list
gcloud compute instances create disk-instance \
--zone=$ZONE \
--machine-type=e2-medium \
--disk=name=$ORPHANED_DISK,device-name=$ORPHANED_DISK,mode=rw,boot=no
gcloud compute disks describe $ORPHANED_DISK --zone=$ZONE --format=json | jq
gcloud compute instances detach-disk disk-instance --device-name=$ORPHANED_DISK --zone=$ZONE
gcloud compute disks describe $ORPHANED_DISK --zone=$ZONE --format=json | jq
cat $WORKDIR/unattached-pd/main.py | grep "(request)" -A 12
cat $WORKDIR/unattached-pd/main.py | grep "handle never" -A 11
cat $WORKDIR/unattached-pd/main.py | grep "handle detached" -A 32
sed -i "15c\project = '$DEVSHELL_PROJECT_ID'" main.py
gcloud services disable cloudfunctions.googleapis.com
gcloud services enable cloudfunctions.googleapis.com
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
--member="serviceAccount:$DEVSHELL_PROJECT_ID@appspot.gserviceaccount.com" \
--role="roles/artifactregistry.reader"
cd ~/gsp648/unattached-pd
gcloud functions deploy delete_unattached_pds --gen2 --trigger-http --runtime=python39 --region $REGION
export FUNCTION_URL=$(gcloud functions describe delete_unattached_pds --format=json --region $REGION | jq -r '.url')
gcloud app create --region=$REGION
gcloud app deploy
gcloud scheduler jobs create http unattached-pd-job \
--schedule="* 2 * * *" \
--uri=$FUNCTION_URL \
--location=$REGION
#!/bin/bash
running_function() {
  gcloud scheduler jobs run unattached-pd-job \
    --location="$REGION"
}
running_success=false
while [ "$running_success" = false ]; do
  if running_function; then
    echo "a"
    running_success=true
  else
    sleep 10
  fi
done
gcloud compute snapshots list
gcloud compute disks list
gcloud compute disks create $ORPHANED_DISK --project=$PROJECT_ID --type=pd-standard --size=500GB --zone=$ZONE
gcloud compute instances attach-disk disk-instance --device-name=$ORPHANED_DISK --disk=$ORPHANED_DISK --zone=$ZONE
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
