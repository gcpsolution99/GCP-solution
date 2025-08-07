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
PROJECT_ID=$(gcloud config get-value project)
REGION=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-region])")

gcloud compute networks create xall-vpc--vpc-01 \
    --description="Standard VPC network" \
    --project=$PROJECT_ID \
    --subnet-mode=custom \
    --bgp-routing-mode=global \
    --mtu=1460

gcloud compute networks subnets create xgl-subnet--cerps-bau-nonprd--be1-01 \
    --description="Subnet for backend workloads" \
    --project=$PROJECT_ID \
    --network=xall-vpc--vpc-01 \
    --region=$REGION \
    --range=10.1.1.0/24 \
    --enable-private-ip-google-access \
    --enable-flow-logs

gcloud compute firewall-rules create xall-vpc--vpc-01--xall-fw--user--a--linux--v01 \
    --description="Allow SSH & ICMP for Linux VMs" \
    --project=$PROJECT_ID \
    --network=xall-vpc--vpc-01 \
    --priority=1000 \
    --direction=ingress \
    --action=allow \
    --target-tags=xall-vpc--vpc-01--xall-fw--user--a--linux--v01 \
    --source-ranges=0.0.0.0/0 \
    --rules=tcp:22,icmp
    
gcloud compute firewall-rules create xall-vpc--vpc-01--xall-fw--user--a--windows--v01 \
    --description="Allow RDP & ICMP for Windows VMs" \
    --project=$PROJECT_ID \
    --network=xall-vpc--vpc-01 \
    --priority=1000 \
    --direction=ingress \
    --action=allow \
    --target-tags=xall-vpc--vpc-01--xall-fw--user--a--windows--v01 \
    --source-ranges=0.0.0.0/0 \
    --rules=tcp:3389,icmp

gcloud compute firewall-rules create xall-vpc--vpc-01--xall-fw--user--a--sapgui--v01 \
    --description="Allow SAP GUI Ports" \
    --project=$PROJECT_ID \
    --network=xall-vpc--vpc-01 \
    --priority=1000 \
    --direction=ingress \
    --action=allow \
    --target-tags=xall-vpc--vpc-01--xall-fw--user--a--sapgui--v01 \
    --source-ranges=0.0.0.0/0 \
    --rules=tcp:3200-3299,tcp:3600-3699

gcloud compute firewall-rules create xall-vpc--vpc-01--xall-fw--user--a--sap-fiori--v01 \
    --description="Allow SAP Fiori Ports" \
    --project=$PROJECT_ID \
    --network=xall-vpc--vpc-01 \
    --priority=1000 \
    --direction=ingress \
    --action=allow \
    --target-tags=xall-vpc--vpc-01--xall-fw--user--a--sap-fiori--v01 \
    --source-ranges=0.0.0.0/0 \
    --rules=tcp:80,tcp:8000-8099,tcp:443,tcp:4300-44300

gcloud compute firewall-rules create xall-vpc--vpc-01--xgl-fw--cerps-bau-dev--a-env--v01 \
    --description="Allow internal communication across environments" \
    --project=$PROJECT_ID \
    --network=xall-vpc--vpc-01 \
    --priority=1000 \
    --direction=ingress \
    --action=allow \
    --target-tags=xall-vpc--vpc-01--xgl-fw--cerps-bau-dev--a-env--v01 \
    --source-tags=xall-vpc--vpc-01--xgl-fw--cerps-bau-dev--a-env--v01 \
    --rules=tcp:3200-3299,tcp:3300-3399,tcp:4800-4899,tcp:80,tcp:8000-8099,tcp:443,tcp:44300-44399,tcp:3600-3699,tcp:8100-8199,tcp:44400-44499,tcp:50000-59999,tcp:30000-39999,tcp:4300-4399,tcp:40000-49999,tcp:1128-1129,tcp:5050,tcp:8000-8499,tcp:515,icmp

gcloud compute firewall-rules create xall-vpc--vpc-01--xgl-fw--cerps-bau-dev--a-ds4--v01 \
    --description="Allow all TCP/UDP/ICMP for DS4 system" \
    --project=$PROJECT_ID \
    --network=xall-vpc--vpc-01 \
    --priority=1000 \
    --direction=ingress \
    --action=allow \
    --target-tags=xall-vpc--vpc-01--xgl-fw--cerps-bau-dev--a-ds4--v01 \
    --source-tags=xall-vpc--vpc-01--xgl-fw--cerps-bau-dev--a-ds4--v01 \
    --rules=tcp,udp,icmp

gcloud compute addresses create xgl-ip-address--cerps-bau-dev--dh1--d-cerpshana1 \
    --description="Reserved IP for cerpshana1 VM" \
    --project=$PROJECT_ID \
    --region=$REGION \
    --subnet=xgl-subnet--cerps-bau-nonprd--be1-01 \
    --addresses=10.1.1.100

gcloud compute addresses create xgl-ip-address--cerps-bau-dev--ds4--d-cerpss4db \
    --description="Reserved IP for cerpss4db VM" \
    --project=$PROJECT_ID \
    --region=$REGION \
    --subnet=xgl-subnet--cerps-bau-nonprd--be1-01 \
    --addresses=10.1.1.101

gcloud compute addresses create xgl-ip-address--cerps-bau-dev--ds4--d-cerpss4scs \
    --description="Reserved IP for cerpss4scs VM" \
    --project=$PROJECT_ID \
    --region=$REGION \
    --subnet=xgl-subnet--cerps-bau-nonprd--be1-01 \
    --addresses=10.1.1.102

gcloud compute addresses create xgl-ip-address--cerps-bau-dev--ds4--d-cerpss4app1 \
    --description="Reserved IP for cerpss4app1 VM" \
    --project=$PROJECT_ID \
    --region=$REGION \
    --subnet=xgl-subnet--cerps-bau-nonprd--be1-01 \
    --addresses=10.1.1.103

gcloud compute routers create xall-vpc--vpc-01--xall-router--shared-nat--de1-01 \
    --description="Router for Cloud NAT" \
    --project=$PROJECT_ID \
    --region=$REGION \
    --network=xall-vpc--vpc-01

gcloud compute routers nats create xall-vpc--vpc-01--xall-nat-gw--shared-nat--de1-01 \
    --project=$PROJECT_ID \
    --region=$REGION \
    --router=xall-vpc--vpc-01--xall-router--shared-nat--de1-01 \
    --auto-allocate-nat-external-ips \
    --nat-all-subnet-ip-ranges \
    --enable-logging 
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
