#!/bin/bash

ES_DIR="/opt/elastic-2.4.3/elasticsearch-2.4.3"
ES_BIN="$ES_DIR/bin/elasticsearch"

# Kill existing process
echo "Stopping Elasticsearch..."
pkill -f elasticsearch

# Wait a bit
sleep 5

# Start again in background
echo "Starting Elasticsearch..."
cd "$ES_DIR"
nohup $ES_BIN > logs/es.out 2>&1 &

echo "Elasticsearch restarted."
