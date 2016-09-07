#!/bin/bash

. ./export_db_name.sh

QUERY="
SELECT array_to_json(array_agg(row_to_json(t))) FROM (
  SELECT
    shift.id,
    shift.date,
    shift.place,
    shift_type.mnemonic AS shift_type_mnemonic,
    shift_type.description AS shift_type_description
    FROM shift JOIN shift_type ON shift.shift_type = shift_type.id
) t
"

psql -d $DB_NAME -U postgres -W -h 127.0.0.1 --command="$QUERY" --no-align --tuples-only

