#!/bin/bash
set -e

echo "Waiting for Vault to become ready..."
until curl -s http://vault:8200/v1/sys/health | grep '"initialized":true' > /dev/null; do
  sleep 2
done

echo "Fetching credentials from Vault..."
export POSTGRES_PRIMARY_USER=$(vault kv get -field=pg_primary_user secret/dau-creds)
export POSTGRES_PRIMARY_PASSWORD=$(vault kv get -field=pg_primary_pw secret/dau-creds)

export POSTGRES_REPLICA_USER=$(vault kv get -field=pg_replica_user secret/dau-creds)
export POSTGRES_REPLICA_PASSWORD=$(vault kv get -field=pg_replica_pw secret/dau-creds)

export REPLICATION_USER=$(vault kv get -field=pg_replication_user secret/dau-creds)
export REPLICATION_PASSWORD=$(vault kv get -field=pg_replication_pw secret/dau-creds)

echo "Starting PostgreSQL with Vault-sourced credentials..."
exec env \
  POSTGRES_USER=$POSTGRES_USER \
  POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
  POSTGRES_DB=$POSTGRES_DB \
  REPLICATION_USER=$REPLICATION_USER \
  REPLICATION_PASSWORD=$REPLICATION_PASSWORD \
  docker-entrypoint.sh postgres
