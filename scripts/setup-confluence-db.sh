#!/bin/bash
echo "******CREATING CONFLUENCE DATABASE******"
psql --username postgres <<- EOSQL
   CREATE DATABASE confluence WITH ENCODING 'utf8';
   CREATE USER confluenceuser;
   GRANT ALL PRIVILEGES ON DATABASE confluence to confluenceuser;
EOSQL
echo ""

{ echo; echo "host confluence confluence 0.0.0.0/0 trust"; } >> \
  "$PGDATA"/pg_hba.conf

if [ -r '/tmp/dumps/confluence.dump' ]; then
    echo "***IMPORTING CONFLUENCE DATABASE BACKUP***"
    gosu postgres postgres &
    SERVER=$!; sleep 2
    gosu postgres psql confluence < /tmp/dumps/confluence.dump
    kill $SERVER; wait $SERVER
    echo "***CONFLUENCE DATABASE BACKUP IMPORTED***"
else
    echo "**NO DATABASE BACKUP FILE PRESENT => IMPORT SKIPPED***"
fi

echo ""
echo "******CONFLUENCE DATABASE CREATED******"