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
export REGION="${ZONE%-*}"
gcloud auth list
export PROJECT_ID=$(gcloud config get-value project)
git clone https://github.com/GoogleCloudPlatform/training-data-analyst
ln -s ~/training-data-analyst/courses/developingapps/v1.2/python/kubernetesengine ~/kubernetesengine
cd ~/kubernetesengine/start
export APP_REGION=$REGION
sed -i -e 's/us-central1/'"$REGION"'/g' -e 's/us-central/'"$APP_REGION"'/g' -e 's/python3/'"python3.12"'/g' prepare_environment.sh

. prepare_environment.sh

gcloud beta container --project "$PROJECT_ID" clusters create "quiz-cluster" --zone "$ZONE" --no-enable-basic-auth --cluster-version "latest" --release-channel "regular" --machine-type "e2-medium" --image-type "COS_CONTAINERD" --disk-type "pd-balanced" --disk-size "100" --metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/cloud-platform" --num-nodes "3" --logging=SYSTEM,WORKLOAD --monitoring=SYSTEM --enable-ip-alias --network "projects/$PROJECT_ID/global/networks/default" --subnetwork "projects/$PROJECT_ID/regions/$REGION/subnetworks/default" --no-enable-intra-node-visibility --default-max-pods-per-node "110" --security-posture=standard --workload-vulnerability-scanning=disabled --no-enable-master-authorized-networks --addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver --enable-autoupgrade --enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0 --binauthz-evaluation-mode=DISABLED --enable-managed-prometheus --enable-shielded-nodes --node-locations "$ZONE"
gcloud container clusters get-credentials quiz-cluster --zone "$ZONE" --project $PROJECT_ID
kubectl get pods
gcloud artifacts repositories create container-dev-repo --repository-format=docker \
  --location=$REGION \
  --description="Docker repository for Container Dev Workshop"

cat > frontend/Dockerfile <<EOF_END
FROM gcr.io/google_appengine/python

RUN virtualenv -p python3.7 /env

ENV VIRTUAL_ENV /env
ENV PATH /env/bin:$PATH

ADD requirements.txt /app/requirements.txt
RUN pip install -r /app/requirements.txt

ADD . /app

CMD gunicorn -b 0.0.0.0:\$PORT quiz:app
EOF_END

cat > backend/Dockerfile <<EOF_END
FROM gcr.io/google_appengine/python

RUN virtualenv -p python3.7 /env

ENV VIRTUAL_ENV /env
ENV PATH /env/bin:$PATH

ADD requirements.txt /app/requirements.txt
RUN pip install -r /app/requirements.txt

ADD . /app

CMD python -m quiz.console.worker
EOF_END

gcloud builds submit -t $REGION-docker.pkg.dev/$PROJECT_ID/container-dev-repo/quiz-frontend:v1 ./frontend/
gcloud builds submit -t $REGION-docker.pkg.dev/$PROJECT_ID/container-dev-repo/quiz-backend:v1 ./backend/

cat > frontend-deployment.yaml <<EOF_END
apiVersion: apps/v1
kind: Deployment
metadata:
  name: quiz-frontend
  labels:
    app: quiz-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: quiz-app
      tier: frontend
  template:
    metadata:
      labels:
        app: quiz-app
        tier: frontend
    spec:
      containers:
      - name: quiz-frontend
        image: $REGION-docker.pkg.dev/$PROJECT_ID/container-dev-repo/quiz-frontend:v1
        imagePullPolicy: Always
        ports:
        - name: http-server
          containerPort: 8080
        env:
          - name: GCLOUD_PROJECT
            value: $PROJECT_ID
          - name: GCLOUD_BUCKET
            value: $GCLOUD_BUCKET
EOF_END

cat > backend-deployment.yaml <<EOF_END
apiVersion: apps/v1
kind: Deployment
metadata:
  name: quiz-backend
  labels:
    app: quiz-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: quiz-app
      tier: backend
  template:
    metadata:
      labels:
        app: quiz-app
        tier: backend
    spec:
      containers:
      - name: quiz-backend
        image: $REGION-docker.pkg.dev/$PROJECT_ID/container-dev-repo/quiz-backend:v1
        imagePullPolicy: Always
        env:
          - name: GCLOUD_PROJECT
            value: $PROJECT_ID
          - name: GCLOUD_BUCKET
            value: $GCLOUD_BUCKET
EOF_END

kubectl create -f ./frontend-deployment.yaml
kubectl create -f ./backend-deployment.yaml
kubectl create -f ./frontend-service.yaml
kubectl get deployments
kubectl get services
kubectl get pods
sleep 30
kubectl get service quiz-frontend
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
