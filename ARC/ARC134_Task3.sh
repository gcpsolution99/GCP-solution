export PROJECT_ID=$(gcloud config get-value project)

sudo apt-get update
 
sudo apt-get install -y git python3-pip
 
pip3 install --upgrade pip
 
pip3 install google-cloud-bigquery
 
pip3 install pyarrow
 
pip3 install pandas
 
pip3 install db-dtypes



echo "
from google.auth import compute_engine
from google.cloud import bigquery
credentials = compute_engine.Credentials(
    service_account_email='bigquery-qwiklab@$PROJECT_ID.iam.gserviceaccount.com')
query = '''
SELECT name, SUM(number) as total_people
FROM "bigquery-public-data.usa_names.usa_1910_2013"
WHERE state = 'TX'
GROUP BY name, state
ORDER BY total_people DESC
LIMIT 20
'''
client = bigquery.Client(
    project='$PROJECT_ID',
    credentials=credentials)
print(client.query(query).to_dataframe())
" > query.py



pip3 install --upgrade pip
 
pip3 install google-cloud-bigquery
 
pip3 install pyarrow
 
pip3 install pandas
 
pip3 install db-dtypes

python3 query.py
