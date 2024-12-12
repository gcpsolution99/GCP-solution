gcloud compute vpn-tunnels create transit-to-vpc-a-tu1 \
  --region=$REGION_1 \
  --vpn-gateway=vpc-transit-gw1-use4 \
  --peer-gcp-gateway=projects/$DEVSHELL_PROJECT_ID/regions/$REGION_1/vpnGateways/vpc-a-gw1-use4 \
  --router=cr-vpc-transit-use4-1 \
  --ike-version=2 \
  --shared-secret=gcprocks \
  --interface=0

gcloud compute vpn-tunnels create transit-to-vpc-a-tu2 \
  --region=$REGION_1 \
  --vpn-gateway=vpc-transit-gw1-use4 \
  --peer-gcp-gateway=projects/$DEVSHELL_PROJECT_ID/regions/$REGION_1/vpnGateways/vpc-a-gw1-use4 \
  --router=cr-vpc-transit-use4-1 \
  --ike-version=2 \
  --shared-secret=gcprocks \
  --interface=1

gcloud compute routers add-interface cr-vpc-transit-use4-1 \
  --interface-name=transit-to-vpc-a-tu1 \
  --vpn-tunnel=transit-to-vpc-a-tu1 \
  --region=$REGION_1 \
  --ip-address=169.254.1.1 \
  --mask-length=30

gcloud compute routers add-bgp-peer cr-vpc-transit-use4-1 \
  --peer-name=transit-to-vpc-a-bgp1 \
  --peer-asn=65001 \
  --interface=transit-to-vpc-a-tu1 \
  --advertisement-mode=custom \
  --peer-ip-address=169.254.1.2 \
  --region=$REGION_1

gcloud compute routers add-interface cr-vpc-transit-use4-1 \
  --interface-name=transit-to-vpc-a-tu2 \
  --vpn-tunnel=transit-to-vpc-a-tu2 \
  --region=$REGION_1 \
  --ip-address=169.254.1.5 \
  --mask-length=30

gcloud compute routers add-bgp-peer cr-vpc-transit-use4-1 \
  --peer-name=transit-to-vpc-a-bgp2 \
  --peer-asn=65001 \
  --interface=vpc-a-to-transit-tu2 \
  --advertisement-mode=custom \
  --peer-ip-address=169.254.1.6 \
  --region=$REGION_1

gcloud compute vpn-tunnels create vpc-a-to-transit-tu1 \
  --region=$REGION_1 \
  --vpn-gateway=vpc-a-gw1-use4 \
  --peer-gcp-gateway=projects/$DEVSHELL_PROJECT_ID/regions/$REGION_1/vpnGateways/vpc-transit-gw1-use4 \
  --router=cr-vpc-a-use4-1 \
  --ike-version=2 \
  --shared-secret=gcprocks \
  --interface=0

gcloud compute vpn-tunnels create vpc-a-to-transit-tu2 \
  --region=$REGION_1 \
  --vpn-gateway=vpc-a-gw1-use4 \
  --peer-gcp-gateway=projects/$DEVSHELL_PROJECT_ID/regions/$REGION_1/vpnGateways/vpc-transit-gw1-use4 \
  --router=cr-vpc-a-use4-1 \
  --ike-version=2 \
  --shared-secret=gcprocks \
  --interface=1

gcloud compute routers add-interface cr-vpc-a-use4-1 \
  --interface-name=vpc-a-to-transit-tu1 \
  --vpn-tunnel=vpc-a-to-transit-tu1 \
  --region=$REGION_1 \
  --ip-address=169.254.1.2 \
  --mask-length=30

gcloud compute routers add-bgp-peer cr-vpc-a-use4-1 \
  --peer-name=vpc-a-to-transit-bgp1 \
  --peer-asn=65000 \
  --interface=vpc-a-to-transit-tu1 \
  --advertisement-mode=custom \
  --peer-ip-address=169.254.1.1 \
  --region=$REGION_1

gcloud compute routers add-interface cr-vpc-a-use4-1 \
  --interface-name=vpc-a-to-transit-tu2 \
  --vpn-tunnel=vpc-a-to-transit-tu2 \
  --region=$REGION_1 \
  --ip-address=169.254.1.6 \
  --mask-length=30

gcloud compute routers add-bgp-peer cr-vpc-a-use4-1 \
  --peer-name=vpc-a-to-transit-bgp2 \
  --peer-asn=65000 \
  --interface=vpc-a-to-transit-tu2 \
  --advertisement-mode=custom \
  --peer-ip-address=169.254.1.5 \
  --region=$REGION_1

