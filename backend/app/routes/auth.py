from fastapi import APIRouter, Depends
from app.core.security import verify_token

router = APIRouter()

@router.post("/auth/login")
def login(user=Depends(verify_token)):

    return {
        "success": True,
        "data": {
            "user_id": user["uid"],
            "access_token": "firebase_verified"
        }
    }
