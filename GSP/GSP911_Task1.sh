gcloud services enable networkconnectivity.googleapis.com
export PROJECT_ID=$(gcloud config get-value project)

export PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} \
    --format="value(projectNumber)")

export 1st_zone=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-zone])")

export REGION_1=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-region])")

export REGION_2=$(echo "$ZONE_VALUE" | cut -d '-' -f 1-2)
gcloud compute networks delete default --quiet
gcloud compute networks create vpc-transit \
  --subnet-mode=custom \
  --bgp-routing-mode=global
gcloud compute networks create vpc-a --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional
gcloud compute networks subnets create vpc-a-sub1-use4 --range=10.20.10.0/24 --stack-type=IPV4_ONLY --network=vpc-a --region=$REGION_1
