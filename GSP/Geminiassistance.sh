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
export REGION=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-region])")
export PROJECT_ID=$(gcloud config get-value project)
export USER=$(gcloud config get-value account 2> /dev/null)
gcloud services enable cloudaicompanion.googleapis.com
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member user:${USER} --role=roles/cloudaicompanion.user
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member user:${USER} --role=roles/serviceusage.serviceUsageViewer
bq mk bqml_tutorial
bq query --use_legacy_sql=false \
"
SELECT u.id as user_id, u.first_name, u.last_name, avg(oi.sale_price) as avg_sale_price   
FROM \`bigquery-public-data.thelook_ecommerce.users\` as u   
JOIN \`bigquery-public-data.thelook_ecommerce.order_items\` as oi   
ON u.id = oi.user_id   
GROUP BY 1,2,3   
ORDER BY avg_sale_price DESC   
LIMIT 10
"
bq query --use_legacy_sql=false \
"
# select the sum of sale_price by Date(created_at) and product_id casted to day from bigquery-public-data.thelook_ecommerce.order_id as t1 joined this with products table in the same dataset as t2
SELECT
  SUM(sale_price),
  DATE(created_at) AS created_at_day,
  CAST(product_id as INT64)
FROM
  \`bigquery-public-data.thelook_ecommerce.order_items\` AS t1
JOIN
  \`bigquery-public-data.thelook_ecommerce.products\` AS t2 ON t1.product_id = t2.id
GROUP BY
  created_at_day,
  product_id
"
bq query --use_legacy_sql=false '
SELECT 
    u.id AS user_id, 
    u.first_name, 
    u.last_name, 
    AVG(oi.sale_price) AS avg_sale_price
FROM 
    `bigquery-public-data.thelook_ecommerce.users` AS u
JOIN 
    `bigquery-public-data.thelook_ecommerce.order_items` AS oi
ON 
    u.id = oi.user_id
GROUP BY 
    u.id, u.first_name, u.last_name
ORDER BY 
    avg_sale_price DESC
LIMIT 10
'
bq query --use_legacy_sql=false '
SELECT
    DATE(order_items.created_at) AS order_date,
    order_items.product_id,
    products.name AS product_name,
    ROUND(SUM(order_items.sale_price), 2) AS total_sales
FROM
    `bigquery-public-data.thelook_ecommerce.order_items` AS order_items
LEFT JOIN
    `bigquery-public-data.thelook_ecommerce.products` AS products
ON
    order_items.product_id = products.id
GROUP BY
    order_date,
    order_items.product_id,
    product_name
ORDER BY
    total_sales DESC
'
bq query --use_legacy_sql=false \
"
CREATE MODEL bqml_tutorial.sales_forecasting_model
OPTIONS(MODEL_TYPE='ARIMA_PLUS',
time_series_timestamp_col='date_col',
time_series_data_col='total_sales',
time_series_id_col='product_id') AS
SELECT sum(sale_price) as total_sales,
DATE(created_at) as date_col,
product_id
FROM \`bigquery-public-data.thelook_ecommerce.order_items\`
AS t1
INNER JOIN \`bigquery-public-data.thelook_ecommerce.products\`
AS t2
ON t1.product_id = t2.id
GROUP BY 2, 3;
"
bq query --use_legacy_sql=false "
SELECT
  *
FROM
  ML.FORECAST(MODEL \`$DEVSHELL_PROJECT_ID.bqml_tutorial.sales_forecasting_model\`,
    STRUCT(
      7 AS horizon,
      0.95 AS confidence_level
    )
  )
"
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
