run_form_1() {

gsutil mb -c coldline gs://$BUCKET_1

gsutil retention set 30s gs://$BUCKET_2

echo "Awesome Lab" > sample.txt

gsutil cp sample.txt gs://$BUCKET_3
}

run_form_2() {

gsutil mb gs://$BUCKET_1

gcloud alpha storage buckets update gs://$BUCKET_2 --no-uniform-bucket-level-access

gsutil acl ch -u $USER_EMAIL:OWNER gs://$BUCKET$BUCKET_2

gsutil rm gs://$BUCKET$BUCKET_2/sample.txt

echo "Awesome Lab" > sample.txt

gsutil cp sample.txt gs://$BUCKET$BUCKET_2

gsutil acl ch -u allUsers:R gs://$BUCKET$BUCKET_2/sample.txt

gcloud storage buckets update gs://$BUCKET_3 --update-labels=key=value
}

run_form_3() {

gsutil mb -c nearline gs://$BUCKET_1

echo "This is an example of editing the file content for cloud storage object" | gsutil cp - gs://$BUCKET_2/sample.txt

gsutil defstorageclass set ARCHIVE gs://$BUCKET_3
}

read -p "Enter Form Number (1, 2, or 3): " form_number

case $form_number in
    1) run_form_1 ;;
    2) run_form_2 ;;
    3) run_form_3 ;;
    *) echo "Invalid form number. Please enter 1, 2, or 3." ;;
esac
