#!/bin/bash

. ./export_db_name.sh

QUERY="
SELECT array_to_json(array_agg(row_to_json(t)))
FROM (
  SELECT *
  FROM child_to_shift
) t
"

psql -d $DB_NAME -U postgres -W -h localhost --command="$QUERY" --no-align --tuples-only

