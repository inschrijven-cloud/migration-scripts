#!/bin/bash

DB_NAME=speelsysteem_backup_2016_paas

psql -d $DB_NAME -U postgres -W -h localhost --command="SELECT array_to_json(array_agg(row_to_json(animator))) FROM animator" --no-align --tuples-only

