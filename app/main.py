from fastapi import FastAPI
from app.routes import dau
from app.utils.logger import setup_logger

app = FastAPI(title="Curated Usage Data API", version="1.0.0")
setup_logger()

app.include_router(dau.router)

@app.get("/healthcheck", tags=["Health"])
def healthcheck():
    return {"status": "ok"}
