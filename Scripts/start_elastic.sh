#!/bin/bash

# Navigate to the Elasticsearch folder
cd /opt/elastic-2.4.3/elasticsearch-2.4.3

# Start Elasticsearch in background and write output to a log file
nohup ./bin/elasticsearch > logs/es.out 2>&1 &
