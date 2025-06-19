curl -XPUT 'http://10.226.71.1:9200/_snapshot/my_backup' -d '{
  "type": "fs",
  "settings": {
    "location": "/mnt/es_backup",
    "compress": true
  }
}'
