#!/bin/bash
set -e

echo "Waiting for Vault to be ready..."
until curl -s http://vault:8200/v1/sys/health | grep -q 'initialized'; do
  sleep 1
done

echo "Logging into Vault..."
export VAULT_ADDR=http://vault:8200
vault login myroot

echo "Writing secrets to Vault..."
vault kv put secret/dau-creds \
  api_key=supersecretkey \
  pg_primary_host=user_activity \
  pg_primary_port=5432 \
  pg_primary_user=primary_user \
  pg_primary_pw=primary_postgres \
  pg_primary_name=user_activity \
  pg_replica_host=user_activity_replica \
  pg_replica_port=5432 \
  pg_replica_user=replica_user \
  pg_replica_pw=replica_password \
  pg_replica_name=user_activity 
