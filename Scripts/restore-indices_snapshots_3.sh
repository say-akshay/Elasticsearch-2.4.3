#!/bin/bash

SNAPSHOT_NAME=$1  # pass snapshot name as argument
REPO="my_backup"
ES_HOST="10.226.71.1:9200"

if [ -z "$SNAPSHOT_NAME" ]; then
  echo "Usage: $0 <snapshot-name>"
  exit 1
fi

curl -XPOST "$ES_HOST/_snapshot/$REPO/$SNAPSHOT_NAME/_restore" -d '{
  "indices": "*",
  "include_global_state": true,
  "rename_pattern": "index_(.+)",
  "rename_replacement": "restored_index_$1"
}'
