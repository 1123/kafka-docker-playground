docker exec -i connect kafka-json-schema-console-producer --broker-list broker:9092 --property schema.registry.url=http://schema-registry:8081 --topic ordersjs --property value.schema='{
	"$schema": "https://json-schema.org/draft/2019-09/schema",
    "additionalProperties": false,
    "properties": {
      "id": {"type": "number"},
      "product": { "type": "string" },
      "quantity": {"type": "number"},
      "price": {"type": "number"}
    },
    "required": ["id", "product", "price"]
}' << EOF
{"id": 998, "product": "foo", "quantity": 100, "price": 50} 
{"id": 999, "product": "bar", "quantity": 200, "price": 70} 
EOF

curl -X PUT \
     -H "Content-Type: application/json" \
     --data '{
               "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
               "tasks.max": "1",
               "connection.url": "jdbc:mysql://mysql:3306/db?user=user&password=password&useSSL=false",
               "topics": "ordersjs",
               "value.converter": "io.confluent.connect.json.JsonSchemaConverter",
               "value.converter.schema.registry.url": "http://schema-registry:8081",
               "auto.create": "true"
          }' \
     http://localhost:8083/connectors/mysql-sink-js/config | jq .


docker exec mysql bash -c "mysql --user=root --password=password --database=db -e 'describe ordersjs'"

docker exec mysql bash -c "mysql --user=root --password=password --database=db -e 'select * from ordersjs'" 
