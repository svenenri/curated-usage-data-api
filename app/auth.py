from fastapi import Header, HTTPException
from app.utils.config import load_secrets_from_vault

def verify_api_key(x_api_key: str = Header(...)):
    expected_key = load_secrets_from_vault()["api_key"]
    if x_api_key != expected_key:
        raise HTTPException(status_code=401, detail="Invalid API Key")
