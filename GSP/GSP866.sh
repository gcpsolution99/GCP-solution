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
bq query --use_legacy_sql=false "
SELECT
  *
FROM
  \`bigquery-public-data.new_york_citibike.citibike_stations\`
LIMIT
  10
"

# Second query: Finds Citi Bike stations with > 30 bikes
bq query --use_legacy_sql=false "
SELECT
  ST_GeogPoint(longitude, latitude) AS WKT,
  num_bikes_available
FROM
  \`bigquery-public-data.new_york.citibike_stations\`
WHERE num_bikes_available > 30
"

# Third query: Same as the second, repeated
bq query --use_legacy_sql=false "
SELECT
  ST_GeogPoint(longitude, latitude) AS WKT,
  num_bikes_available
FROM
  \`bigquery-public-data.new_york.citibike_stations\`
WHERE num_bikes_available > 30
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
