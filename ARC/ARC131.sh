cat > "$REQUEST1" <<EOF
{
  "config": {
    "encoding": "LINEAR16",
    "languageCode": "en-US",
    "audioChannelCount": 2
  },
  "audio": {
    "uri": "gs://spls/arc131/question_en.wav"
  }
}
EOF

curl -s -X POST -H "Content-Type: application/json" --data-binary @"$REQUEST1" \
"https://speech.googleapis.com/v1/speech:recognize?key=$API_KEY" > $RESPONSE1

cat > "$REQUEST2" <<EOF
{
  "config": {
    "encoding": "FLAC",
    "languageCode": "es-ES"
  },
  "audio": {
    "uri": "gs://spls/arc131/multi_es.flac"
  }
}
EOF

curl -s -X POST -H "Content-Type: application/json" --data-binary @"$REQUEST2" \
"https://speech.googleapis.com/v1/speech:recognize?key=$API_KEY" > $RESPONSE2
