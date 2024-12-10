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
bq mk nyctaxi
wget https://raw.githubusercontent.com/gcpsolution99/GCP-solution/refs/heads/main/nyc_tlc_yellow_trips_2018_subset_1.csv
bq load \
  --source_format=CSV \
  --autodetect \
  nyctaxi.2018trips \
  nyc_tlc_yellow_trips_2018_subset_1.csv
bq query --use_legacy_sql=false "SELECT COUNT(*) AS row_count FROM nyctaxi.2018trips"
bq load \
--source_format=CSV \
--autodetect \
--noreplace  \
nyctaxi.2018trips \
gs://cloud-training/OCBL013/nyc_tlc_yellow_trips_2018_subset_2.csv
bq query --use_legacy_sql=false \
"CREATE TABLE nyctaxi.january_trips AS
SELECT
  *
FROM
  nyctaxi.2018trips
WHERE
  EXTRACT(Month FROM pickup_datetime) = 1;"
bq query --use_legacy_sql=false \
"SELECT
  *
FROM
  nyctaxi.january_trips
ORDER BY
  trip_distance DESC
LIMIT
  1"
for line in "${pattern[@]}"
do
    echo -e "${YELLOW}${line}${NC}"
done









