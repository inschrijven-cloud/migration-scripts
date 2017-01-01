#!/bin/bash

. ./export_db_name.sh

QUERY="
SELECT array_to_json(array_agg(row_to_json(t)))
FROM (
  SELECT child_to_shift.child_id, child_to_shift.shift_id, shift.date
  FROM child_to_shift
  JOIN shift ON shift.id = child_to_shift.shift_id
) t
"

psql -d $DB_NAME -U postgres -W -h localhost --command="$QUERY" --no-align --tuples-only

