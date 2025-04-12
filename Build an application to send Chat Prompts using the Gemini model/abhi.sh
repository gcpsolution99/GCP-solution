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
LAB_MODEL="gemini-2.0-flash-001"
ID="$(gcloud projects list --format='value(PROJECT_ID)')"

cat > SendChatwithoutStream.py <<EOF
from google import genai
from google.genai.types import HttpOptions, ModelContent, Part, UserContent

import logging
from google.cloud import logging as gcp_logging

# Initialize GCP logging
gcp_logging_client = gcp_logging.Client()
gcp_logging_client.setup_logging()

client = genai.Client(
    vertexai=True,
    project='${ID}',
    location='${REGION}',
    http_options=HttpOptions(api_version="v1")
)
chat = client.chats.create(
    model="${LAB_MODEL}",
    history=[
        UserContent(parts=[Part(text="Hello")]),
        ModelContent(
            parts=[Part(text="Great to meet you. What would you like to know?")],
        ),
    ],
)
response = chat.send_message("What are all the colors in a rainbow?")
logging.info(f'Received response 1: {response.text}') # Added logging
print(response.text)

response = chat.send_message("Why does it appear when it rains?")
logging.info(f'Received response 2: {response.text}') # Added logging
print(response.text)
EOF

/usr/bin/python3 /home/student/SendChatwithoutStream.py
sleep 10

cat > SendChatwithStream.py <<EOF
from google import genai
from google.genai.types import HttpOptions

import logging
from google.cloud import logging as gcp_logging

# Initialize GCP logging
gcp_logging_client = gcp_logging.Client()
gcp_logging_client.setup_logging()

client = genai.Client(
    vertexai=True,
    project='${ID}',
    location='${REGION}',
    http_options=HttpOptions(api_version="v1")
)
chat = client.chats.create(model="${LAB_MODEL}")
response_text = ""

logging.info("Sending streaming prompt...") # Added logging
print("Streaming response:") # Added for clarity
for chunk in chat.send_message_stream("What are all the colors in a rainbow?"):
    print(chunk.text, end="")
    response_text += chunk.text
print() # Add a newline after streaming output
logging.info(f"Received full streaming response: {response_text}") # Added logging

EOF

echo "${GREEN_TEXT}${BOLD_TEXT}Executing SendChatwithStream.py...${RESET_FORMAT}"
/usr/bin/python3 /home/student/SendChatwithStream.py

sleep 10
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
