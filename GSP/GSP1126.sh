gcloud config set compute/zone "$ZONE"
export ZONE=$(gcloud config get compute/zone)
gcloud config set compute/region "${ZONE%-*}"
export REGION=$(gcloud config get compute/region)
gcloud compute instances create lab-1 --zone=$ZONE

cat << 'EOF' > toggle_zone_script.sh
#!/bin/bash
last_char="${ZONE: -1}"
if [ "$last_char" == "a" ]; then
    export NZONE="${ZONE%?}b"  
elif [ "$last_char" == "b" ]; then
    export NZONE="${ZONE%?}c" 
elif [ "$last_char" == "c" ]; then
    export NZONE="${ZONE%?}b"
elif [ "$last_char" == "d" ]; then
    export NZONE="${ZONE%?}b"
fi
echo "$NZONE"
EOF

chmod +x toggle_zone_script.sh
NEWZONE=$(./toggle_zone_script.sh)
gcloud config set compute/zone $NEWZONE
gcloud init --no-launch-browser
