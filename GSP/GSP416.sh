bq mk fruit_store

bq mk --table --description "Table for fruit details" $DEVSHELL_PROJECT_ID:fruit_store.fruit_details

bq load --source_format=NEWLINE_DELIMITED_JSON --autodetect $DEVSHELL_PROJECT_ID:fruit_store.fruit_details gs://data-insights-course/labs/optimizing-for-performance/shopping_cart.json

echo "${GREEN}${BOLD}

Task 2 Completed

${RESET}"

#task 3

bq query --use_legacy_sql=false \
"
SELECT
  fullVisitorId,
  date,
  ARRAY_AGG(DISTINCT v2ProductName) AS products_viewed,
  ARRAY_LENGTH(ARRAY_AGG(DISTINCT v2ProductName)) AS distinct_products_viewed,
  ARRAY_AGG(DISTINCT pageTitle) AS pages_viewed,
  ARRAY_LENGTH(ARRAY_AGG(DISTINCT pageTitle)) AS distinct_pages_viewed
  FROM \`data-to-insights.ecommerce.all_sessions\`
WHERE visitId = 1501570398
GROUP BY fullVisitorId, date
ORDER BY date
"


echo "${GREEN}${BOLD}

Task 3 Completed

${RESET}"

#task 4


bq query --use_legacy_sql=false \
"
SELECT DISTINCT
  visitId,
  h.page.pageTitle
FROM \`bigquery-public-data.google_analytics_sample.ga_sessions_20170801\`,
UNNEST(hits) AS h
WHERE visitId = 1501570398
LIMIT 10
"

echo "${GREEN}${BOLD}

Task 4 Completed

${RESET}"

#task 6

# Define the schema in a JSON file, e.g., schema.json
echo '[
    {
        "name": "race",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "participants",
        "type": "RECORD",
        "mode": "REPEATED",
        "fields": [
            {
                "name": "name",
                "type": "STRING",
                "mode": "NULLABLE"
            },
            {
                "name": "splits",
                "type": "FLOAT",
                "mode": "REPEATED"
            }
        ]
    }
]' > schema.json


bq mk racing

bq mk --table --schema=schema.json --description "Table for race details" $DEVSHELL_PROJECT_ID:racing.race_results 

bq load --source_format=NEWLINE_DELIMITED_JSON --schema=schema.json $DEVSHELL_PROJECT_ID:racing.race_results gs://data-insights-course/labs/optimizing-for-performance/race_results.json

echo "${GREEN}${BOLD}

Task 6 Completed

${RESET}"

#task 7

bq query --use_legacy_sql=false \
"
#standardSQL
SELECT COUNT(p.name) AS racer_count
FROM racing.race_results AS r, UNNEST(r.participants) AS p
"

echo "${GREEN}${BOLD}

Task 7 Completed

${RESET}"

#task 8


bq query --use_legacy_sql=false \
"
#standardSQL
SELECT
  p.name,
  SUM(split_times) as total_race_time
FROM racing.race_results AS r
, UNNEST(r.participants) AS p
, UNNEST(p.splits) AS split_times
WHERE p.name LIKE 'R%'
GROUP BY p.name
ORDER BY total_race_time ASC;
"

echo "${GREEN}${BOLD}

Task 8 Completed

${RESET}"

#task 9

bq query --use_legacy_sql=false \
"
#standardSQL
SELECT
  p.name,
  split_time
FROM racing.race_results AS r
, UNNEST(r.participants) AS p
, UNNEST(p.splits) AS split_time
WHERE split_time = 23.2;
"

echo "${GREEN}${BOLD}

Task 9 Completed

${RESET}"
