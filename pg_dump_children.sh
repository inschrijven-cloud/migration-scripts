#!/bin/bash

DB_NAME=speelsysteem_backup_2016_paas

QUERY="
SELECT array_to_json(array_agg(row_to_json(t)))
FROM (
  SELECT child.*, (
    SELECT array_to_json(array_agg(to_char(shift.date, 'YYYY-MM-DD') || '/'  || shift_type.mnemonic)) AS attendances
    FROM child_to_shift JOIN shift ON shift.id = child_to_shift.shift_id JOIN shift_type ON shift.shift_type = shift_type.id
    WHERE child_id = child.id
  )
  FROM child
) t
"

psql -d $DB_NAME -U postgres -W -h localhost --command="$QUERY" --no-align --tuples-only

