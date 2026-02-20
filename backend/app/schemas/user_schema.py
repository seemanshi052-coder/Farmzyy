from pydantic import BaseModel, Field


class LoginRequest(BaseModel):
    user_id: str = Field(..., example="farmer123")
    password: str = Field(..., example="password")


class LoginResponseData(BaseModel):
    access_token: str
    user_id: str
