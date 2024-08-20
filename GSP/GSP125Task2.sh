export ZONE=$(gcloud compute instances list speaking-with-a-webpage --format 'csv[no-heading](zone)')

export VM_EXT_IP=$(gcloud compute instances describe speaking-with-a-webpage --zone=$ZONE \
  --format='get(networkInterfaces[0].accessConfigs[0].natIP)')
