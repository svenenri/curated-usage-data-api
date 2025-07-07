from fastapi import APIRouter, HTTPException, Query, Depends
from datetime import datetime
import logging
from app.models import DAUResults, DAUResponse
from app.db import get_readonly_db_connection
from app.cache import get_redis_client
from app.auth import verify_api_key

router = APIRouter(tags=["Usage Metrics"])

@router.get("/v1/daily-active-users", response_model=DAUResults, dependencies=[Depends(verify_api_key)])
def get_dau(start_date: str = Query(..., description="Start date in YYYY-MM-DD format"),
            end_date: str = Query(..., description="End date in YYYY-MM-DD format")):
    try:
        start = datetime.strptime(start_date, "%Y-%m-%d")
        end = datetime.strptime(end_date, "%Y-%m-%d")
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid date format. Use YYYY-MM-DD.")

    if end < start:
        raise HTTPException(status_code=400, detail="end_date must be after start_date.")

    logger = logging.getLogger(__name__)
    redis_client = get_redis_client()
    cache_key = f"dau:{start_date}:{end_date}"
    cached = redis_client.get(cache_key)
    if cached:
        logger.info(f"Cache hit for {cache_key}")
        return DAUResults.model_validate_json(cached) 

    try:
        conn = get_readonly_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT activity_date, active_user_count FROM daily_active_users WHERE activity_date BETWEEN %s AND %s ORDER BY activity_date",
                       (start_date, end_date))
        rows = cursor.fetchall()
        cursor.close()
        conn.close()
    except Exception as e:
        logger.error(f"Database query failed: {e}")
        raise HTTPException(status_code=500, detail="Database query error")

    data = [DAUResponse(date=row[0].strftime("%Y-%m-%d"), count=row[1]) for row in rows]
    response = DAUResults(start_date=start_date, end_date=end_date, daily_active_users=data)

    redis_client.setex(cache_key, 3600, response.model_dump_json())
    logger.info(f"Cached result under key {cache_key}")

    return response
