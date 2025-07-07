from pydantic import BaseModel, Field
from typing import List

class DAUResponse(BaseModel):
    date: str = Field(..., example="2025-06-20")
    count: int = Field(..., example=150)

class DAUResults(BaseModel):
    start_date: str = Field(..., example="2025-06-20")
    end_date: str = Field(..., example="2025-06-22")
    daily_active_users: List[DAUResponse]
