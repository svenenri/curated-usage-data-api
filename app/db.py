import psycopg2
from app.utils.config import load_secrets_from_vault
import logging

logger = logging.getLogger(__name__)

def get_readonly_db_connection():
    secrets = load_secrets_from_vault()
    db_config = {
        "host": secrets.get("pg_replica_host", "user_activity_replica"),
        "port": secrets.get("pg_replica_port", "5432"),
        "user": secrets.get("pg_replica_user", "replica_user"),
        "password": secrets.get("pg_replica_pw", "replica_password"),
        "dbname": secrets.get("pg_replica_name", "replica_db")
    }
    try:
        return psycopg2.connect(**db_config)
    except Exception as e:
        logger.error(f"Error connecting to read replica: {e}")
        raise

def get_db_connection():
    secrets = load_secrets_from_vault()
    db_config = {
        "host": secrets["pg_replica_host"],
        "port": secrets["pg_replica_port"],
        "user": secrets["pg_replica_user"],
        "password": secrets["pg_replica_pw"],
        "dbname": secrets["pg_replica_name"]
    }
    try:
        return psycopg2.connect(**db_config)
    except Exception as e:
        logger.error(f"Error connecting to database: {e}")
        raise
