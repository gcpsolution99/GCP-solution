# Please like share & subscribe to [Abhi arcade solution](http://www.youtube.com/@Abhi_Arcade_Solution)

## Run in CloudShell and follow video:
```
gcloud services enable documentai.googleapis.com
export ZONE=$(gcloud compute instances list document-ai-dev --format 'csv[no-heading](zone)')
gcloud compute ssh document-ai-dev --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet
```

1. Navigate to `Document AI`
2. Enter processor name as `form-parser`
3. Download the form.pdf

```
export PROCESSOR_ID=
```
```
curl -LO raw.githubusercontent.com/gcpsolution99/GCP-solution/main/GSP/GSP924.sh

sudo chmod +x GSP924.sh

./GSP924.sh
```

## Congratulations !!
