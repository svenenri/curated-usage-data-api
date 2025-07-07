#!/bin/bash
set -e

echo "Waiting for primary to be ready..."
until pg_isready -h user_activity -U replica_user; do
  echo "Primary not ready yet..."
  sleep 2
done

# Clean up old data if it exists
if [ -f /var/lib/postgresql/data/PG_VERSION ]; then
  echo "Removing pre-existing data directory..."
  rm -rf /var/lib/postgresql/data/*
fi

echo "Starting base backup from primary..."
export PGPASSWORD=replica_password
pg_basebackup -h user_activity -D /var/lib/postgresql/data -U replica_user -Fp -Xs -P -R

# Fix ownership and permissions
chown -R postgres:postgres /var/lib/postgresql/data
chmod 0700 /var/lib/postgresql/data

echo "Replica initialized. Dropping privileges and starting PostgreSQL..."
exec gosu postgres postgres
