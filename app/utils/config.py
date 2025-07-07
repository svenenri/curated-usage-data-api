import os
import hvac
import logging

logger = logging.getLogger(__name__)
_cached_secrets = None

def load_secrets_from_vault():
    global _cached_secrets
    if _cached_secrets:
        return _cached_secrets

    VAULT_URL = os.getenv("VAULT_URL", "http://localhost:8200")
    VAULT_TOKEN = os.getenv("VAULT_TOKEN", "myroot")
    VAULT_SECRET_PATH = os.getenv("VAULT_SECRET_PATH", "secret/data/dau-creds")

    client = hvac.Client(url=VAULT_URL, token=VAULT_TOKEN)
    if not client.is_authenticated():
        raise RuntimeError("Vault authentication failed")

    try:
        secret_path = VAULT_SECRET_PATH.split("secret/data/")[-1]
        secrets = client.secrets.kv.v2.read_secret_version(path=secret_path)['data']['data']
    except Exception as e:
        logger.error(f"Failed to read secrets from Vault: {e}")
        raise

    required_keys = ["api_key", "pg_replica_host", "pg_replica_port", "pg_replica_user", "pg_replica_pw", "pg_replica_name"]
    for key in required_keys:
        if key not in secrets:
            raise RuntimeError(f"Missing required secret: {key}")

    _cached_secrets = secrets
    return secrets
