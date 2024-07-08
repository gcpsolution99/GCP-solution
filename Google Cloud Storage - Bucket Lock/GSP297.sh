gcloud config set compute/region $REGION
export BUCKET=$(gcloud config get-value project)
gsutil mb "gs://$BUCKET"
gsutil retention set 10s "gs://$BUCKET"
gsutil cp gs://spls/gsp297/dummy_transactions "gs://$BUCKET/"
gsutil retention lock "gs://$BUCKET/"
gsutil retention temp set "gs://$BUCKET/dummy_transactions"
gsutil retention temp release "gs://$BUCKET/dummy_transactions"
gsutil retention event-default set "gs://$BUCKET/"
gsutil cp gs://spls/gsp297/dummy_loan "gs://$BUCKET/"
gsutil retention event release "gs://$BUCKET/dummy_loan"
