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
read -p "Enter Region_One:" group1_region
read -p "Enter Region_Two:" group2_region
read -p "Enter Region_Three:" group3_region

git clone https://github.com/terraform-google-modules/terraform-google-lb-http.git
cd ~/terraform-google-lb-http/examples/multi-backend-multi-mig-bucket-https-lb
export GOOGLE_PROJECT=$(gcloud config get-value project)

rm -rf main.tf

wget https://raw.githubusercontent.com/gcpsolution99/GCP-solution/refs/heads/main/HTTPS%20Content-Based%20Load%20Balancer%20with%20Terraform%202025/main.tf

cat > variables.tf <<EOF_CP
variable "group1_region" {
  default = "$group1_region"
}

variable "group2_region" {
  default = "$group2_region"
}

variable "group3_region" {
  default = "$group3_region"
}

variable "network_name" {
  default = "ml-bk-ml-mig-bkt-s-lb"
}

variable "project" {
  type = string
}
EOF_CP

terraform init 

echo "$GOOGLE_PROJECT" | terraform plan
echo "$GOOGLE_PROJECT" | terraform apply --auto-approve
EXTERNAL_IP=$(terraform output | grep load-balancer-ip | cut -d = -f2 | xargs echo -n)
echo http://${EXTERNAL_IP}
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
