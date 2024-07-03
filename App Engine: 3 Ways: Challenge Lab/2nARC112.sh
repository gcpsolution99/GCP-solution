git clone https://github.com/GoogleCloudPlatform/python-docs-samples.git
cd python-docs-samples/appengine/standard_python3/hello_world
gcloud app deploy
sed -i 's/Hello World!/'"$MESSAGE"'/g' main.py
gcloud app deploy
