gcloud config set compute/zone "ZONE"
export ZONE=$(gcloud config get compute/zone)

gcloud config set compute/region "REGION"
export REGION=$(gcloud config get compute/region)

gcloud services enable cloudfunctions.googleapis.com

sleep 10

curl -LO https://github.com/GoogleCloudPlatform/golang-samples/archive/main.zip

unzip main.zip

cd golang-samples-main/functions/codelabs/gopher

gcloud functions deploy HelloWorld --runtime go120 --trigger-http --region REGION

curl https://<REGION>-$GOOGLE_CLOUD_PROJECT.cloudfunctions.net/HelloWorld

gcloud functions deploy Gopher --runtime go120 --trigger-http --region REGION