gcloud compute vpn-tunnels create transit-to-vpc-b-tu1 \
  --region=$REGION_2 \
  --vpn-gateway=vpc-transit-gw1-usw2 \
  --peer-gcp-gateway=projects/$DEVSHELL_PROJECT_ID/regions/$REGION_2/vpnGateways/vpc-b-gw1-usw2 \
  --router=cr-vpc-transit-usw2-1 \
  --ike-version=2 \
  --shared-secret=gcprocks \
  --interface=0

gcloud compute vpn-tunnels create transit-to-vpc-b-tu2 \
  --region=$REGION_2 \
  --vpn-gateway=vpc-transit-gw1-usw2 \
  --peer-gcp-gateway=projects/$DEVSHELL_PROJECT_ID/regions/$REGION_2/vpnGateways/vpc-b-gw1-usw2 \
  --router=cr-vpc-transit-usw2-1 \
  --ike-version=2 \
  --shared-secret=gcprocks \
  --interface=1

gcloud compute routers add-interface cr-vpc-transit-usw2-1 \
  --interface-name=transit-to-vpc-b-tu1 \
  --vpn-tunnel=transit-to-vpc-b-tu1 \
  --region=$REGION_2 \
  --ip-address=169.254.1.9 \
  --mask-length=30

gcloud compute routers add-bgp-peer cr-vpc-transit-usw2-1 \
  --peer-name=transit-to-vpc-b-bgp1 \
  --peer-asn=65002 \
  --interface=transit-to-vpc-b-tu1 \
  --advertisement-mode=custom \
  --peer-ip-address=169.254.1.10 \
  --region=$REGION_2

gcloud compute routers add-interface cr-vpc-transit-usw2-1 \
  --interface-name=transit-to-vpc-b-tu2 \
  --vpn-tunnel=transit-to-vpc-b-tu2 \
  --region=$REGION_2 \
  --ip-address=169.254.1.13 \
  --mask-length=30

gcloud compute routers add-bgp-peer cr-vpc-transit-usw2-1 \
  --peer-name=transit-to-vpc-b-bgp2 \
  --peer-asn=65002 \
  --interface=vpc-b-to-transit-tu2 \
  --advertisement-mode=custom \
  --peer-ip-address=169.254.1.14 \
  --region=$REGION_2

gcloud compute vpn-tunnels create vpc-b-to-transit-tu1 \
  --region=$REGION_2 \
  --vpn-gateway=vpc-b-gw1-usw2 \
  --peer-gcp-gateway=projects/$DEVSHELL_PROJECT_ID/regions/$REGION_2/vpnGateways/vpc-transit-gw1-usw2 \
  --router=cr-vpc-b-usw2-1 \
  --ike-version=2 \
  --shared-secret=gcprocks \
  --interface=0

gcloud compute vpn-tunnels create vpc-b-to-transit-tu2 \
  --region=$REGION_2 \
  --vpn-gateway=vpc-b-gw1-usw2 \
  --peer-gcp-gateway=projects/$DEVSHELL_PROJECT_ID/regions/$REGION_2/vpnGateways/vpc-transit-gw1-usw2 \
  --router=cr-vpc-b-usw2-1 \
  --ike-version=2 \
  --shared-secret=gcprocks \
  --interface=1

gcloud compute routers add-interface cr-vpc-b-usw2-1 \
  --interface-name=vpc-b-to-transit-tu1 \
  --vpn-tunnel=vpc-b-to-transit-tu1 \
  --region=$REGION_2 \
  --ip-address=169.254.1.10 \
  --mask-length=30

gcloud compute routers add-bgp-peer cr-vpc-b-usw2-1 \
  --peer-name=vpc-b-to-transit-bgp1 \
  --peer-asn=65000 \
  --interface=vpc-b-to-transit-tu1 \
  --advertisement-mode=custom \
  --peer-ip-address=169.254.1.9 \
  --region=$REGION_2

gcloud compute routers add-interface cr-vpc-b-usw2-1 \
  --interface-name=vpc-b-to-transit-tu2 \
  --vpn-tunnel=vpc-b-to-transit-tu2 \
  --region=$REGION_2 \
  --ip-address=169.254.1.14 \
  --mask-length=30

gcloud compute routers add-bgp-peer cr-vpc-b-usw2-1 \
  --peer-name=vpc-b-to-transit-bgp2 \
  --peer-asn=65000 \
  --interface=vpc-b-to-transit-tu2 \
  --advertisement-mode=custom \
  --peer-ip-address=169.254.1.13 \
  --region=$REGION_2
