import os
import redis

def get_redis_client():
    redis_host = os.getenv("REDIS_HOST", "redis")
    redis_port = int(os.getenv("REDIS_PORT", "6379"))
    return redis.Redis(host=redis_host, port=redis_port, decode_responses=True)
