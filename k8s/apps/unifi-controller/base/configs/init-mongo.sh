#!/bin/bash
# Runs once from /docker-entrypoint-initdb.d on an empty /data/db.
# Creates the UniFi application user with ownership of every database
# the Network Application uses (main, _stat, _audit, _restore).
set -euo pipefail

mongo --quiet --host 127.0.0.1 \
  --username "${MONGO_INITDB_ROOT_USERNAME}" \
  --password "${MONGO_INITDB_ROOT_PASSWORD}" \
  --authenticationDatabase admin \
  "${MONGO_AUTHSOURCE}" <<EOF
db.createUser({
  user: "${MONGO_USER}",
  pwd: "${MONGO_PASS}",
  roles: [
    "clusterMonitor",
    { db: "${MONGO_DBNAME}", role: "dbOwner" },
    { db: "${MONGO_DBNAME}_stat", role: "dbOwner" },
    { db: "${MONGO_DBNAME}_audit", role: "dbOwner" },
    { db: "${MONGO_DBNAME}_restore", role: "dbOwner" }
  ]
})
EOF
