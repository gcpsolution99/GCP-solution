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
export PROJECT_ID=$(gcloud config get-value project)
echo "Project ID set to: ${PROJECT_ID}"
echo

echo
read -p "Enter your region: " REGION
echo
read -p "Enter Cloud Function name: " FUNCTION_NAME
echo

mkdir -p cloud-function
cat > cloud-function/index.js <<EOF
exports.helloWorld = (req, res) => {
  res.send('Hello from Cloud Function!');
};
EOF

cat > cloud-function/package.json <<EOF
{
  "name": "cf-nodejs",
  "version": "1.0.0",
  "main": "index.js"
}
EOF

gcloud functions deploy ${FUNCTION_NAME} \
  --gen2 \
  --runtime=nodejs20 \
  --region=${REGION} \
  --source=cloud-function \
  --entry-point=helloWorld \
  --trigger-http \
  --max-instances=5 \
  --allow-unauthenticated

echo -e "\n"
cd ~
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
