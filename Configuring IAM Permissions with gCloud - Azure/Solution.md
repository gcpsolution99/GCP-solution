# Please like share & subscribe to [Abhi arcade solution](http://www.youtube.com/@Abhi_Arcade_Solution)

## Run in SSH and follow video:

```
export ZONE_1=
export ZONE_2=
export SECOND_USER_NAME=
export SECOND_PROJECT_ID=
```

```
gcloud --version
gcloud auth login --no-launch-browser --quiet
```
## Configurations :
```
sudo yum install google-cloud-cli -y

gcloud config set compute/zone "$ZONE_1"
export ZONE=$(gcloud config get compute/zone)

gcloud config set compute/region "${ZONE_1%-*}"
export REGION=$(gcloud config get compute/region)


gcloud compute instances create lab-1 --zone=$ZONE

gcloud config set compute/zone $ZONE_2

gcloud init --no-launch-browser
```

### Select option 2 --> Enter user2 -- Select 1st project

```
curl -LO raw.githubusercontent.com/gcpsolution99/GCP-solution/main/GSP/GSP1119.sh

sudo chmod +x GSP1119.sh

./GSP1119.sh
```


## Congratulations !!
