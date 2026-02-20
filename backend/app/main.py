from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from app.routes import (
    auth,
    chatbot,
    recommendations,
    predictions,
    weather,
    market
)

from app.core.logger import logger


app = FastAPI(title="FarmZyy API")


# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Routers
app.include_router(auth.router, prefix="/api/v1")
app.include_router(chatbot.router, prefix="/api/v1")
app.include_router(recommendations.router, prefix="/api/v1")
app.include_router(predictions.router, prefix="/api/v1")
app.include_router(weather.router, prefix="/api/v1")
app.include_router(market.router, prefix="/api/v1")


# Global Error Handler
@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):

    logger.error(f"Unhandled error: {exc}")

    return JSONResponse(
        status_code=500,
        content={
            "success": False,
            "error": {
                "code": 500,
                "message": str(exc)
            }
        }
    )


# Health Check
@app.get("/health")
def health():

    logger.info("Health check called")

    return {
        "success": True,
        "data": {
            "status": "ok"
        }
    }
