from fastapi import APIRouter, Depends

from app.schemas.chatbot import ChatRequest
from app.services.chat_service import chat_service
from app.core.security import verify_token
from app.middleware.rate_limiter import chat_rate_limiter


router = APIRouter(prefix="/chatbot", tags=["Chatbot"])


@router.post("/chat")
def chat(
    request: ChatRequest,
    user_id: str = Depends(verify_token),
    _=Depends(chat_rate_limiter)
):

    try:

        result = chat_service.chat(
            user_id=user_id,
            message=request.message
        )

        return {
            "success": True,
            "data": result
        }

    except Exception as e:

        return {
            "success": False,
            "error": {
                "code": 500,
                "message": str(e)
            }
        }
