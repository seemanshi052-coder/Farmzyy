from fastapi import APIRouter, HTTPException, status

from app.schemas.user_schema import LoginRequest
from app.security import create_access_token
from app.utils.helpers import success_response, error_response
from app.utils.logger import get_logger

router = APIRouter()

logger = get_logger(__name__)


@router.post("/login")
async def login(request: LoginRequest):
    """
    User Login Endpoint
    """

    try:
        user_id = request.user_id
        password = request.password

        # 🔥 TODO: Replace with real DB authentication
        # For now we accept any user with password length > 3
        if len(password) < 3:
            return error_response(
                code=400,
                message="Invalid credentials"
            )

        access_token = create_access_token(user_id=user_id)

        return success_response(
            data={
                "access_token": access_token,
                "user_id": user_id
            },
            message="Login successful"
        )

    except Exception as e:
        logger.error(f"Login error: {str(e)}")

        return error_response(
            code=500,
            message="Internal server error"
        )
