gcloud services enable compute.googleapis.com
gcloud services enable notebooks.googleapis.com
gcloud services enable aiplatform.googleapis.com

sleep 20

gcloud notebooks instances create rl-quickstart \
--location=$zone \
--vm-image-family=tf-2-6-cu110-notebooks \
--vm-image-project=deeplearning-platform-release \
--machine-type=e2-standard-2


echo "----------------Like, share and Subscribe to abhi arcade solution------------------"
