# Please like share & subscribe to [Abhi arcade solution](http://www.youtube.com/@Abhi_Arcade_Solution)

## Run in CloudShell and follow video:

```
export REGION=
```

## Command 1:

```
PROJECT_ID=$(gcloud config get-value project)
echo "PROJECT_ID=${PROJECT_ID}"
echo "REGION=${REGION}"
gcloud services enable cloudbuild.googleapis.com
cloudfunctions.googleapis.com run.googleapis.com
logging.googleapis.com storage-component.googleapis.com
aiplatform.googleapis.com

sleep 10

mkdir ~/gemini-app
cd ~/gemini-app
python3 -m venv gemini-streamlit
source gemini-streamlit/bin/activate
```
## Command 2:
```
curl -LO raw.githubusercontent.com/gcpsolution99/GCP-solution/main/GSP/Gemini2.sh
sudo chmod +x Gemini2.sh
./Gemini2.sh
```
## Command 3:
```
curl -LO raw.githubusercontent.com/gcpsolution99/GCP-solution/main/GSP/Gemini3.sh
sudo chmod +x Gemini3.sh
./Gemini3.sh
```

## Congratulations !!
