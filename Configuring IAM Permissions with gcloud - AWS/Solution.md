# Please like share & subscribe to [Abhi arcade solution](http://www.youtube.com/@Abhi_Arcade_Solution)

## Run in CloudShell and follow video:

```
export ZONE=$(gcloud compute instances list debian-clean --format 'csv[no-heading](zone)')
gcloud compute ssh debian-clean --zone=$ZONE --quiet
```

### Run in SSH
```
export USER2=
export PROJECT2=
```

```
export ZONE=$(gcloud compute instances list debian-clean --format 'csv[no-heading](zone)')
gcloud --version
gcloud auth login --no-launch-browser --quiet
```

## configuration :

```
curl -LO raw.githubusercontent.com/gcpsolution99/GCP-solution/main/GSP/GSP1126.sh
sudo chmod +x GSP1126.sh
./GSP1126.sh
```

## Enter below text:
```
user2
```

## Create compute instance

```
gcloud compute instances create lab-2 --machine-type=e2-standard-2
gcloud config configurations activate default
gcloud config configurations activate user2
echo "export PROJECTID2=$PROJECT2" >> ~/.bashrc
. ~/.bashrc
gcloud config set project $PROJECTID2 --quiet
gcloud config configurations activate default
sudo apt -y install jq
echo "export USERID2=$USER2" >> ~/.bashrc
. ~/.bashrc
gcloud projects add-iam-policy-binding $PROJECTID2 --member user:$USERID2 --role=roles/viewer
gcloud config configurations activate user2
gcloud config set project $PROJECTID2
gcloud compute instances create lab-2 --machine-type=e2-standard-2
gcloud config configurations activate default
gcloud iam roles create devops --project $PROJECTID2 --permissions "compute.instances.create,compute.instances.delete,compute.instances.start,compute.instances.stop,compute.instances.update,compute.disks.create,compute.subnetworks.use,compute.subnetworks.useExternalIp,compute.instances.setMetadata,compute.instances.setServiceAccount"
gcloud projects add-iam-policy-binding $PROJECTID2 --member user:$USERID2 --role=roles/iam.serviceAccountUser
gcloud projects add-iam-policy-binding $PROJECTID2 --member user:$USERID2 --role=projects/$PROJECTID2/roles/devops
gcloud config configurations activate user2
gcloud compute instances create lab-2 --machine-type=e2-standard-2
gcloud config configurations activate default
gcloud config set project $PROJECTID2
gcloud iam service-accounts create devops --display-name devops
gcloud iam service-accounts list  --filter "displayName=devops"
SA=$(gcloud iam service-accounts list --format="value(email)" --filter "displayName=devops")
gcloud projects add-iam-policy-binding $PROJECTID2 --member serviceAccount:$SA --role=roles/iam.serviceAccountUser
gcloud projects add-iam-policy-binding $PROJECTID2 --member serviceAccount:$SA --role=roles/compute.instanceAdmin
gcloud compute instances create lab-3 --machine-type=e2-standard-2 --service-account $SA --scopes "https://www.googleapis.com/auth/compute"
```

## Congratulations !!
