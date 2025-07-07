import pytest
from fastapi.testclient import TestClient
from unittest.mock import patch
from app.main import app

client = TestClient(app)
MOCK_API_KEY = "mockkey"

@patch("app.utils.config.load_secrets_from_vault", return_value={"api_key": MOCK_API_KEY})
def test_healthcheck(mock_vault):
    response = client.get("/healthcheck")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}

@patch("app.utils.config.load_secrets_from_vault", return_value={"api_key": MOCK_API_KEY})
def test_auth_required(mock_vault):
    response = client.get("/v1/daily-active-users?start_date=2024-07-20&end_date=2024-07-22")
    assert response.status_code == 422  # Missing required header

@patch("app.utils.config.load_secrets_from_vault", return_value={"api_key": MOCK_API_KEY})
def test_invalid_api_key(mock_vault):
    response = client.get(
        "/v1/daily-active-users?start_date=2024-07-20&end_date=2024-07-22",
        headers={"x-api-key": "wrongkey"}
    )
    assert response.status_code == 401
    assert response.json()["detail"] == "Invalid API Key"

@patch("app.auth.load_secrets_from_vault", return_value={"api_key": MOCK_API_KEY})
def test_invalid_date_format(mock_vault):
    response = client.get(
        "/v1/daily-active-users?start_date=20-07-2024&end_date=2024-07-22",
        headers={"x-api-key": MOCK_API_KEY}
    )
    assert response.status_code == 400
    assert "Invalid date format" in response.json()["detail"]

@patch("app.auth.load_secrets_from_vault", return_value={"api_key": MOCK_API_KEY})
def test_enddate_greater_than_startdate(mock_vault):
    response = client.get(
        "/v1/daily-active-users?start_date=2024-07-31&end_date=2024-07-22",
        headers={"x-api-key": MOCK_API_KEY}
    )
    assert response.status_code == 400
    assert "end_date must be after start_date." in response.json()["detail"]

@patch("app.auth.load_secrets_from_vault", return_value={"api_key": MOCK_API_KEY})
def test_valid_dau_query(mock_vault):
    response = client.get(
        "/v1/daily-active-users?start_date=2024-07-20&end_date=2024-07-22",
        headers={"x-api-key": MOCK_API_KEY}
    )
    assert response.status_code == 200
    json_data = response.json()
    assert "daily_active_users" in json_data
    assert isinstance(json_data["daily_active_users"], list)
