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
bq mk bq_logs
bq mk bq_logs_test
bq ls
echo Y | bq rm bq_logs_test
bq mk \
 --table \
 --expiration 3600 \
 --description "This is a test table" \
 bq_logs.test_table \
 id:STRING,name:STRING,address:STRING
bq query --use_legacy_sql=false 'SELECT current_date'
bq query --use_legacy_sql=false \
'SELECT
 gsod2021.date,
 stations.usaf,
 stations.wban,
 stations.name,
 stations.country,
 stations.state,
 stations.lat,
 stations.lon,
 stations.elev,
 gsod2021.temp,
 gsod2021.max,
 gsod2021.min,
 gsod2021.mxpsd,
 gsod2021.gust,
 gsod2021.fog,
 gsod2021.hail
FROM
 `bigquery-public-data.noaa_gsod.gsod2021` gsod2021
INNER JOIN
 `bigquery-public-data.noaa_gsod.stations` stations
ON
 gsod2021.stn = stations.usaf
 AND gsod2021.wban = stations.wban
WHERE
 stations.country = "US"
 AND gsod2021.date = "2021-12-15"
 AND stations.state IS NOT NULL
 AND gsod2021.max != 9999.9
ORDER BY
 gsod2021.min;'
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
