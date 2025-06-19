#!/bin/bash

# Config
REPO="my_backup"
ES_HOST="10.226.71.1:9200"
SNAPSHOT_NAME="snapshot-$(date +%Y-%m-%d_%H-%M)"
SNAPSHOT_DATE_FORMAT="+%Y-%m-%d_%H-%M"
RETENTION_DAYS=10

# Create a new snapshot
curl -XPUT "$ES_HOST/_snapshot/$REPO/$SNAPSHOT_NAME?wait_for_completion=true" -d '{
  "indices": "*",
  "ignore_unavailable": true,
  "include_global_state": true
}'

# Get current time in epoch
now_epoch=$(date +%s)

# Get list of all snapshots
snapshots=$(curl -s "$ES_HOST/_snapshot/$REPO/_all" | grep -oP '"snapshot"\s*:\s*"\K[^"]+')

# Loop through snapshots and delete older than retention
for snap in $snapshots; do
    # Extract timestamp from snapshot name
    snap_date_str=$(echo "$snap" | sed -n 's/snapshot-\(.*\)/\1/p')
    
    # Convert to epoch (only if matches expected date format)
    if [[ $snap_date_str =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}_[0-9]{2}-[0-9]{2}$ ]]; then
        snap_epoch=$(date -d "${snap_date_str//_/ }" +%s 2>/dev/null)
        if [[ $? -eq 0 ]]; then
            age_days=$(( (now_epoch - snap_epoch) / 86400 ))
            if (( age_days > RETENTION_DAYS )); then
                echo ""
                echo "Deleting snapshot $snap (age: $age_days days)"
                curl -XDELETE "$ES_HOST/_snapshot/$REPO/$snap"
            fi
        fi
    fi
done
