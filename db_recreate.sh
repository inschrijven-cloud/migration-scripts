#!/bin/bash

curl -X DELETE http://127.0.0.1:5984/some-db
curl -X PUT http://127.0.0.1:5984/some-db

./pg_dump_children.sh | ./normalize_children.sh | curl -X POST http://127.0.0.1:5984/some-db/_bulk_docs -d @- -H 'Content-Type: application/json'
./pg_dump_shifts.sh | ./normalize_shifts.sh | curl -X POST http://127.0.0.1:5984/some-db/_bulk_docs -d @- -H 'Content-Type: application/json'
./pg_dump_crew.sh | ./normalize_crew.sh | curl -X POST http://127.0.0.1:5984/some-db/_bulk_docs -d @- -H 'Content-Type: application/json'


