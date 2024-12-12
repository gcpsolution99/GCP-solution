gcloud compute networks create vpc-b --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional

gcloud compute networks subnets create vpc-b-sub1-usw2 --range=10.20.20.0/24 --stack-type=IPV4_ONLY --network=vpc-b --region=$REGION_2

gcloud compute routers create cr-vpc-transit-use4-1 --region=$REGION_1 --network=vpc-transit --asn=65000

gcloud compute routers create cr-vpc-transit-usw2-1 --region=$REGION_2 --network=vpc-transit --asn=65000

gcloud compute routers create cr-vpc-a-use4-1 --region=$REGION_1 --network=vpc-a --asn=65001

gcloud compute routers create cr-vpc-b-usw2-1 --region=$REGION_2 --network=vpc-b --asn=65002

gcloud compute vpn-gateways create vpc-transit-gw1-use4 --region=$REGION_1 --network=vpc-transit

gcloud compute vpn-gateways create vpc-transit-gw1-usw2 --region=$REGION_2 --network=vpc-transit

gcloud compute vpn-gateways create vpc-a-gw1-use4 --region=$REGION_1 --network=vpc-a

gcloud compute vpn-gateways create vpc-b-gw1-usw2 --region=$REGION_2 --network=vpc-b
