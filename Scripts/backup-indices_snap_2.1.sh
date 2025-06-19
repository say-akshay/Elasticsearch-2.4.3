#!/bin/bash

SNAPSHOT_NAME="snapshot-$(date +%Y-%m-%d_%H-%M)"
#SNAPSHOT_NAME="snapshot-$(date +%Y%m%d%H%M)"
REPO="my_backup"
ES_HOST="10.226.71.1:9200"

curl -XPUT "$ES_HOST/_snapshot/$REPO/$SNAPSHOT_NAME?wait_for_completion=true" -d '{
  "indices": "*",
  "ignore_unavailable": true,
  "include_global_state": true
}'
