#!/bin/bash

set -e

source /mnt/tfo-volume-01/ENV/DOCKER_ENV

TWO_WEEKS_IN_SEC=1209600
NOW=$(date +%s)

# Setup

# Check that jq is installed
if ! [ -x "$(command -v jq)" ]; then
  yum install -y jq
fi

# Take a snapshot of the current volume
SNAPSHOT_NAME="tfo-volume-01-${NOW}"
echo "Creating a snapshot: ${SNAPSHOT_NAME}"
curl -X POST -H 'Content-Type: application/json' -H "Authorization: Bearer $DO_API_TOKEN" -d '{"name":"'"${SNAPSHOT_NAME}"'"}' "https://api.digitalocean.com/v2/volumes/$TFO_VOLUME_01_ID/snapshots"

# Delete any snapshots that are older than 2 weeks
mapfile -t  ALL_SNAPSHOTS < <(curl -X GET -H 'Content-Type: application/json' -H "Authorization: Bearer $DO_API_TOKEN" "https://api.digitalocean.com/v2/snapshots" | jq -c '.snapshots |= sort_by(.created_at) | .snapshots[] | select(.resource_type=="volume")')

for snapshot in "${ALL_SNAPSHOTS[@]}"; do
  CREATED_AT=$(echo $snapshot | jq -r .created_at)
  DATE_AS_EPOCH=$(date -d ${CREATED_AT} +"%s")
  ID=$(echo $snapshot | jq -r .id)

  DIFF_IN_DATES=$(expr $NOW - $DATE_AS_EPOCH)
  if [[ $DIFF_IN_DATES -gt $TWO_WEEKS_IN_SEC ]]; then
    echo "Deleting ID=${ID} Created at=${CREATED_AT}"
    curl -X DELETE -H 'Content-Type: application/json' -H "Authorization: Bearer $DO_API_TOKEN" "https://api.digitalocean.com/v2/snapshots/${ID}"
  fi
done
