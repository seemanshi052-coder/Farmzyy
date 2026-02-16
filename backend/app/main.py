from fastapi import FastAPI, Request, HTTPException
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware
from starlette.middleware.base import BaseHTTPMiddleware

from slowapi import Limiter
from slowapi.util import get_remote_address
from slowapi.middleware import SlowAPIMiddleware
from slowapi.errors import RateLimitExceeded

from app.routes import chatbot, recommendations, predictions, weather, market, auth
from app.core.logger import logger

# ---------------------------------------------------
# App Initialization
# ---------------------------------------------------

app = FastAPI(title="FarmZyy API", version="1.0.0")

logger.info("Starting FarmZyy backend...")

# ---------------------------------------------------
# CORS Configuration
# ---------------------------------------------------

origins = [
    "http://localhost:3000",
    "http://localhost:8000",
    # Add your frontend production URL here later
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ---------------------------------------------------
# Request Size Limit Middleware (1MB)
# ---------------------------------------------------

class LimitUploadSizeMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        max_size = 1024 * 1024  # 1MB
        content_length = request.headers.get("content-length")

        if content_length and int(content_length) > max_size:
            raise HTTPException(status_code=413, detail="Request too large")

        return await call_next(request)

app.add_middleware(LimitUploadSizeMiddleware)

# ---------------------------------------------------
# Rate Limiting
# ---------------------------------------------------

limiter = Limiter(key_func=get_remote_address)
app.state.limiter = limiter
app.add_middleware(SlowAPIMiddleware)

@app.exception_handler(RateLimitExceeded)
async def rate_limit_handler(request: Request, exc: RateLimitExceeded):
    return JSONResponse(
        status_code=429,
        content={
            "success": False,
            "error": {
                "code": 429,
                "message": "Too many requests"
            }
        },
    )

# ---------------------------------------------------
# Health Check Endpoint
# ---------------------------------------------------

@app.get("/health")
async def health():
    return {
        "success": True,
        "data": {
            "status": "healthy"
        }
    }

# ---------------------------------------------------
# Include Routers
# ---------------------------------------------------

app.include_router(auth.router, prefix="/api/v1/auth", tags=["Auth"])
app.include_router(chatbot.router, prefix="/api/v1", tags=["Chatbot"])
app.include_router(recommendations.router, prefix="/api/v1", tags=["Recommendations"])
app.include_router(predictions.router, prefix="/api/v1", tags=["Predictions"])
app.include_router(weather.router, prefix="/api/v1", tags=["Weather"])
app.include_router(market.router, prefix="/api/v1", tags=["Market"])

# ---------------------------------------------------
# Root Endpoint
# ---------------------------------------------------

@app.get("/")
async def root():
    return {
        "success": True,
        "data": {
            "message": "FarmZyy API is running"
        }
    }

# ---------------------------------------------------
# Global Exception Handler
# ---------------------------------------------------

@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    logger.error(f"Unhandled error: {str(exc)}")
    return JSONResponse(
        status_code=500,
        content={
            "success": False,
            "error": {
                "code": 500,
                "message": "Internal server error"
            }
        },
    )
