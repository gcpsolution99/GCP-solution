PROJECT_ID=$(gcloud config get-value project)

mkdir ~/gemini-app
cd ~/gemini-app
python3 -m venv gemini-streamlit
source gemini-streamlit/bin/activate
