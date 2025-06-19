#!/bin/bash

ES_HOST="http://10.226.71.1:9200"
INDEX_NAME="*"
FIELD_NAME="request"  # adjust if different
KEYWORD="$1"

if [ -z "$KEYWORD" ]; then
  echo "Usage: $0 <search-keyword>"
  exit 1
fi

curl -s -XGET "$ES_HOST/$INDEX_NAME/_search" -H 'Content-Type: application/json' -d "{
  \"query\": {
    \"wildcard\": {
      \"$FIELD_NAME\": {
        \"value\": \"*$KEYWORD*\"
      }
    }
  },
  \"size\": 1000
}" | jq -r '.hits.hits[]._id'
