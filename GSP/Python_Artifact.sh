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
gcloud services enable artifactregistry.googleapis.com
export REGION=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-region])")
export PROJECT_ID=$(gcloud config get-value project)
gcloud config set compute/region $REGION
gcloud config set project $PROJECT_ID
gcloud artifacts repositories create my-python-repo \
    --repository-format=python \
    --location="$REGION" \
    --description="Python package repository"

pip install keyrings.google-artifactregistry-auth
pip config set global.extra-index-url https://"$REGION"-python.pkg.dev/"$PROJECT_ID"/my-python-repo/simple
mkdir my-package
cd my-package

cat > setup.py <<EOF
from setuptools import setup, find_packages

setup(
    name='my_package',
    version='0.1.0',
    author='cls',
    author_email='"$EMAIL"',
    packages=find_packages(exclude=['tests']),
    install_requires=[
        # List your dependencies here
    ],
    description='A sample Python package',
)
EOF

mkdir -p my_package
cat > my_package/my_module.py <<EOF
def hello_world():
    return 'Hello, world!'
EOF

pip install twine
python setup.py sdist bdist_wheel
python3 -m twine upload --repository-url https://"$REGION"-python.pkg.dev/"$PROJECT_ID"/my-python-repo/ dist/*
gcloud artifacts packages list --repository=my-python-repo --location="$REGION"
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
