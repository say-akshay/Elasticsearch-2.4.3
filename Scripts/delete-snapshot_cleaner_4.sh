#!/bin/bash

# Configuration
REPO="my_backup"
ES_HOST="10.226.71.1:9200"
RETENTION_DAYS=10

# Get current time in epoch
now_epoch=$(date +%s)

# Get list of all snapshots
snapshots=$(curl -s "$ES_HOST/_snapshot/$REPO/_all" | grep -oP '"snapshot"\s*:\s*"\K[^"]+')

# Loop through snapshots
for snap in $snapshots; do
    # Extract timestamp from snapshot name (assumes format snapshot-YYYY-MM-DD_HH-MM)
    snap_date_str=$(echo "$snap" | sed -n 's/snapshot-\(.*\)/\1/p')

    if [[ $snap_date_str =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}_[0-9]{2}-[0-9]{2}$ ]]; then
        snap_epoch=$(date -d "${snap_date_str//_/ }" +%s 2>/dev/null)

        if [[ $? -eq 0 ]]; then
            age_days=$(( (now_epoch - snap_epoch) / 86400 ))

            if (( age_days > RETENTION_DAYS )); then
                echo "Deleting snapshot $snap (age: $age_days days)"
                curl -s -XDELETE "$ES_HOST/_snapshot/$REPO/$snap"
            fi
        fi
    fi
done
