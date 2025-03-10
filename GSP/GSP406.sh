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
bq query --use_legacy_sql=false \
"
SELECT
  name, gender,
  SUM(number) AS total
FROM
  \`bigquery-public-data.usa_names.usa_1910_2013\`
GROUP BY
  name, gender
ORDER BY
  total DESC
LIMIT
  10
"

bq mk babynames
bq mk --table \
  --schema "name:string,count:integer,gender:string" \
  $DEVSHELL_PROJECT_ID:babynames.names_2014

bq query --use_legacy_sql=false \
"
SELECT
 name, count
FROM
 \`babynames.names_2014\`
WHERE
 gender = 'M'
ORDER BY count DESC LIMIT 5
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
