gcloud alpha network-connectivity hubs create transit-hub \
   --description=Transit_hub

gcloud alpha network-connectivity spokes create bo1 \
    --hub=transit-hub \
    --description=branch_office1 \
    --vpn-tunnel=transit-to-vpc-a-tu1,transit-to-vpc-a-tu2 \
    --region=$REGION_1

echo "${GREEN}${BOLD}Creating Spoke for Branch Office 2 ($REGION_2)...${RESET}"
gcloud alpha network-connectivity spokes create bo2 \
    --hub=transit-hub \
    --description=branch_office2 \
    --vpn-tunnel=transit-to-vpc-b-tu1,transit-to-vpc-b-tu2 \
    --region=$REGION_2

gcloud compute firewall-rules create fw-a --direction=INGRESS --priority=1000 --network=vpc-a --action=ALLOW --rules=tcp:22 --source-ranges=0.0.0.0/0

gcloud compute firewall-rules create fw-b --direction=INGRESS --priority=1000 --network=vpc-b --action=ALLOW --rules=tcp:22 --source-ranges=0.0.0.0/0

gcloud compute instances create vpc-a-vm-1 \
    --zone=$1st_zone \
    --machine-type=e2-medium \
    --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=vpc-a-sub1-use4 \
    --metadata=enable-oslogin=true \
    --maintenance-policy=MIGRATE \
    --provisioning-model=STANDARD \
    --service-account=$PROJECT_NUMBER-compute@developer.gserviceaccount.com \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/trace.append \
    --create-disk=auto-delete=yes,boot=yes,device-name=vpc-a-vm-1,image=projects/debian-cloud/global/images/debian-11-bullseye-v20241210,mode=rw,size=10,type=pd-balanced \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --labels=goog-ec-src=vm_add-gcloud \
    --reservation-affinity=any


gcloud compute instances create vpc-b-vm-1 \
    --zone=$ZONE_VALUE \
    --machine-type=e2-medium \
    --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=vpc-b-sub1-usw2 \
    --metadata=enable-oslogin=true \
    --maintenance-policy=MIGRATE \
    --provisioning-model=STANDARD \
    --service-account=$PROJECT_NUMBER-compute@developer.gserviceaccount.com \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/trace.append \
    --create-disk=auto-delete=yes,boot=yes,device-name=vpc-b-vm-1,image=projects/debian-cloud/global/images/debian-11-bullseye-v20241210,mode=rw,size=10,type=pd-balanced \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --labels=goog-ec-src=vm_add-gcloud \
    --reservation-affinity=any
