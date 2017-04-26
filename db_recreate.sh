#!/bin/bash

COUCHDB_DB_NAME="tenant-data-sometenant"
HOST="http://127.0.0.1:5984"

DB_CHILDREN="${COUCHDB_DB_NAME}-children"
DB_DAYS="${COUCHDB_DB_NAME}-days"
DB_CREW="${COUCHDB_DB_NAME}-crew"
DB_CHILD_ATTENDANCE="${COUCHDB_DB_NAME}-childattendance"

curl -X DELETE ${HOST}/${DB_CHILDREN}
curl -X DELETE ${HOST}/${DB_DAYS}
curl -X DELETE ${HOST}/${DB_CREW}
curl -X DELETE ${HOST}/${DB_CHILD_ATTENDANCE}

curl -X PUT ${HOST}/${DB_CHILDREN}
curl -X PUT ${HOST}/${DB_DAYS}
curl -X PUT ${HOST}/${DB_CREW}
curl -X PUT ${HOST}/${DB_CHILD_ATTENDANCE}

./pg_dump_children.sh | ./normalize_children.sh | curl -X POST ${HOST}/${DB_CHILDREN}/_bulk_docs -d @- -H 'Content-Type: application/json'
./medical_files/normalize_medical_files.js --input medical_files/2016_Medische_fiche_De_Speelberg_Responses_-_Form_responses_1.csv | curl -X POST ${HOST}/${DB_CHILDREN}/_bulk_docs -d @- -H 'Content-Type: application/json'
./pg_dump_shifts.sh | ./normalize_shifts.sh | curl -X POST ${HOST}/${DB_DAYS}/_bulk_docs -d @- -H 'Content-Type: application/json'
./pg_dump_crew.sh | ./normalize_crew.sh | curl -X POST ${HOST}/${DB_CREW}/_bulk_docs -d @- -H 'Content-Type: application/json'
./pg_dump_child_attendances.sh | ./normalize_child_attendances.sh | curl -X POST ${HOST}/${DB_CHILD_ATTENDANCE}/_bulk_docs -d @- -H 'Content-Type: application/json'

