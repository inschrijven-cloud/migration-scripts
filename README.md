# Migration scripts

To migrate from the old, Posgres-backed speelsysteem application, I use these migration scripts.

## Children

```
./pg_dump_children.sh | ./normalize_children.sh | curl -X POST http://127.0.0.1:5984/children/_bulk_docs -d @- -H 'Content-Type: application/json'
```


