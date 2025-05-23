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
echo
read -p "Enter your region1: " REGION1
echo
read -p "Enter your region2: " REGION2
echo
read -p "Enter your FUNCTION_NAME1: " FUNCTION_NAME1
echo
read -p "Enter your FUNCTION_NAME2: " FUNCTION_NAME2
echo

mkdir -p cloud-function-http-go
cat > cloud-function-http-go/main.go <<EOF
package p

import (
	"net/http"
)

func HelloHTTP(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("Hello from Go HTTP Cloud Function!"))
}
EOF

cat > cloud-function-http-go/go.mod <<EOF
module cloudfunction

go 1.21
EOF

gcloud functions deploy ${FUNCTION_NAME1} \
  --gen2 \
  --runtime=go121 \
  --region=${REGION1} \
  --source=cloud-function-http-go \
  --entry-point=HelloHTTP \
  --trigger-http \
  --max-instances=5 \
  --allow-unauthenticated

mkdir -p cloud-function-pubsub-go
cat > cloud-function-pubsub-go/main.go <<EOF
package p

import (
	"context"
	"log"
)

type PubSubMessage struct {
	Data []byte \`json:"data"\`
}

func HelloPubSub(ctx context.Context, m PubSubMessage) error {
	log.Printf("Hello, %s!", string(m.Data))
	return nil
}
EOF

cat > cloud-function-pubsub-go/go.mod <<EOF
module cloudfunction

go 1.21
EOF

gcloud functions deploy ${FUNCTION_NAME2} \
  --gen2 \
  --runtime=go121 \
  --region=${REGION2} \
  --source=cloud-function-pubsub-go \
  --entry-point=HelloPubSub \
  --trigger-topic=cf-pubsub \
  --max-instances=5

cd ~
for file in *; do
  if [[ "$file" == gsp* || "$file" == arc* || "$file" == shell* ]]; then
    if [[ -f "$file" ]]; then
      rm "$file"
    fi
  fi
done

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
