#!/bin/bash

DB_NAME=speelsysteem_backup_2016_paas

psql -d $DB_NAME -U postgres -W -h localhost --command="SELECT array_to_json(array_agg(row_to_json(child))) FROM child" --no-align --tuples-only

