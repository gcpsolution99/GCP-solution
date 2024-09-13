echo "*** Execution Started ***"

bq mk ecommerce

bq query --use_legacy_sql=false \
'#standardSQL
 CREATE OR REPLACE TABLE ecommerce.all_sessions_raw_dataprep
 OPTIONS(
   description="Raw data from analyst team to ingest into Cloud Dataprep"
 ) AS
 SELECT * FROM `data-to-insights.ecommerce.all_sessions_raw`
 WHERE date = "20170801";'

 echo "*** Now !! Follow Video ***"
