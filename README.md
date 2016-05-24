# Migration scripts

To migrate from the old, Postgres-backed speelsysteem application, I use these migration scripts.

## Children

```
./pg_dump_children.sh | ./normalize_children.sh | curl -X POST http://127.0.0.1:5984/some-db/_bulk_docs -d @- -H 'Content-Type: application/json'
```

## Shifts

```
./pg_dump_shifts.sh | ./normalize_shifts.sh | curl -X POST http://127.0.0.1:5984/some-db/_bulk_docs -d @- -H 'Content-Type: application/json'
```

