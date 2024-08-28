gcloud services enable dataplex.googleapis.com

gcloud services enable datacatalog.googleapis.com

sleep 15

gcloud dataplex lakes create orders-lake \
  --location=$REGION \
  --display-name="Orders Lake"

gcloud dataplex zones create customer-curated-zone \
    --location=$REGION \
    --lake=orders-lake \
    --display-name="Customer Curated Zone" \
    --resource-location-type=SINGLE_REGION \
    --type=CURATED \
    --discovery-enabled \
    --discovery-schedule="0 * * * *"

gcloud dataplex assets create customer-details-dataset \
--location=$REGION \
--lake=orders-lake \
--zone=customer-curated-zone \
--display-name="Customer Details Dataset" \
--resource-type=BIGQUERY_DATASET \
--resource-name=projects/$DEVSHELL_PROJECT_ID/datasets/customers \
--discovery-enabled

gcloud data-catalog tag-templates create protected_data_template --location=$REGION --field=id=protected_data_flag,display-name="Protected Data Flag",type='enum(YES|NO)' --display-name="Protected Data Template"
