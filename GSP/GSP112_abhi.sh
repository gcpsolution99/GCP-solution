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
gcloud auth list

export ZONE=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-zone])")
export REGION=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-region])")
gsutil -m cp -r gs://spls/gsp067/python-docs-samples .
cd python-docs-samples/appengine/standard_python3/hello_world

sed -i "s/python37/python39/g" app.yaml

cat > requirements.txt <<EOF_CP
Flask==1.1.2
itsdangerous==2.0.1
Jinja2==3.0.3
werkzeug==2.0.1
EOF_CP

cat > app.yaml <<EOF_CP
runtime: python39
EOF_CP

gcloud app create --region=$REGION
gcloud app deploy --quiet
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
