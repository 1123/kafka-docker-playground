docker exec -e SERVICENOW_URL="$SERVICENOW_URL" -e SERVICENOW_PASSWORD="$SERVICENOW_PASSWORD" connect \
   curl -X POST \
    "${SERVICENOW_URL}/api/now/table/incident" \
    --user admin:"$SERVICENOW_PASSWORD" \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    -H 'cache-control: no-cache' \
    -d '{"short_description": "another test"}'
