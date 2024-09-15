echo "*** Started ***"

gcloud services enable appengineflex.googleapis.com
gsutil cp gs://spls/gsp499/user-authentication-with-iap.zip .
unzip user-authentication-with-iap.zip
cd user-authentication-with-iap
cd 1-HelloWorld
gcloud app deploy
cd ~/user-authentication-with-iap/2-HelloUser
gcloud app deploy
cd ~/user-authentication-with-iap/3-HelloVerifiedUser
gcloud app deploy
LINK=$(gcloud app browse)
LINKU=${LINK#https://}
cat > details.json << EOF
{
  App name: IAP Example
  Application home page: $LINK
  Application privacy Policy link: $LINK/privacy
  Authorized domains: $LINKU
  Developer Contact Information: student-01-8a953d12df2c@qwiklabs.net
}
EOF
cat details.json


echo "*** Completed ***"
