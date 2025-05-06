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
bq show bigquery-public-data:samples.shakespeare

bq query --use_legacy_sql=false \
'SELECT
  word,
  SUM(word_count) AS count
 FROM
  `bigquery-public-data`.samples.shakespeare
 WHERE
  word LIKE "%raisin%"
 GROUP BY
  word'

bq query --use_legacy_sql=false \
'SELECT
  word
 FROM
  `bigquery-public-data`.samples.shakespeare
 WHERE
  word = "huzzah"'

bq mk babynames

wget https://github.com/ArcadeCrew/Google-Cloud-Labs/raw/refs/heads/main/BigQuery%20Qwik%20Start%20-%20Command%20Line/names.zip

unzip names.zip

bq load babynames.names2010 yob2010.txt name:string,gender:string,count:integer

bq query "SELECT name,count FROM babynames.names2010 WHERE gender = 'F' ORDER BY count DESC LIMIT 5"

bq query "SELECT name,count FROM babynames.names2010 WHERE gender = 'M' ORDER BY count ASC LIMIT 5"

bq rm -r babynames

rm -f names.zip yob2010.txt
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
